package snappy;

public class SnappyFramedEncoder
{
    /**
     * The minimum amount that we'll consider actually attempting to compress.
     * This value is preamble + the minimum length our Snappy service will
     * compress (instead of just emitting a literal).
     */
    private static final int MIN_COMPRESSIBLE_LENGTH = 18;

    /**
     * All streams should start with the "Stream identifier", containing chunk
     * type 0xff, a length field of 0x6, and 'sNaPpY' in ASCII.
     */
    private static final byte[] STREAM_START = { (byte) 0xff, 0x06, 0x00, 0x00, 0x73, 0x4e, 0x61, 0x50, 0x70, 0x59 };
    private final Snappy snappy = new Snappy();
    private boolean started;

    public byte[] encode(byte[] bytes) throws Exception
    {
        InputByteBuffer in = new InputByteBuffer(bytes);
        OutputByteBuffer out = new OutputByteBuffer();
        encode(in, out);
        return out.getBytes();
    }

    private void encode(InputByteBuffer in, OutputByteBuffer out) throws Exception
    {
        if (!in.isReadable())
        {
            return;
        }

        if (!started)
        {
            started = true;
            out.writeBytes(STREAM_START);
        }

        int dataLength = in.readableBytes();
        if (dataLength > MIN_COMPRESSIBLE_LENGTH)
        {
            while (true)
            {
                final int lengthIdx = out.getIndex() + 1;
                if (dataLength < MIN_COMPRESSIBLE_LENGTH)
                {
                    InputByteBuffer slice = in.readSlice(dataLength);
                    writeUnencodedChunk(slice, out, dataLength);
                    break;
                }

                out.writeInt(0);
                if (dataLength > Short.MAX_VALUE)
                {
                    InputByteBuffer slice = in.readSlice(Short.MAX_VALUE);
                    calculateAndWriteChecksum(slice, out);
                    snappy.encode(slice, out);
                    setChunkLength(out, lengthIdx);
                    dataLength -= Short.MAX_VALUE;
                }
                else
                {
                    InputByteBuffer slice = in.readSlice(dataLength);
                    calculateAndWriteChecksum(slice, out);
                    snappy.encode(slice, out);
                    setChunkLength(out, lengthIdx);
                    break;
                }
            }
        }
        else
        {
            writeUnencodedChunk(in, out, dataLength);
        }
    }

    /**
     * Calculates and writes the 4-byte checksum to the output array
     * 
     * @param slice
     *            The data to calculate the checksum for
     * @param out
     *            The output array to write the checksum to
     */
    private static void calculateAndWriteChecksum(InputByteBuffer slice, OutputByteBuffer out)
    {
        out.writeInt(Bytes.swapInt(Snappy.calculateChecksum(slice)));
    }

    private static void setChunkLength(OutputByteBuffer out, int lengthIdx)
    {
        int chunkLength = out.getIndex() - lengthIdx - 3;
        if (chunkLength >>> 24 != 0)
        {
            throw new SnappyException("compressed data too large: " + chunkLength);
        }
        out.setMedium(lengthIdx, Bytes.swapMedium(chunkLength));
    }

    /**
     * Writes the 2-byte chunk length to the output array.
     * 
     * @param out
     *            The array to write to
     * @param chunkLength
     *            The length to write
     */
    private static void writeChunkLength(OutputByteBuffer out, int chunkLength)
    {
        out.writeMedium(Bytes.swapMedium(chunkLength));
    }

    private static void writeUnencodedChunk(InputByteBuffer in, OutputByteBuffer out, int dataLength)
    {
        out.writeByte((byte) 1);
        writeChunkLength(out, dataLength + 4);
        calculateAndWriteChecksum(in, out);
        out.writeBytes(in.array(), in.getIndex(), dataLength);
    }
}
