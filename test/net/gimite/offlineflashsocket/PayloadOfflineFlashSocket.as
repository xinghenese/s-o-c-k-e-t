package net.gimite.offlineflashsocket
{
	import net.gimite.connection.AbstractConnection;
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class PayloadOfflineFlashSocket extends AbstractFlashSocket
	{
		public function PayloadOfflineFlashSocket(connection:AbstractConnection)
		{
			super(connection);
		}
		
		override protected function processReadable(readable:ByteArray):ByteArray
		{
			readable = super.processReadable(readable);
			
//			try{
				var length:int = readable.readUnsignedInt();
				Logger.info('PayloadSocket-processReadable.length', length);
				var result:ByteArray = new ByteArray();
				readable.readBytes(result);
//			}
//			catch(e:Error){
//				Logger.error(e);
//			}
//			finally{
				return result;
//			}			
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
