package net.gimite.packet
{
	import net.gimite.logger.Logger;
	/**
	 * @author Reco
	 */
	public final class SocketProtocolInfo
	{
		private static const prefix:String = 'net.gimite.packet::';
		
		private static const names:Object = {
			HandShakeProtocolPacket: 'HSK',
			AuthenticateProtocolPacket: 'Auth'
		};
		
		private static const keys:Object = {
			HandShakeProtocolPacket: 'pbk'
		};
		
		public static function getName(clazz:String):String
		{
			return names[clazz.replace(prefix, '')];
		}
		
		public static function getKey(clazz:String):String
		{
			Logger.info('clazz', clazz);
			return keys[clazz.replace(prefix, '')];
		}
		
		public static function getClassNameByTagName(name:String):String
		{
			if(name in names){
				return name;
			}
			for(var key in names){
				if(names.hasOwnProperty(key)){
					if(names[key] == name){
						return prefix + key;
					}
				}
			}
			return null;
		}
	}
}