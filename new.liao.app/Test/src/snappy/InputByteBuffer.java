package snappy;

import java.util.Arrays;

/**
 * Created by kevin on 7/9/14.
 */
public class InputByteBuffer
{
    private static final InputByteBuffer EMPTY_BUFFER = new InputByteBuffer(new byte[0]);
    private final byte[] buf;
    private int index = 0;
    private int markerIndex = 0;

    public InputByteBuffer(byte[] buf)
    {
        this.buf = buf;
    }

    public byte[] array()
    {
        return buf;
    }

    public byte getByte(int offset)
    {
        checkIndex(offset, 1);
        return buf[offset];
    }

    public int getIndex()
    {
        return index;
    }

    public int getInt(int offset)
    {
        checkIndex(offset, 4);
        return (buf[offset] & 0xff) << 24 | (buf[offset + 1] & 0xff) << 16 | (buf[offset + 2] & 0xff) << 8
                | buf[offset + 3] & 0xff;
    }

    public short getUnsignedByte(int offset)
    {
        return (short) (getByte(offset) & 0xFF);
    }

    public int getUnsignedMedium(int offset)
    {
        return (buf[offset] & 0xff) << 16 | (buf[offset + 1] & 0xff) << 8 | buf[offset + 2] & 0xff;
    }

    public boolean isReadable()
    {
        return index < buf.length;
    }

    public int length()
    {
        return buf.length;
    }

    public void markIndex()
    {
        markerIndex = index;
    }

    public byte readByte()
    {
        checkReadableBytes(1);
        return buf[index++];
    }

    public InputByteBuffer readBytes(byte[] bytes)
    {
        checkReadableBytes(bytes.length);
        System.arraycopy(buf, index, bytes, 0, bytes.length);
        setIndex(index + bytes.length);
        return this;
    }

    public int readInt()
    {
        checkReadableBytes(4);
        int result = getInt(index);
        index += 4;
        return result;
    }

    public short readShort()
    {
        checkReadableBytes(2);
        short result = (short) (buf[index] << 8 | buf[index + 1] & 0xFF);
        index += 2;
        return result;
    }

    public InputByteBuffer readSlice(int length)
    {
        if (length == 0)
        {
            return EMPTY_BUFFER;
        }
        if (index + length > buf.length)
        {
            throw new IndexOutOfBoundsException();
        }

        InputByteBuffer result = new InputByteBuffer(Arrays.copyOfRange(buf, index, index + length));
        index += length;
        return result;
    }

    public short readUnsignedByte()
    {
        return (short) (readByte() & 0xFF);
    }

    public int readUnsignedMedium()
    {
        checkReadableBytes(3);
        int result = (buf[index] & 0xff) << 16 | (buf[index + 1] & 0xff) << 8 | buf[index + 2] & 0xff;
        index += 3;
        return result;
    }

    public int readableBytes()
    {
        return buf.length - index;
    }

    public void resetIndex()
    {
        index = markerIndex;
    }

    public void setIndex(int value)
    {
        this.index = value;
    }

    public InputByteBuffer skipBytes(int length)
    {
        checkReadableBytes(length);
        setIndex(index + length);
        return this;
    }

    private void checkIndex(int offset, int length)
    {
        if (offset + length > buf.length)
        {
            throw new ArrayIndexOutOfBoundsException();
        }
    }

    private void checkReadableBytes(int length)
    {
        checkIndex(index, length);
    }
}