package net.gimite.packet
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import net.gimite.logger.Logger;
	/**
	 * @author Reco
	 */
	public final class SocketProtocolInfo
	{
		private static const prefix:String = 'net.gimite.packet::';
		
		public static const HandShakeProtocolPacket:String = 'HSK';
		public static const AuthenticateProtocolPacket:String = 'Auth';
		public static const PingProtocolPacket:String = 'Ping';
		public static const SocketDisconnectProtocolPacket:String = 'd';
		public static const SwitchStatusProtocolPacket:String = 'SWTSTS';
		
		private static var tagNames:Object = {};
		
		private static var keyNames:Object = {
			HandShakeProtocolPacket: 'pbk'
		};
		
		private static var reusable:Object = {
			PingProtocolPacket: true
		}
		
		private static var timeout:Object = {
			PingProtocolPacket: 1000,
			SwitchStatusProtocolPacket: 1000
		}
		
		//used to check whether the <i>SocketProtocolInfo::tagNames</i> has been initialized.
		private static var initialized:Boolean = false;
		
		/**
		 * get the tag name, e.g. 'Auth', by the protocol packet instance, e.g., [Object 
		 * AuthenticateProtocolPacket], or the definite class name of the protocol packet,
		 * e.g., 'net.gimite.packet::AuthenticateProtocolPacket'. 
		 * if nothing matched, return null.
		 */
		public static function getTagName(clazz:*):String
		{
			var clzName:String = getClassName(clazz);
			if(clzName == null){
				return null;
			}
			try{
				var result:String = SocketProtocolInfo[clzName];
			}
			catch(e:Error){
				Logger.error(e);
				return null;
			}
			return result;
		}
		
		/**
		 * get the name of the primary key of the protocol packet data.
		 * if nothing matched, return null.
		 */
		public static function getKeyName(clazz:*):String
		{
			Logger.info('clazz', clazz);
			var clzName:String = getClassName(clazz);
			if(clzName == null){
				return null;
			}
			return keyNames[clzName] || null;
		}
		
		/**
		 * get the definite class name of the protocol packet, e.g., 'net.gimite.packet::
		 * AuthenticateProtocolPacket', by the tag name, e.g., 'Auth'.
		 * if nothing matched, return null.
		 */
		public static function getClassNameByTagName(tag:String):String
		{
			initTagNames();
			
			return (tag = tagNames[tag]) ? prefix + tag : null;
		}
		
		public static function isReusable(clazz:*):Boolean
		{
			var clzName:String = getClassName(clazz);
			return reusable[clzName];
		}
		
		public static function getTimeout(clazz:*):int
		{
			var clzName:String = getClassName(clazz);
			return timeout[clzName] || 0;
		}
		
		/**
		 * get the short class name, p.s. <strong>instead of the definite class name</strong>
		 * , e.g, 'AuthenticateProtocolPacket', by the protocol packet instance, e.g., 
		 * [Object AuthenticateProtocolPacket], or the definite class name of the protocol 
		 * packet, e.g., 'net.gimite.packet::AuthenticateProtocolPacket'. 
		 * if nothing matched, return null.
		 */
		private static function getClassName(clazz:*):String
		{
			initTagNames();
			
			if(clazz is String){
				clazz = (clazz as String).replace(prefix, '');
				for each(var packet in tagNames){
					if(clazz == packet){
						return clazz;
					}
				}
				return null;
			}
			if(clazz is ProtocolPacket){
				return getQualifiedClassName(clazz).replace(prefix, '') || null;
			}
			
			return null;
		}
		
		/**
		 * init <i>SocketProtocolInfo::tagNames</i>, which makes it convenient for us to
		 * look up the class name of protocol packet with the index of the tag name.
		 */
		private static function initTagNames():void
		{
			if(initialized){
				return;
			}
			
			var constants:XMLList = describeType(SocketProtocolInfo).constant;
			
			for(var i:int = 0, len:int = constants.length(); i < len; i ++){
				var key:String = constants[i].@name;
				tagNames[SocketProtocolInfo[key]] = key;
			}
			
			initialized = true;
		}
	}
}