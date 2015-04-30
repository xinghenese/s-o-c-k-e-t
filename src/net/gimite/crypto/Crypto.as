package net.gimite.crypto
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class Crypto implements ICrypto
	{
		protected var _key:ByteArray;
		public const KEY_LENGTH:uint = 32;
		
		public function get ready():Boolean
		{
			return true;
		}
		
		public function set encryptKey(key:ByteArray):void
		{
			_key = key;
		}
		
		public function encrypt(rawBytes:ByteArray, key:ByteArray = null):ByteArray
		{
			return rawBytes;
		}
		
		public function decrypt(encryptedBytes:ByteArray, key:ByteArray = null):ByteArray
		{
			return encryptedBytes;
		}
		
	}
}
