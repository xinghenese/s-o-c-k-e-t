package net.gimite.offlineflashsocket
{
	import net.gimite.util.ByteArrayUtil;
	import flash.utils.ByteArray;
	import flash.events.Event;
	
	/**
	 * @author Reco
	 */
	public class FlashSocketEvent extends Event
	{
		public static const CONNECT:String = "connect";
		public static const CLOSE:String = "close";
		public static const DATA:String = "data";
		public static const ERROR:String = "error";
		
		public var message:String = null;
		public var data:ByteArray = null;
		
		public function FlashSocketEvent(type:String, message:String = null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this.message = message;
		}
		
		public function setData(data:ByteArray):FlashSocketEvent
		{
			this.data = data;
			return this;
		}
		
		public function getData():ByteArray
		{
			if(data != null){
				data.position = 0;
				return data;
			}
			if(message != null){
				return ByteArrayUtil.createByteArray(true, message);
			}
			return null;
		}
	}
}
