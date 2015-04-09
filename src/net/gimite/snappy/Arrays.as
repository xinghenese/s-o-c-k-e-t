package net.gimite.snappy
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class Arrays
	{
		/**
     * Returns <tt>true</tt> if the two specified arrays of bytes are
     * <i>equal</i> to one another.  Two arrays are considered equal if both
     * arrays contain the same number of elements, and all corresponding pairs
     * of elements in the two arrays are equal.  In other words, two arrays
     * are equal if they contain the same elements in the same order.  Also,
     * two array references are considered equal if both are <tt>null</tt>.<p>
     *
     * @param a one array to be tested for equality
     * @param a2 the other array to be tested for equality
     * @return <tt>true</tt> if the two arrays are equal
     */
	    public static function equals(a:ByteArray, a2:ByteArray):Boolean
		{
	        if (a==a2)
	            return true;
	        if (a==null || a2==null)
	            return false;
	
	        var length:int = a.length;
	        if (a2.length != length)
	            return false;
	
	        for (var i:int=0; i<length; i++)
	            if (a[i] != a2[i])
	                return false;
	
	        return true;
	    }
	}
}
