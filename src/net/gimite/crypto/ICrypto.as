package net.gimite.crypto
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public interface ICrypto
	{
		function encrypt(rawBytes:ByteArray, key:ByteArray = null):ByteArray;
		
		function decrypt(encryptedBytes:ByteArray, key:ByteArray = null):ByteArray;
	}
}
