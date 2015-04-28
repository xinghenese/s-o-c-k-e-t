package net.gimite.flashsocket
{
	import net.gimite.connection.Connection;
	import net.gimite.hellman.RC4Encrypt;
	import net.gimite.packet.HandShakeProtocolPacket;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import net.gimite.hellman.Hellman;
	import net.gimite.logger.Logger;
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.snappy.SnappyFrameDecoder;
	import net.gimite.snappy.SnappyFrameEncoder;
	import net.gimite.util.ByteArrayUtil;
	/**
	 * @author Administrator
	 */
	public class SnappyFlashSocket extends EncryptedFlashSocket
	{
		private var encoder:SnappyFrameEncoder;
		private var decoder:SnappyFrameDecoder;
		
		public function SnappyFlashSocket(host:String = null, port:uint = 80):void
		{
			Logger.log('SnappyFlashSocket');
			encoder = new SnappyFrameEncoder();
			decoder = new SnappyFrameDecoder();
			super(host, port);
		}
		
		override protected function handleConnect(e:Event):void
		{
//			var data:String = '<HSK pbk="XHBxevmo8lAe34xM87jE+3dYxfEOhnjqt/Ca2I4PZk9SorG5v+ns4dbEn2vOoUlfScFBIAht0bylxiiBq27y3Ia08aDEYqe6b/x8uuBGfRmuAc9OT4eLFeJsrmmzDzDtTIoWHPnRv9V045oIKVnRN5girx9muphhL/AVSPQ3lGA="></HSK>';
			super.handleConnect(e);
			if(!RC4Encrypt.ready){
//				var pbk:String = (new Hellman()).getPublicKey();
//				Logger.info('pbk', pbk);
				var packet:ProtocolPacket = new HandShakeProtocolPacket();
				Connection.instance.request(packet);
			}
		}
		
		override protected function handleClose(e:Event):void
		{
			super.handleClose(e);
		}
		
		override protected function handleIOError(e:Event):void
		{
			super.handleIOError(e);
		}
		
		override protected function handleSecurityError(e:Event):void
		{
			super.handleSecurityError(e);
		}
		
		override protected function processReadable(readable:ByteArray):ByteArray
		{
//			Logger.log('SnappySocket.processReadable');
			readable = super.processReadable(readable);
			
			var result:ByteArray = decoder.decode(readable);
			
//			Logger.info('data', readable);
			
//			Logger.info('length', length);
//			Logger.info('decode', result);
			
			return result;
		}
		
		override protected function processWritable(writable:ByteArray):ByteArray
		{
			Logger.info('writable', writable);
			
			var result:ByteArray =  encoder.encode(writable);
			
//			Logger.info('snappy-encoded', result);
			
			var test:ByteArray = decoder.decode(result);
			
//			Logger.info('snappy-decoded', test);
			
			return super.processWritable(result);
			//super.processWritable();
		}
		
		protected function generateData():ByteArray
		{
			var data:String = '<HSK pbk="XHBxevmo8lAe34xM87jE+3dYxfEOhnjqt/Ca2I4PZk9SorG5v+ns4dbEn2vOoUlfScFBIAht0bylxiiBq27y3Ia08aDEYqe6b/x8uuBGfRmuAc9OT4eLFeJsrmmzDzDtTIoWHPnRv9V045oIKVnRN5girx9muphhL/AVSPQ3lGA="></HSK>';
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			return bytes;
		}
	}
}
