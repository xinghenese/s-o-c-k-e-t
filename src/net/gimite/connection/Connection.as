package net.gimite.connection
{
	import net.gimite.packet.ProtocolPacketManager;
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	import net.gimite.util.ByteArrayUtil;
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.flashsocket.SnappyFlashSocket;
	import net.gimite.flashsocket.FlashSocket;
	/**
	 * @author Administrator
	 */
	public class Connection
	{
		private static var INSTANCE:Connection = null;
		
		private var socket:FlashSocket = null;
		private var host:Array = ["192.168.0.110", "192.168.1.66", "192.168.1.67", "192.168.1.68", "192.168.0.66", "192.168.0.67", "192.168.0.68"];
		private var ordinal:int = 4;
		
		public function Connection(enforcer:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():Connection
		{
			if(INSTANCE == null){
				INSTANCE = new Connection(new SingletonEnforcer());
			}
			return INSTANCE;
		}
		
		public function connect():void
		{
			if(socket == null){
				socket = new SnappyFlashSocket(host[ordinal++]);
			}
		}
		
		public function request(packet:ProtocolPacket, xml:Boolean = true):void
		{
			var data:ByteArray = ByteArrayUtil.createByteArray(true, xml ? packet.toXMLString() : packet.toJSONString());
			if(socket && socket.connected){
				Logger.groupStart(packet.tagname);
				Logger.info('Connection.request', packet.toXMLString());
				socket.write(data);
			}
		}
		
		public function response(parsed:Object):void
		{
			Logger.info('Connection.reponse', JSON.stringify(parsed));
			Logger.groupEnd();
			var packet:ProtocolPacket = ProtocolPacketManager.instance.createProtocolPacket(parsed.name);
			if(packet != null){
				packet.fillData(parsed.data);
				Logger.info('packet not null');
				packet.process();
			}		
		}
		
		public function close():void
		{
			if(socket && socket.connected){
				socket.close();
			}
		}
	}
}

class SingletonEnforcer
{
	
}

