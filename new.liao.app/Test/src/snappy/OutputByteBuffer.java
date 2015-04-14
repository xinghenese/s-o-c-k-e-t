package snappy;

/**
 * Created by kevin on 7/9/14.
 */
public class OutputByteBuffer
{
    private static final int DEFAULT_CAPACITY = 256;
    private byte[] buf;
    private int index;

    public OutputByteBuffer()
    {
        this(DEFAULT_CAPACITY);
    }

    public OutputByteBuffer(int capacity)
    {
        this.buf = new byte[capacity];
    }

    public byte[] array()
    {
        return buf;
    }

    public void ensureWritable(int length)
    {
        if (buf.length - index > length)
        {
            return;
        }

        int capacity = (buf.length + length) | 0xff;
        expand(capacity);
    }

    public byte[] getBytes()
    {
        byte[] bytes = new byte[index];
        System.arraycopy(buf, 0, bytes, 0, index);
        return bytes;
    }

    public int getIndex()
    {
        return index;
    }

    public void setMedium(int index, int value)
    {
        buf[index] = (byte) (value >>> 16);
        buf[index + 1] = (byte) (value >>> 8);
        buf[index + 2] = (byte) value;
    }

    public void writeByte(byte b)
    {
        checkCapacity(1);
        buf[index++] = b;
    }

    public void writeBytes(byte[] bytes)
    {
        writeBytes(bytes, 0, bytes.length);
    }

    public void writeBytes(byte[] bytes, int offset, int length)
    {
        checkCapacity(length);
        System.arraycopy(bytes, offset, buf, this.index, length);
        this.index += length;
    }

    public void writeInt(int value)
    {
        checkCapacity(4);
        buf[index++] = (byte) (value >>> 24);
        buf[index++] = (byte) (value >>> 16);
        buf[index++] = (byte) (value >>> 8);
        buf[index++] = (byte) value;
    }

    public void writeMedium(int value)
    {
        checkCapacity(3);
        buf[index++] = (byte) (value >>> 16);
        buf[index++] = (byte) (value >>> 8);
        buf[index++] = (byte) value;
    }

    private void checkCapacity(int expandLength)
    {
        while (index + expandLength > buf.length)
        {
            expand();
        }
    }

    private void expand()
    {
        expand(buf.length << 1);
    }

    private void expand(int capacity)
    {
        byte[] newBuf = new byte[capacity];
        System.arraycopy(buf, 0, newBuf, 0, index);
        this.buf = newBuf;
    }
}