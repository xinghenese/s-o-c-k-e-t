package net.gimite.packet
{
	import net.gimite.logger.Logger;
	import flash.utils.getDefinitionByName;
	/**
	 * @author Administrator
	 */
	public class ProtocolPacketTest extends ProtocolPacket
	{
		private static var _packets:Vector.<ProtocolPacket> = new Vector.<ProtocolPacket>();
		
		public function ProtocolPacketTest(data:* = null)
		{
			super(data);
		}
		
		public static function refretchPacket(name:String):ProtocolPacket
		{
			if(_packets.length == 0){
				return null;
			}
			var clzName:String = SocketProtocolInfo.getClassNameByTagName(name);
			if(clzName == null){
				return null;
			}
			var clazz:Class = getDefinitionByName(clzName) as Class;
			for(var i:uint = 0, length:uint = _packets.length; i < length; i ++){
				if(_packets[i] is clazz){
					Logger.log('fetched');
					return _packets[i].reset();
				}
			}
			return null;
//			return new clazz();
		}
		
		public final function reset():ProtocolPacket
		{
			_data = {};
			return this;
		}
	}
}
