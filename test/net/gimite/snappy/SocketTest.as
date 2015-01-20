package net.gimite.snappy
{
	import net.gimite.websocket.WebSocketEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import mx.utils.URLUtil;
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
		private var callerUrl:String = "http://www.flashsocket.test";
		
		public function SocketTest()
		{
			var result:String = (new SnappyTest()).result;
			connect();
			socket.addEventListener(WebSocketEvent.CLOSE, function(event:WebSocketEvent):void
			{
				log("close and try to restart");
				connect();
			});
			socket.addEventListener(WebSocketEvent.OPEN, function(event: WebSocketEvent):void
			{
				log("connected and communication available");
				socket.send(result);
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
			return new WebSocket(webSocketId, url, protocols || [], getOrigin(), proxyHost, proxyPort, getCookie(url), headers, this);
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
		
		private function getOrigin():String 
		{
			return (URLUtil.getProtocol(this.callerUrl) + "://" +
			URLUtil.getServerNameWithPort(this.callerUrl)).toLowerCase();
		}
		
		private function getCookie(url:String):String 
		{
			if (URLUtil.getServerName(url).toLowerCase() ==
			URLUtil.getServerName(this.callerUrl).toLowerCase()) 
			{
				return ExternalInterface.call("function(){return document.cookie}");
			} 
			else 
			{
				return "";
			}
		}
	}
}
