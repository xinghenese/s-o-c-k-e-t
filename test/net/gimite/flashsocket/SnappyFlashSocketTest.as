package net.gimite.flashsocket
{
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	import net.gimite.connection.ConnectionTest;
	import net.gimite.packet.HandShakeProtocolPacket;
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.hellman.RC4Encrypt;
	import flash.events.Event;
	import net.gimite.snappy.SnappyFrameDecoder;
	import net.gimite.snappy.SnappyFrameEncoder;
	/**
	 * @author Administrator
	 */
	public class SnappyFlashSocketTest extends EncryptedFlashSocketTest
	{
		private var encoder:SnappyFrameEncoder;
		private var decoder:SnappyFrameDecoder;
		private var ready:Boolean = false;
		
		public function SnappyFlashSocketTest()
		{
			encoder = new SnappyFrameEncoder();
			decoder = new SnappyFrameDecoder();
			super();
		}
		
		override protected function handleConnect(e:Event):void
		{
//			var data:String = '<HSK pbk="XHBxevmo8lAe34xM87jE+3dYxfEOhnjqt/Ca2I4PZk9SorG5v+ns4dbEn2vOoUlfScFBIAht0bylxiiBq27y3Ia08aDEYqe6b/x8uuBGfRmuAc9OT4eLFeJsrmmzDzDtTIoWHPnRv9V045oIKVnRN5girx9muphhL/AVSPQ3lGA="></HSK>';
//			if(!RC4Encrypt.ready || !ready){
			if(!ready){
//				var pbk:String = (new Hellman()).getPublicKey();
//				Logger.info('pbk', pbk);
				Logger.info('ready', ready);
				ready = true;
				var packet:ProtocolPacket = new HandShakeProtocolPacket();
				ConnectionTest.instance.request(packet);
			}
						
			super.handleConnect(e);
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
			Logger.info('writable', writable);
			
			var result:ByteArray =  encoder.encode(writable);
			
			Logger.info('snappy-encoded', result);
			
			return result;
//			return super.processWritable(result);
			//super.processWritable();
		}
	}
}
