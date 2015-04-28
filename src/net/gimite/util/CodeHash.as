package net.gimite.util
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public interface CodeHash
	{
		function hashEncode(rawText:String, hashKey:String = null):String;
		
		function hashDecode(hashText:String, hashKey:String = null):String;
		
		function hashEncodeBytes(rawBytes:ByteArray, hashKey:ByteArray = null):ByteArray;
		
		function hashDecodeBytes(hashBytes:ByteArray, hashKey:ByteArray = null):ByteArray;
	}
}
