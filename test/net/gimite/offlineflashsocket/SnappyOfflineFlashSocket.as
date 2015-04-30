package net.gimite.offlineflashsocket
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	import net.gimite.connection.AbstractConnection;
	import net.gimite.connection.ClientConnection;
	import net.gimite.connection.ServerConnection;
	import net.gimite.crypto.RC4Encrypt;
	import net.gimite.logger.Logger;
	import net.gimite.packet.HandShakeProtocolPacket;
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.snappy.SnappyFrameDecoder;
	import net.gimite.snappy.SnappyFrameEncoder;
	/**
	 * @author Administrator
	 */
	public class SnappyOfflineFlashSocket extends EncryptedOfflineFlashSocket
	{
		private var encoder:SnappyFrameEncoder;
		private var decoder:SnappyFrameDecoder;
		private var ready:Boolean = false;
		
		public function SnappyOfflineFlashSocket(connection:AbstractConnection)
		{
			encoder = new SnappyFrameEncoder();
			decoder = new SnappyFrameDecoder();
			super(connection);
		}
		
		override protected function handleConnect(e:Event):void
		{
			if(connection is ServerConnection){
				fireConnect();
				return;
			}
			super.handleConnect(e);
//			Logger.log('SnappySocket.handleConnect');
			SocketLog.log(connection, this, 'handleConnect', e);
//			var data:String = '<HSK pbk="XHBxevmo8lAe34xM87jE+3dYxfEOhnjqt/Ca2I4PZk9SorG5v+ns4dbEn2vOoUlfScFBIAht0bylxiiBq27y3Ia08aDEYqe6b/x8uuBGfRmuAc9OT4eLFeJsrmmzDzDtTIoWHPnRv9V045oIKVnRN5girx9muphhL/AVSPQ3lGA="></HSK>';
//			if(!RC4Encrypt.ready || !ready){
			if(!ready){
////				var pbk:String = (new Hellman()).getPublicKey();
////				Logger.info('pbk', pbk);
				Logger.info('ready', ready);
//				ready = true;
				var packet:ProtocolPacket = new HandShakeProtocolPacket();
//				AbstractConnection.instance.request(packet);
				connection.request(packet);
			}
		}
		
		override protected function handleClose(e:Event):void
		{
			super.handleClose(e);
		}
		
		override protected function handleError(e:Event):void
		{
			super.handleError(e);
		}
		
		override protected function processReadable(readable:ByteArray):ByteArray
		{
			Logger.log('SnappySocket.processReadable');
			readable = super.processReadable(readable);
			
			var result:ByteArray = decoder.decode(readable);
			
			Logger.info('data', readable);
			
			Logger.info('length', length);
			Logger.info('decode', result);
			
			return result;
		}
		
		override protected function processWritable(writable:ByteArray):ByteArray
		{
			var direction:String = ' <= ';
			if(connection is ServerConnection){
				direction = ' => ';
			}
			Logger.info('writable' + direction, writable);
			
			var result:ByteArray =  encoder.encode(writable);
			
			Logger.info('snappy-encoded', result);
			
//			return result;
			return super.processWritable(result);
			//super.processWritable();
		}
	}
}
