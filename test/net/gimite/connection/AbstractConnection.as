package net.gimite.connection
{
	import net.gimite.offlineflashsocket.FlashSocketEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	import net.gimite.offlineflashsocket.AbstractFlashSocket;
	import net.gimite.offlineflashsocket.EncryptedOfflineFlashSocket;
	import net.gimite.offlineflashsocket.SnappyOfflineFlashSocket;
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.util.ByteArrayUtil;
	/**
	 * @author Administrator
	 */
	public class AbstractConnection
	{
		private static var INSTANCE:AbstractConnection = null;
		
		protected var _socket:AbstractFlashSocket = null;
		
		protected var _remote:AbstractConnection = null;
				
		public function AbstractConnection()
		{
			
		}
		
		public static function get instance():AbstractConnection
		{
			if(INSTANCE == null){
				INSTANCE = new AbstractConnection();
			}
			return INSTANCE;
		}
		
		public function get socket():AbstractFlashSocket
		{
			createSocketIfNotExists();
			return _socket;
		}
		
		private function get remoteSocket():AbstractFlashSocket
		{
			if(_remote == null){
				if(this is ClientConnection){
					_remote = ServerConnection.instance;
				}
				else if(this is ServerConnection){
					_remote = ClientConnection.instance;
				}
			}
			return _remote.socket;
		}
		
		public function connect():void
		{
			createSocketIfNotExists();
			_socket.connect();
		}
		
		private function createSocketIfNotExists():void
		{
			if(_socket == null){
//				socket = new AbstractFlashSocket();
				_socket = new SnappyOfflineFlashSocket(this);
			}
		}
		
		/**************************************************************************************************/
		
		public function request(packet:ProtocolPacket, packet2:ProtocolPacket = null):void
		{
			createSocketIfNotExists();
			var data:ByteArray = ByteArrayUtil.createByteArray(true, packet.toXMLString());
//			var data2:ByteArray = ByteArrayUtil.createByteArray(true, packet2.toXMLString());
//			socket.writeAndSend(data, function(e:Event):void{
//				socket.writeAndSend(data2);
//			});
			_socket.writeAndSend(data);
//			socket.connect(function(e:Event):void{Logger.info('request', 'data1');socket.connect(function(e:Event):void{Logger.info('request2', 'data2');});});
			
		}
		
		public function response(parsed:Object):void
		{
			Logger.info('Connection.reponse', JSON.stringify(parsed));
			var packet:ProtocolPacket = ProtocolPacket.refretchPacket(parsed.name);
			if(packet != null){
				packet.fillData(parsed.data);
				Logger.info('packet not null');
				packet.process();
			}			
		}
		
		/**************************************************************************************************/
		
		public final function notifyRemote(e:Event, callback:Function = null):void
		{
			if(e is FlashSocketEvent){
				remoteSocket.fire(e, callback);
			}
		}
	}
}
