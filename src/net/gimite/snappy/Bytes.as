package net.gimite.snappy
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class Bytes
	{
		public static const BYTE_MAX_VALUE:int = 0x7F;
		public static const BYTE_MIN_VALUE:int = 0x80;
		public static const SHORT_MAX_VALUE:int = 0x7FFF;//32767;
		public static const SHORT_MIN_VALUE:int = 0x8000;//-32768;
		public static const MEDIUM_MAX_VALUE:int = 0x7FFFFF;
		public static const MEDIUM_MIN_VALUE:int = 0x800000;
		public static const LONG_MAX_VALUE:int = 0x7FFFFFFF;
		public static const LONG_MIN_VALUE:int = 0x80000000;
		
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
		
		/**
	     * Returns an {@code int} value with at most a single one-bit, in the
	     * position of the highest-order ("leftmost") one-bit in the specified
	     * {@code int} value.  Returns zero if the specified value has no
	     * one-bits in its two's complement binary representation, that is, if it
	     * is equal to zero.
	     *
	     * @return an {@code int} value with a single one-bit, in the position
	     *     of the highest-order one-bit in the specified value, or zero if
	     *     the specified value is itself equal to zero.
	     * @since 1.5
	     */
	    public static function highestOneBit(i:int):int 
		{
	        // HD, Figure 3-1
	        i |= (i >>  1);
	        i |= (i >>  2);
	        i |= (i >>  4);
	        i |= (i >>  8);
	        i |= (i >> 16);
	        return i - (i >>> 1);
	    }
	
	    /**
	     * Returns an {@code int} value with at most a single one-bit, in the
	     * position of the lowest-order ("rightmost") one-bit in the specified
	     * {@code int} value.  Returns zero if the specified value has no
	     * one-bits in its two's complement binary representation, that is, if it
	     * is equal to zero.
	     *
	     * @return an {@code int} value with a single one-bit, in the position
	     *     of the lowest-order one-bit in the specified value, or zero if
	     *     the specified value is itself equal to zero.
	     * @since 1.5
	     */
	    public static function lowestOneBit(i:int):int 
		{
	        // HD, Section 2-1
	        return i & -i;
	    }
		
		public static function toByte(i:int):int
		{
			return i & 0xFF;
		}
		
		public static function toShort(i:int):int
		{
			return i & 0xFFFF;
		}
		
		public static function toMedium(i:int):int
		{
			return i & 0xFFFFFF;
		}
		
		public static function fromArray(arr:Array):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			arr.forEach(function(item:*, index:int, array:Array):void
			{
				bytes.writeByte(int(item));
			});
			bytes.position = 0;
			return bytes;
		}
		
		public static function toArrayString(bytes:ByteArray, radius:int = 10):String
		{
			var result:String = "[", pos:int = bytes.position;
			bytes.position = 0;
			while(bytes.bytesAvailable)
			{
				result = result + bytes.readByte().toString(radius) + ", ";
			}
			bytes.position = pos;
			return result.replace(/,\s$/, "]");
		}
	}
}
