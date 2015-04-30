package net.gimite.packet
{
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class ProtocolPacketManager
	{
		static private const reusable:Object = {
			
		};
		
		/*********************************************************************************/
		
		private static var INSTANCE:ProtocolPacketManager = null;
		private var packets:ProtocolPacketPool = null;
		
		public function ProtocolPacketManager(enforcer:SingletonEnforcer)
		{
			packets = ProtocolPacketPool.instance;
		}
		
		public static function get instance():ProtocolPacketManager
		{
			if(INSTANCE == null){
				INSTANCE = new ProtocolPacketManager(new SingletonEnforcer());
			}
			return INSTANCE;
		}
		
		/*********************************************************************************/
		
		public function removePacket(packet:ProtocolPacket):void
		{
			packets.removePacket(packet);
		}
		
		public function createProtocolPacket(tag:String, data:* = null):ProtocolPacket
		{
			Logger.info('tag', tag);
			var clzName:String = SocketProtocolInfo.getClassNameByTagName(tag);
			Logger.info('clzName', clzName);
			return packets.fetchPacket(clzName, data);
		}
		
		public function createHandShakeProtocolPacket(data:* = null):ProtocolPacket
		{
			return createProtocolPacket(SocketProtocolInfo.HandShakeProtocolPacket, data);
		}
		
		public function createAuthenticateProtocolPacket(data:* = null):ProtocolPacket
		{
			return createProtocolPacket(SocketProtocolInfo.AuthenticateProtocolPacket, data);
		}
		
		public function createPingProtocolPacket(data:* = null):ProtocolPacket
		{
			return createProtocolPacket(SocketProtocolInfo.PingProtocolPacket, data);
		}
	}
}

class SingletonEnforcer
{
	
}
