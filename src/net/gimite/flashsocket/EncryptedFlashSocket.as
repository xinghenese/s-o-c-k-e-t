package net.gimite.flashsocket
{
	import net.gimite.util.ByteArrayUtil;
	import net.gimite.logger.Logger;
	import net.gimite.hellman.RC4Encrypt;
	import flash.utils.ByteArray;
	import flash.events.Event;
	/**
	 * @author Administrator
	 */
	public class EncryptedFlashSocket extends PayloadFlashSocket
	{
		public function EncryptedFlashSocket(host:String = null, port:uint = 80):void
		{
//			Logger.log('EncryptedFlashSocket');
			super(host, port);
		}
		
		override protected function processReadable(readable:ByteArray):ByteArray
		{
			readable = super.processReadable(readable);
//			Logger.log('EncryptSocket.processReadable');
			
			if(RC4Encrypt.ready){
				var encrypted:ByteArray = RC4Encrypt.instance.RC4(readable);
//				Logger.info('RC4Decrypted', encrypted);
				return encrypted;
//				return super.processReadable(RC4Encrypt.instance.RC4(readable));
			}
			return readable;
		}
		
		override protected function processWritable(writable:ByteArray):ByteArray
		{
			if(RC4Encrypt.ready){
				var bytes:ByteArray = RC4Encrypt.instance.RC4(writable);
//				Logger.info('RC4Encrypted', bytes);
				return super.processWritable(bytes);
			}
			return super.processWritable(writable);
		}
	}
}
