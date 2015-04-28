package net.gimite.util
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class CodeHashAdapter implements CodeHash
	{
		public function hashEncode(rawText:String, hashKey:String = null):String
		{
			return rawText;
		}
		
		public function hashDecode(hashText:String, hashKey:String = null):String
		{
			return hashText;
		}
		
		public function hashEncodeBytes(rawBytes:ByteArray, hashKey:ByteArray = null):ByteArray
		{
			return rawBytes;
		}
		
		public function hashDecodeBytes(hashBytes:ByteArray, hashKey:ByteArray = null):ByteArray
		{
			return hashBytes;
		}
	}
}
