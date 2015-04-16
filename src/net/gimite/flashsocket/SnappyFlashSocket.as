package net.gimite.flashsocket
{
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
		
		override public function handleClose(e:Event):void
		{
			super.handleClose(e);
		}
		
		override public function handleIOError(e:Event):void
		{
			super.handleIOError(e);
		}
		
		override public function handleSecurityError(e:Event):void
		{
			super.handleSecurityError(e);
		}
		
		override protected function processReadable(readable:ByteArray):void
		{
			var length:int = readable.readUnsignedInt();
			var tmp:ByteArray = new ByteArray();
			readable.readBytes(tmp);
			var result:ByteArray = decoder.decode(tmp);
			super.processReadable(readable);
			Logger.info('length', length);
			Logger.info('decode', result);
			Logger.info('decode', ByteArrayUtil.toArrayString(result));
		}
		
		override protected function processWritable():ByteArray
		{
			var writable:ByteArray = encoder.encode(generateData());
			
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
