package net.gimite.snappy
{
	import flash.system.Security;
	import net.gimite.websocket.WebSocket;
	import net.gimite.logger.Logger;
	import net.gimite.websocket.IWebSocketLogger;
	import flash.display.Sprite;
	/**
	 * @author Administrator
	 */
	public class SocketTest extends Sprite implements IWebSocketLogger
	{
		private static var host:Array = ["192.168.1.66", "192.168.1.67", "192.168.1.68"];
		private var socket:WebSocket;
		private var webSocketId:int = 0;
		private var ordinal:int = 0;
		
		public function SocketTest()
		{
			connect();
			socket.addEventListener("close", function():void
			{
				log("close and try to restart");
				connect();
			});
			socket.addEventListener("open", function():void
			{
				log("connected and communication available");
			});
		}
		
		public function log(message:String):void 
		{
			Logger.info("WebSocket", message);
		}
		
		public function error(message:String):void 
		{
			Logger.info("WebSocket", message);
		}
		
		private function create(webSocketId:int, host:String, port:String = "80", secure:String = "ws", protocols:Array = null, origin:String = "", proxyHost:String = null, proxyPort:int = 0, cookie:String = "", headers:String = null):WebSocket
		{
			var url:String = secure + "://" + host + ":" + port;
			return new WebSocket(webSocketId, url, protocols, origin, proxyHost, proxyPort, cookie, headers, this);
		}
		
		private function connect():void
		{
			var host:String = host[ordinal++];
			if(host)
			{
				loadDefaultPolicyFile(host);
				socket = create(webSocketId, host);
				log("connecting");
			}	
		}
		
		private function loadDefaultPolicyFile(host:String):void 
		{
			var policyUrl:String = "xmlsocket://" + host + ":843";
			log("policy file: " + policyUrl);
			Security.loadPolicyFile(policyUrl);
		}
	}
}
