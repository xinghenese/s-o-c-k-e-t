package net.gimite.packet
{
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class ProtocolPacketManager
	{
		static private const prefix:String = 'net.gimite.packet::';
		static private const tagNames:Object = {
			HandShakeProtocolPacket: 'HSK',
			AuthenticateProtocolPacket: 'Auth',
			PingProtocolPacket: 'Ping'
		};		
		static private const keys:Object = {
			HandShakeProtocolPacket: 'pbk'
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
			var clzName:String = getClassNameByTagName(tag);
			Logger.info('clzName', clzName);
			return packets.fetchPacket(clzName, data);
		}
		
		public function createHandShakeProtocolPacket(data:* = null):ProtocolPacket
		{
			return createProtocolPacket(SocketProtocolInfo.HandShakeProtocolPacketTag, data);
		}
		
		public function createAuthenticateProtocolPacket(data:* = null):ProtocolPacket
		{
			return createProtocolPacket(SocketProtocolInfo.AuthenticateProtocolPacketTag, data);
		}
		
		public function createPingProtocolPacket(data:* = null):ProtocolPacket
		{
			return createProtocolPacket(SocketProtocolInfo.PingProtocolPacketTag, data);
		}
		
		private static function getPrimaryKey():void
		{
			
		}
		
		private static function getClassNameByTagName(name:String):String
		{
			if(name in tagNames){
				return prefix + name;
			}
			for(var key in tagNames){
				if(tagNames.hasOwnProperty(key)){
					if(tagNames[key] == name){
						return prefix + key;
					}
				}
			}
			return null;
		}
	}
}

class SingletonEnforcer
{
	
}
