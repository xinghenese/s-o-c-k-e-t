package snappy;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SnappyFramedDecoder
{
    private static final byte[] SNAPPY = { 's', 'N', 'a', 'P', 'p', 'Y' };
    private final Snappy snappy = new Snappy();
    private final boolean validateChecksums;
    private boolean started;
    private boolean corrupted;

    public SnappyFramedDecoder()
    {
        this(false);
    }

    public SnappyFramedDecoder(boolean validateChecksums)
    {
        this.validateChecksums = validateChecksums;
    }

    /**
     * Decodes the snappy encoded bytes.
     * 
     * @param bytes
     *            the encoded bytes.
     * @return the chunks of decoded bytes, never return null.
     * @throws Exception
     *             if error occurred while decoding.
     */
    public byte[] decode(byte[] bytes) throws Exception
    {
        InputByteBuffer in = new InputByteBuffer(bytes);
        List<byte[]> out = new ArrayList<byte[]>();
        while (in.isReadable())
        {
            int outSize = out.size();
            int oldInputLength = in.readableBytes();
            decode(in, out);

            if (outSize == out.size())
            {
                if (oldInputLength == in.readableBytes())
                {
                    break;
                }
                else
                {
                    continue;
                }
            }

            if (oldInputLength == in.readableBytes())
            {
                throw new SnappyException(".decode() did not read anything but decoded a message.");
            }
        }

        // we calculate the total bytes to avoid multiple memory allocation.
        int len = 0;
        for (byte[] each : out)
        {
            len += each.length;
        }
        OutputByteBuffer buf = new OutputByteBuffer(len);
        for (byte[] each : out)
        {
            buf.writeBytes(each);
        }
        return buf.getBytes();
    }

    protected void decode(InputByteBuffer in, List<byte[]> out) throws Exception
    {
        if (corrupted)
        {
            in.skipBytes(in.readableBytes());
            return;
        }

        try
        {
            int index = in.getIndex();
            final int inSize = in.readableBytes();
            if (inSize < 4)
            {
                // We need to be at least able to read the chunk type identifier
                // (one byte),
                // and the length of the chunk (3 bytes) in order to proceed
                return;
            }

            final int chunkTypeVal = in.getUnsignedByte(index);
            final ChunkType chunkType = mapChunkType((byte) chunkTypeVal);
            final int chunkLength = Bytes.swapMedium(in.getUnsignedMedium(index + 1));

            switch (chunkType)
            {
                case STREAM_IDENTIFIER:
                    if (chunkLength != SNAPPY.length)
                    {
                        throw new SnappyException("Unexpected length of stream identifier: " + chunkLength);
                    }

                    if (inSize < 4 + SNAPPY.length)
                    {
                        break;
                    }

                    byte[] identifier = new byte[chunkLength];
                    in.skipBytes(4).readBytes(identifier);

                    if (!Arrays.equals(identifier, SNAPPY))
                    {
                        throw new SnappyException("Unexpected stream identifier contents. Mismatched snappy "
                                + "protocol version?");
                    }

                    started = true;
                    break;
                case RESERVED_SKIPPABLE:
                    if (!started)
                    {
                        throw new SnappyException("Received RESERVED_SKIPPABLE tag before STREAM_IDENTIFIER");
                    }

                    if (inSize < 4 + chunkLength)
                    {
                        // TODO: Don't keep skippable bytes
                        return;
                    }

                    in.skipBytes(4 + chunkLength);
                    break;
                case RESERVED_UNSKIPPABLE:
                    // The spec mandates that reserved unskippable chunks must
                    // immediately
                    // return an error, as we must assume that we cannot decode
                    // the stream
                    // correctly
                    throw new SnappyException("Found reserved unskippable chunk type: 0x"
                            + Integer.toHexString(chunkTypeVal));
                case UNCOMPRESSED_DATA:
                    if (!started)
                    {
                        throw new SnappyException("Received UNCOMPRESSED_DATA tag before STREAM_IDENTIFIER");
                    }
                    if (chunkLength > 65536 + 4)
                    {
                        throw new SnappyException("Received UNCOMPRESSED_DATA larger than 65540 bytes");
                    }

                    if (inSize < 4 + chunkLength)
                    {
                        return;
                    }

                    in.skipBytes(4);
                    if (validateChecksums)
                    {
                        int checksum = Bytes.swapInt(in.readInt());
                        Snappy.validateChecksum(checksum, in, in.getIndex(), chunkLength - 4);
                    }
                    else
                    {
                        in.skipBytes(4);
                    }
                    out.add(in.readSlice(chunkLength - 4).array());
                    break;
                case COMPRESSED_DATA:
                    if (!started)
                    {
                        throw new SnappyException("Received COMPRESSED_DATA tag before STREAM_IDENTIFIER");
                    }

                    if (inSize < 4 + chunkLength)
                    {
                        return;
                    }

                    in.skipBytes(4);
                    int checksum = Bytes.swapInt(in.readInt());
                    OutputByteBuffer uncompressed = new OutputByteBuffer();
                    snappy.decode(in.readSlice(chunkLength - 4), uncompressed);
                    if (validateChecksums)
                    {
                        InputByteBuffer inUncompressed = new InputByteBuffer(uncompressed.array());
                        Snappy.validateChecksum(checksum, inUncompressed, 0, uncompressed.getIndex());
                    }
                    out.add(uncompressed.getBytes());
                    snappy.reset();
                    break;
            }
        }
        catch (Exception e)
        {
            corrupted = true;
            throw e;
        }
    }

    /**
     * Decodes the chunk type from the type tag byte.
     * 
     * @param type
     *            The tag byte extracted from the stream
     * @return The appropriate {@link ChunkType}, defaulting to
     *         {@link ChunkType#RESERVED_UNSKIPPABLE}
     */
    static ChunkType mapChunkType(byte type)
    {
        if (type == 0)
        {
            return ChunkType.COMPRESSED_DATA;
        }
        else if (type == 1)
        {
            return ChunkType.UNCOMPRESSED_DATA;
        }
        else if (type == (byte) 0xff)
        {
            return ChunkType.STREAM_IDENTIFIER;
        }
        else if ((type & 0x80) == 0x80)
        {
            return ChunkType.RESERVED_SKIPPABLE;
        }
        else
        {
            return ChunkType.RESERVED_UNSKIPPABLE;
        }
    }

    enum ChunkType
    {
        STREAM_IDENTIFIER, COMPRESSED_DATA, UNCOMPRESSED_DATA, RESERVED_UNSKIPPABLE, RESERVED_SKIPPABLE
    }
}