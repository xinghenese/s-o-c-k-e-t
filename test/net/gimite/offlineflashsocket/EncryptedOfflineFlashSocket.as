package net.gimite.offlineflashsocket
{
	import flash.utils.ByteArray;
	import net.gimite.connection.AbstractConnection;
	import net.gimite.crypto.RC4Encrypt;
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class EncryptedOfflineFlashSocket extends PayloadOfflineFlashSocket
	{
		public function EncryptedOfflineFlashSocket(connection:AbstractConnection)
		{
			super(connection);
		}
		
		override protected function processReadable(readable:ByteArray):ByteArray
		{
			readable = super.processReadable(readable);
			Logger.log('EncryptSocket.processReadable');
			
//			if(RC4Encrypt.ready){
//				var encrypted:ByteArray = RC4Encrypt.instance.RC4(readable);
//				Logger.info('RC4Decrypted', encrypted);
//				return encrypted;
////				return super.processReadable(RC4Encrypt.instance.RC4(readable));
//			}
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
