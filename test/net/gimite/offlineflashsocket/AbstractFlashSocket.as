package net.gimite.offlineflashsocket
{
	import net.gimite.flashsocket.ProtocolParser;
	import net.gimite.connection.ServerConnection;
	import net.gimite.connection.AbstractConnection;
	import flash.utils.setTimeout;
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	import flash.events.Event;
	/**
	 * @author Administrator
	 */
	public class AbstractFlashSocket extends SocketAdapter
	{
		private var state:int = State.NONE;
//		private var parser:ProtocolParserTest = ProtocolParserTest.instance;
		private var parser:ProtocolParser = ProtocolParser.instance;
		private var datas:ByteArray = new ByteArray();
		
		protected var connection:AbstractConnection = null;
		
		public function AbstractFlashSocket(connection:AbstractConnection)
		{
			this.connection = connection;
			configureListeners();
			SocketLog.log(connection, this, 'constructor');
//			fireConnect();
		}
		
		/**************************************************************************************************/
		
		private function configureListeners():void
		{
			SocketLog.log(connection, this, 'configureListeners');
			on(FlashSocketEvent.CLOSE, handleClose);
	        on(FlashSocketEvent.CONNECT, handleConnect);
	        on(FlashSocketEvent.ERROR, handleError);
	        on(FlashSocketEvent.DATA, handleData);			
		}
		
		/**
		 * configure default handler on FlashSocketEvent.CONNECT, which would be overriden by subclasses
		 * to extend the handler logic.
		 */
		protected function handleConnect(e:Event):void
		{
			state = State.CONNECTED;
			SocketLog.log(connection, this, 'onConnect', e.toString());
		}
		
		/**
		 * configure default handler on FlashSocketEvent.CLOSE, which would be overriden by subclasses
		 * to extend the handler logic.
		 */	
		protected function handleClose(e:Event):void
		{
			state = State.CLOSED;
			SocketLog.log(connection, this, 'onClose', e.toString());
		}
		
		/**
		 * configure default handler on FlashSocketEvent.ERROR, which would be overriden by subclasses
		 * to extend the handler logic.
		 */	
		protected function handleError(e:Event):void
		{
			SocketLog.log(connection, this, 'onError', e.toString());
			fireClose();
		}
		
		/**
		 * configure default handler on FlashSocketEvent.DATA, which would be overriden by subclasses
		 * to extend the handler logic.
		 */	
		private function handleData(e:Event):void
		{
			SocketLog.log(connection, this, 'onData', readReponse(e));
			parser.parse(processReadable(readReponse(e)));
		}		
		
		/**************************************************************************************************/
		/**
		 * connect if ready (the definition of ready is that the socket is connectable and useable). 
		 * if the callback is not null and the socket is ready for connection, attach it to the socket to 
		 * handle the FlashSocketEvent.CONNECT only once. 
		 * if the socket is already connected suceessfully, execute the callback directly.
		 */
		public function connect(callback:Function = null/*, once:Boolean = true*/):void
		{
			SocketLog.log(connection, this, 'connect', 'state = ' + state);

			if(connection is ServerConnection){
				return;
			}

			if(state == State.NONE || state == State.CLOSED){
				SocketLog.log(connection, this, 'connect-1', 'state = ' + state);
				once(FlashSocketEvent.CONNECT, callback);
				fireConnect();
			}
			else if(state == State.CONNECTING){
				SocketLog.log(connection, this, 'connect-2', 'state = ' + state);
				once(FlashSocketEvent.CONNECT, callback);
			}
			else if(state == State.CONNECTED){
				SocketLog.log(connection, this, 'connect-3', 'state = ' + state);
				callback(null);
			}
		}
		
		/**
		 * write datas to the socket if the socket is connected, or wait until the socket is connected.
		 * the callback is attached to the socket to handle the FlashSocketEvent.DATA only once.
		 * the datas would be cached in the socket instead of being sent as soon as the socket finishes
		 * writing datas.
		 */
		public final function write(writable:ByteArray, callback:Function = null/*, once:Boolean = true*/):void
		{
			SocketLog.log(connection, this, 'write', writable);
			connect(function(e:Event):void{
				datas.writeBytes(processWritable(writable));
				callback(e);
			});
		}
		
		/**
		 * write datas to the socket and then send them out on finishing writing.
		 */
		public final function writeAndSend(writable:ByteArray, callback:Function = null/*, once:Boolean = true*/):void
		{
			SocketLog.log(connection, this, 'writeAndSend', writable);
			connect(function(e:Event):void{
				once(FlashSocketEvent.DATA, callback);
				datas.writeBytes(processWritable(writable));
				flush();
			});
		}
		
		private function flush():void
		{
			SocketLog.log(connection, this, 'flush', datas);
//			Logger.info('sendData', datas);
			fireData(datas);
		}
		
		private function readReponse(e:Event):ByteArray
		{
			return (e as FlashSocketEvent).getData();
		}
		
		protected function processReadable(readable:ByteArray):ByteArray
		{
			SocketLog.log(connection, this, 'processReadable', readable);
//			Logger.info("readable", readable);
			return readable;
		}
		
		protected function processWritable(writable:ByteArray):ByteArray
		{
			SocketLog.log(connection, this, 'processWritable', writable);
//			Logger.info("writable", writable);
			return writable;
		}
		
		/**************************************************************************************************/
		/**
		 * fire FlashSocketEvent.CONNECT.
		 */
		public function fireConnect():void
		{
			SocketLog.log(connection, this, 'fireConnect');
//			fire(new FlashSocketEvent(FlashSocketEvent.CONNECT), function(e:Event):void{
//				state = State.CONNECTING;
//				Logger.log('State.CONNECTING');
//				connection.notifyRemote(e);
//			});
			notifyRemote(new FlashSocketEvent(FlashSocketEvent.CONNECT), function(e:Event):void{
				state = State.CONNECTING;
				Logger.log('State.CONNECTING');
//				connection.notifyRemote(e);
			});
		}
		
		/**
		 * fire FlashSocketEvent.CLOSE.
		 */
		public function fireClose():void
		{
			SocketLog.log(connection, this, 'fireClose');
//			fire(new FlashSocketEvent(FlashSocketEvent.CLOSE), function(e:Event):void{
//				state = State.CLOSING;
//				connection.notifyRemote(e);
//			});
			notifyRemote(new FlashSocketEvent(FlashSocketEvent.CLOSE), function(e:Event):void{
				state = State.CLOSING;
//				connection.notifyRemote(e);
			});
		}
		
		/**
		 * fire FlashSocketEvent.DATA.
		 */
		public function fireData(data:*):void
		{
			SocketLog.log(connection, this, 'fireData', data);
			var message:String = null;
			if(!(data is String) && !(data is ByteArray)){
				fireError();
				return;
			}
			if(data is String){
				message = data;
				data = null;
			}
//			fire(new FlashSocketEvent(FlashSocketEvent.DATA, message).setData(data), function(e:Event):void{
////				Logger.info('sendData', data || message);
//				datas = new ByteArray();
//				connection.notifyRemote(e);
//			});
			notifyRemote(new FlashSocketEvent(FlashSocketEvent.DATA, message).setData(data), function(e:Event):void{
//				Logger.info('sendData', data || message);
				datas = new ByteArray();
			});
		}
		
		/**
		 * fire FlashSocketEvent.ERROR.
		 */
		override public function fireError():void
		{
			SocketLog.log(connection, this, 'fireError');
			fire(new FlashSocketEvent(FlashSocketEvent.ERROR));
		}
		
		private function notifyRemote(e:Event, callback:Function = null):void
		{
			connection.notifyRemote(e, callback);
		}
	}
}

class State
{
	public static const NONE:int = -1;
	public static const CONNECTING:int = 0;
	public static const CONNECTED:int = 1;
	public static const CLOSING:int = 2;
	public static const CLOSED:int = 3;
}