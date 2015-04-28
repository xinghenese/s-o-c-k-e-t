package net.gimite.flashsocket
{
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class PayloadFlashSocket extends FlashSocket
	{
		public function PayloadFlashSocket(host:String = null, port:uint = 80):void
		{
			super(host, port);
		}
		
		override protected function processReadable(readable:ByteArray):ByteArray
		{
			readable = super.processReadable(readable);
			
			var length:int = readable.readUnsignedInt();
//			Logger.info('PayloadSocket-processReadable.length', length);
			var result:ByteArray = new ByteArray();
			readable.readBytes(result);
			return result;
		}
		
		override protected function processWritable(writable:ByteArray):ByteArray
		{			
			var result:ByteArray = new ByteArray();
			result.writeInt(writable.length);
			result.writeBytes(writable);
//			Logger.info('result-payload', result);
			return super.processWritable(result);
		}
	}
}
