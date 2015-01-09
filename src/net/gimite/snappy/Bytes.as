package net.gimite.snappy
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
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
	    public static function equalBytes(first:ByteArray, second:ByteArray):Boolean
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
	        for (var i:int = 0; i < first.length; ++i)
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
	    public static function swapInt(value:int):int
	    {
	        return reverseBytesFromInt(value);
	    }
	
	    /**
	     * Toggles the endianness of the specified 24-bit medium integer.
	     */
	    public static function swapMedium(value:int):int
	    {
	        var swapped:int = value << 16 & 0xff0000 | value & 0xff00 | value >>> 16 & 0xff;
	        if ((swapped & 0x800000) != 0)
	        {
	            swapped |= 0xff000000;
	        }
	        return swapped;
	    }
	
	    /**
	     * Toggles the endianness of the specified 16-bit short integer.
	     */
	    public static function swapShort(value:int):int //short to int
	    {
	        return reverseBytesFromShort(value);
	    }
		
		/**
	     * Returns the value obtained by reversing the order of the bytes in the
	     * two's complement representation of the specified {@code int} value.
	     *
	     * @return the value obtained by reversing the bytes in the specified
	     *     {@code int} value.
	     * @since 1.5
	     */
	    private static function reverseBytesFromInt(i:int):int 
		{
	        return ((i >>> 24)           ) |
	               ((i >>   8) &   0xFF00) |
	               ((i <<   8) & 0xFF0000) |
	               ((i << 24));
	    }
		
		/**
	     * Returns the value obtained by reversing the order of the bytes in the
	     * two's complement representation of the specified {@code short} value.
	     *
	     * @return the value obtained by reversing (or, equivalently, swapping)
	     *     the bytes in the specified {@code short} value.
	     * @since 1.5
	     */
	    public static function reverseBytesFromShort(i:int):int //short to int
		{
			i = i & 0xFFFF;
	        return (((i & 0xFF00) >> 8) | (i << 8)) & 0xFFFF;
	    }
	}
}
