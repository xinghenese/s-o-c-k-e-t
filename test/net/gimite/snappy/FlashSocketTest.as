package net.gimite.snappy
{
	import flash.utils.Endian;
	import net.gimite.util.Dec;
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	import com.hurlant.math.BigInteger;
	import net.gimite.flashsocket.SocketListener;
	import flash.events.Event;
	import flash.display.Sprite;
	import net.gimite.flashsocket.FlashSocket;
	/**
	 * @author Administrator
	 */
	public class FlashSocketTest extends Sprite
	{
		private var host:Array = ["192.168.0.110", "192.168.1.66", "192.168.1.67", "192.168.1.68"];
		private var ordinal:int = 1;
		private var socket:FlashSocket;
		
		public function FlashSocketTest():void
		{					
			connect();
		}
		
		public function connect():void
		{
			var _host:String = host[ordinal++];
			if(_host){
				socket = new FlashSocket(_host);
			}
		}
	}
}
