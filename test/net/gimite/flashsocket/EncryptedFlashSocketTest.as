package net.gimite.flashsocket
{
	import net.gimite.hellman.RC4Encrypt;
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class EncryptedFlashSocketTest extends PayloadFlashSocketTest
	{
		public function EncryptedFlashSocketTest()
		{
			super();
		}
		
		override protected function processReadable(readable:ByteArray):ByteArray
		{
			readable = super.processReadable(readable);
			Logger.log('EncryptSocket.processReadable');
			
			if(RC4Encrypt.ready){
				var encrypted:ByteArray = RC4Encrypt.instance.RC4(readable);
				Logger.info('RC4Decrypted', encrypted);
				return encrypted;
//				return super.processReadable(RC4Encrypt.instance.RC4(readable));
			}
			return readable;
		}
		
		override protected function processWritable(writable:ByteArray):ByteArray
		{
			if(RC4Encrypt.ready){
				Logger.info('RC4Encrypted', RC4Encrypt.instance.RC4(writable));
				return super.processWritable(RC4Encrypt.instance.RC4(writable));
			}
			return super.processWritable(writable);
		}
	}
}
