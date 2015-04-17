package net.gimite.flashsocket
{
	import net.gimite.hellman.Hellman;
	import net.gimite.snappy.SnappyFrameDecoder;
	import net.gimite.snappy.SnappyFrameEncoder;
	import net.gimite.util.ByteArrayUtil;
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	import flash.events.Event;
	/**
	 * @author Administrator
	 */
	public class SnappyFlashSocket extends FlashSocket
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
			super.handleConnect(e);
//			var data:String = '<HSK pbk="XHBxevmo8lAe34xM87jE+3dYxfEOhnjqt/Ca2I4PZk9SorG5v+ns4dbEn2vOoUlfScFBIAht0bylxiiBq27y3Ia08aDEYqe6b/x8uuBGfRmuAc9OT4eLFeJsrmmzDzDtTIoWHPnRv9V045oIKVnRN5girx9muphhL/AVSPQ3lGA="></HSK>';
			var pbk:String = (new Hellman()).getPublicKey();
			var packet:ProtocolPacket = new ProtocolPacket('HSK');
			packet.fillData('pbk', pbk);
			var data:String = packet.toXMLString();
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			write(bytes);
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
			var length:int = readable.readUnsignedInt();
			var tmp:ByteArray = new ByteArray();
			readable.readBytes(tmp);
			var result:ByteArray = decoder.decode(tmp);
			
			Logger.info('data', readable);
			Logger.info('data', ByteArrayUtil.toArrayString(readable));
			
			Logger.info('length', length);
			Logger.info('decode', result);
			Logger.info('decode', ByteArrayUtil.toArrayString(result));
			
			return result;
		}
		
		override protected function processWritable(writable:ByteArray):ByteArray
		{
			Logger.info('writable', writable);
			Logger.info('writable', ByteArrayUtil.toArrayString(writable));
			
			writable =  encoder.encode(writable);
			
			var result:ByteArray = new ByteArray();
			result.writeInt(writable.length);
			result.writeBytes(writable);
			
			Logger.info("sendData", result);
			Logger.info("sendData", ByteArrayUtil.toArrayString(result));
			return result;
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
