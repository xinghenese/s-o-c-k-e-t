package net.gimite.flashsocket
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	import net.gimite.connection.Connection;
	import net.gimite.crypto.Crypto;
	import net.gimite.crypto.ICrypto;
	import net.gimite.crypto.RC4Encrypt;
	import net.gimite.logger.Logger;
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.packet.ProtocolPacketManager;
	import net.gimite.util.ByteArrayUtil;
	/**
	 * @author Administrator
	 */
	public class EncryptedFlashSocket extends PayloadFlashSocket
	{
		private var crypto:Crypto;
		
		public function EncryptedFlashSocket(host:String = null, port:uint = 80):void
		{
//			Logger.log('EncryptedFlashSocket');
			crypto = RC4Encrypt.instance;
			super(host, port);
		}
		
		override protected function handleConnect(e:Event):void
		{
			super.handleConnect(e);
			if(!crypto.ready){
				var packet:ProtocolPacket = ProtocolPacketManager.instance.createHandShakeProtocolPacket();
				Connection.instance.request(packet);
			}
		}
		
		override protected function processReadable(readable:ByteArray):ByteArray
		{
			readable = super.processReadable(readable);
//			Logger.log('EncryptSocket.processReadable');
			
			if(crypto.ready){
				var bytes:ByteArray = crypto.decrypt(readable);
//				Logger.info('RC4Decrypted', encrypted);
				return bytes;
//				return super.processReadable(RC4Encrypt.instance.RC4(readable));
			}
			return readable;
		}
		
		override protected function processWritable(writable:ByteArray):ByteArray
		{
			if(crypto.ready){
				var bytes:ByteArray = crypto.encrypt(writable);
//				Logger.info('RC4Encrypted', bytes);
				return super.processWritable(bytes);
			}
			return super.processWritable(writable);
		}
	}
}
