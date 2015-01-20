package net.gimite.flashsocket
{
	import net.gimite.snappy.SnappyTest;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.Event;
	import net.gimite.logger.Logger;
	import flash.system.Security;
	import flash.net.Socket;
	/**
	 * @author Administrator
	 */
	public class FlashSocket extends Socket implements SocketListener
	{
		public function FlashSocket(host:String = null, port:uint = 80):void
		{
			super();
			configureListeners();
			if(host){
				loadPolicyFile(host);
				super.connect(host, port);
				Logger.log("connecting");
			}
		}
		
		private function configureListeners():void
		{
			addEventListener(Event.CLOSE, closeHandler);
	        addEventListener(Event.CONNECT, connectHandler);
	        addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	        addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	        addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			
		}
		
		private function loadPolicyFile(host:String, port:uint = 843):void
		{
			var policyUrl:String = "xmlsocket://" + host + ":" + port.toString();
			Logger.info("policy file", policyUrl);
			Security.loadPolicyFile(policyUrl);
		}		
		
		public function closeHandler(e:Event):void
		{
			Logger.info("onClose", e.toString());
		}
		
		public function connectHandler(e:Event):void
		{
			Logger.info("onConnect", e.toString());
			writeBytes((new SnappyTest()).resultBytes);
			flush();
		}
		
		public function ioErrorHandler(e:Event):void
		{
			Logger.info("onIoError", e.toString());
		}
		
		public function securityErrorHandler(e:Event):void
		{
			Logger.info("onSecurityError", e.toString());
		}
		
		public function socketDataHandler(e:Event):void
		{
			Logger.info("onData", e.toString());
		}
		
	}
}
