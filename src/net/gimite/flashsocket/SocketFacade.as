package net.gimite.flashsocket
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class SocketFacade
	{
		private static var INSTANCE:SocketFacade = null;
		private static var socket:FlashSocket = null;
		
		public function SocketFacade()
		{
		}
		
		public static function get():SocketFacade
		{
			if(INSTANCE == null){
				INSTANCE = new SocketFacade();
			}
			return INSTANCE;
		}
		
		public function connect():void
		{
//			var host:Array = ["192.168.0.110", "192.168.1.66", "192.168.1.67", "192.168.1.68", "192.168.0.66", "192.168.0.67", "192.168.0.68"];
			if(socket == null){
				socket = new SnappyFlashSocket("192.168.0.66");
			}			
		}
		
		public function send(data:ByteArray):void
		{
			if(socket != null && socket.connected){
				socket.write(data);
			}
		}
		
		public function close():void
		{
			if(socket != null){
				socket.close();
				socket = null;
			}
		}
	}
}
