package net.gimite.snappy
{
	import flash.events.Event;
	import flash.display.Sprite;
	import net.gimite.flashsocket.FlashSocket;
	/**
	 * @author Administrator
	 */
	public class FlashSocketTest extends Sprite
	{
		private var host:Array = ["192.168.1.66", "192.168.1.67", "192.168.1.68"];
		private var ordinal:int = 0;
		private var socket:FlashSocket;
		
		public function FlashSocketTest():void
		{
			connect();
		}
		
		public function connect():void
		{
			var host:String = host[ordinal++];
			if(host){
				socket = new FlashSocket(host);
			}
		}
	}
}
