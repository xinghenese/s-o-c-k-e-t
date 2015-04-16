package net.gimite.util
{
	/**
	 * @author Administrator
	 */
	public class ArrayUtil
	{
		public static function equals(arr1:Array, arr2:Array):Boolean
		{
			if(arr1.length != arr2.length){
				return false;
			}
			for(var i:int = 0, len = arr1.length; i<len; i++){
				if(arr1[i] != arr2[i]){
					return false;
				}
			}
			return true;
		}
	}
}
