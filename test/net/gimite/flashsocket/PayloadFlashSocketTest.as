package net.gimite.flashsocket
{
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class PayloadFlashSocketTest extends FlashSocketTest
	{
		public function PayloadFlashSocketTest()
		{
			super();
		}
		
		override protected function processReadable(readable:ByteArray):ByteArray
		{
			readable = super.processReadable(readable);
			
			var length:int = readable.readUnsignedInt();
			Logger.info('PayloadSocket-processReadable.length', length);
			var result:ByteArray = new ByteArray();
			readable.readBytes(result);
			return result;
		}
		
		override protected function processWritable(writable:ByteArray):ByteArray
		{			
			var result:ByteArray = new ByteArray();
			result.writeInt(writable.length);
			result.writeBytes(writable);
			return super.processWritable(result);
		}
	}
}
