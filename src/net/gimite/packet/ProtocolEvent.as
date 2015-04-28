package net.gimite.packet
{
	import flash.events.Event;
	/**
	 * @author Administrator
	 */
	public class ProtocolEvent extends Event
	{
		public static const SUCCESS:String = "success";
		public static const ERROR:String = "error";
		
		private var data:Object = null;
		
		public function ProtocolEvent(type:String, data:Object) 
		{
			super(type);
			this.data = data;
		}
		
		public function get message():String
		{
			return JSON.stringify(data);
		}
		
		override public function toString():String
		{
			return message;
		}
	}
}
