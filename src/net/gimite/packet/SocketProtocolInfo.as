package net.gimite.packet
{
	import flash.utils.getQualifiedClassName;
	import net.gimite.logger.Logger;
	/**
	 * @author Reco
	 */
	public final class SocketProtocolInfo
	{
		private static const prefix:String = 'net.gimite.packet::';
		
		public static const HandShakeProtocolPacketTag:String = 'HSK';
		public static const AuthenticateProtocolPacketTag:String = 'Auth';
		public static const PingProtocolPacketTag:String = 'Ping';
		
		public static const HandShakeProtocolPacketKey:String = 'pbk';
		public static const AuthenticateProtocolPacketKey:String = 'msuid';
		public static const PingProtocolPacketKey:String = 'msuid';
		
		private static const tagNames:Object = {
			HandShakeProtocolPacket: 'HSK',
			AuthenticateProtocolPacket: 'Auth',
			PingProtocolPacket: 'Ping'
		};
		
		private static const keys:Object = {
			HandShakeProtocolPacket: 'pbk'
		};
		
		public static function getClassName(clazz:*):String
		{
			if(clazz is String){
				clazz = (clazz as String).replace(prefix, '');
				if(clazz in tagNames){
					return clazz;
				}
				return null;
			}
			if(clazz is ProtocolPacket){
				return getQualifiedClassName(clazz).replace(prefix, '') || null;
			}
			return null;
		}
		
		public static function getTagName(clazz:*):String
		{
			return tagNames[getClassName(clazz)];
		}
		
		public static function getKey(clazz:*):String
		{
			Logger.info('clazz', clazz);
			return keys[getClassName(clazz)];
		}
		
		public static function getClassNameByTagName(name:String):String
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