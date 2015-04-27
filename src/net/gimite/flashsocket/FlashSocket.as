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
	public class FlashSocket extends Socket// implements SocketListener
	{
		private const parser:ProtocolParser = ProtocolParser.instance;
		
		public function FlashSocket(host:String, port:uint):void
		{
			super();
			if(host){
				configureListeners();
				loadPolicyFile(host);
				super.connect(host, port);
				Logger.log("connecting to " + host + ":" + port);
//				return;
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
		
		protected function handleConnect(e:Event):void
		{
			Logger.info("onConnect", e.toString());
		}
		
		protected function handleClose(e:Event):void
		{
			Logger.info("onClose", e.toString());
		}
		
		protected function handleIOError(e:Event):void
		{
			Logger.info("onIoError", e.toString());
		}
		
		protected function handleSecurityError(e:Event):void
		{
			Logger.info("onSecurityError", e.toString());
		}
		
		private function handleSocketData(e:Event):void
		{
			Logger.info("onData", e.toString());
			parser.parse(processReadable(readReponse()));
		}
		
		private function readReponse():ByteArray
		{			
			var bytes:ByteArray = new ByteArray();
			readBytes(bytes);
			return bytes;
		}
		
		protected function processReadable(readable:ByteArray):ByteArray
		{
			return readable;
		}
		
		public final function write(writable:ByteArray):void
		{
			if(connected){
				writeBytes(processWritable(writable));
				flush();
			}
		}
		
		protected function processWritable(writable:ByteArray):ByteArray
		{
			return writable;
		}
		
	}
}
