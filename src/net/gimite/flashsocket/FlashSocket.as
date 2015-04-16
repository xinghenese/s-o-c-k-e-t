package net.gimite.flashsocket
{
	import net.gimite.util.ByteArrayUtil;
	import net.gimite.snappy.Bytes;
	import flash.utils.ByteArray;
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
		public function FlashSocket(host:String, port:uint):void
		{
			super();
			configureListeners();
			if(host){
				loadPolicyFile(host);
				super.connect(host, port);
				Logger.log("connecting to " + host + ":" + port);
			}
		}
		
		private function configureListeners():void
		{
			addEventListener(Event.CLOSE, handleClose);
	        addEventListener(Event.CONNECT, handleConnect);
	        addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
	        addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
	        addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
			
		}
		
		private function loadPolicyFile(host:String, port:uint = 843):void
		{
			var policyUrl:String = "xmlsocket://" + host + ":" + port.toString();
			Logger.info("policy file", policyUrl);
			Security.loadPolicyFile(policyUrl);
		}		
		
		public function handleClose(e:Event):void
		{
			Logger.info("onClose", e.toString());
		}
		
		public function handleConnect(e:Event):void
		{
			Logger.info("onConnect", e.toString());
			writeBytes(processWritable());
			flush();
		}
		
		public function handleIOError(e:Event):void
		{
			Logger.info("onIoError", e.toString());
		}
		
		public function handleSecurityError(e:Event):void
		{
			Logger.info("onSecurityError", e.toString());
		}
		
		public function handleSocketData(e:Event):void
		{
			Logger.info("onData", e.toString());
			processReadable(readReponse());
		}
		
		private function readReponse():ByteArray
		{			
			var bytes:ByteArray = new ByteArray();
			readBytes(bytes);
			return bytes;
		}
		
		protected function processReadable(readable:ByteArray):void
		{
			Logger.info('data', readable);
			Logger.info('data', ByteArrayUtil.toArrayString(readable));
		}
		
		protected function processWritable():ByteArray
		{
			return null;
		}
		
	}
}
