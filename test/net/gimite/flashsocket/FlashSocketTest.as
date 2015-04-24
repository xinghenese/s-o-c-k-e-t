package net.gimite.flashsocket
{
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	/**
	 * @author Administrator
	 */
	public class FlashSocketTest extends EventDispatcher
	{
		private var parser:ProtocolParserTest = ProtocolParserTest.instance;
		private var datas:ByteArray = new ByteArray();
		
		public function FlashSocketTest()
		{
			configureListeners();
			Logger.log('FlashSocketTest');
			fireConnect();
		}
		
		private function configureListeners():void
		{
			addEventListener(Event.CLOSE, handleClose);
	        addEventListener(FlashSocketEvent.CONNECT, handleConnect);
	        addEventListener(FlashSocketEvent.ERROR, handleError);
	        addEventListener(FlashSocketEvent.DATA, handleData);
			
		}
		
		protected function handleConnect(e:Event):void
		{
			Logger.info("onConnect", e.toString());
		}
		
		protected function handleClose(e:Event):void
		{
			Logger.info("onClose", e.toString());
		}
		
		protected function handleError(e:Event):void
		{
			Logger.info("onError", e.toString());
		}
		
		private function handleData(e:Event):void
		{
			Logger.info("onData", e.toString());
			parser.parse(processReadable(readReponse(e)));
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			var result:Boolean = super.dispatchEvent(event);
			if(result){
				Logger.log(event.type + ' fired.');
			}
			else{
				Logger.error(event.type + ' failed when fired');
				fireError();
			}
			return result;
		}
		
		private function readReponse(e:Event):ByteArray
		{
			return (e as FlashSocketEvent).getData();
		}
		
		protected function processReadable(readable:ByteArray):ByteArray
		{
			Logger.info("readable", readable);
			return readable;
		}
		
		public final function write(writable:ByteArray):void
		{
//			if(connected){
//				writeBytes(processWritable(writable));
//			}
			datas.writeBytes(processWritable(writable));
		}
		
		protected function processWritable(writable:ByteArray):ByteArray
		{
			Logger.info("sendData", writable);
			return writable;
		}
		
		public function fireConnect():void
		{
			dispatchEvent(new FlashSocketEvent(FlashSocketEvent.CONNECT));
		}
		
		public function fireClose():void
		{
			dispatchEvent(new FlashSocketEvent(FlashSocketEvent.CLOSE));
		}
		
		public function fireData(data:*):void
		{
			var message:String = null;
			if(!(data is String) && !(data is ByteArray)){
				fireError();
				return;
			}
			if(data is String){
				message = data;
				data = null;
			}
			dispatchEvent(new FlashSocketEvent(FlashSocketEvent.DATA, message).setData(data));
		}
		
		public function fireError():void
		{
			dispatchEvent(new FlashSocketEvent(FlashSocketEvent.ERROR));			
		}
	}
}

import net.gimite.util.ByteArrayUtil;
import flash.utils.ByteArray;
import flash.events.Event;

class FlashSocketEvent extends Event
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
			return data;
		}
		if(message != null){
			return ByteArrayUtil.createByteArray(true, message);
		}
		return null;
	}
}
