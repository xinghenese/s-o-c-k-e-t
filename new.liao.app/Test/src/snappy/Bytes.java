package snappy;

/**
 * Created by kevin on 7/8/14.
 */
public class Bytes
{
    /**
     * Compares the two byte array.
     * 
     * @param first
     *            the first one.
     * @param second
     *            the second one.
     * @return true if equals, false for otherwise.
     */
    public static boolean equalBytes(byte[] first, byte[] second)
    {
        if (first == second)
        {
            return true;
        }

        if (first == null || second == null)
        {
            return false;
        }

        if (first.length != second.length)
        {
            return false;
        }

        for (int i = 0; i < first.length; ++i)
        {
            if (first[i] != second[i])
            {
                return false;
            }
        }

        return true;
    }

    /**
     * Toggles the endianness of the specified 32-bit integer.
     */
    public static int swapInt(int value)
    {
        return Integer.reverseBytes(value);
    }

    /**
     * Toggles the endianness of the specified 24-bit medium integer.
     */
    public static int swapMedium(int value)
    {
        int swapped = value << 16 & 0xff0000 | value & 0xff00 | value >>> 16 & 0xff;
        if ((swapped & 0x800000) != 0)
        {
            swapped |= 0xff000000;
        }
        return swapped;
    }

    /**
     * Toggles the endianness of the specified 16-bit short integer.
     */
    public static short swapShort(short value)
    {
        return Short.reverseBytes(value);
    }
}