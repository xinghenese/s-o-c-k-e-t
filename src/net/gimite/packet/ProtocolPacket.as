package net.gimite.packet
{
	import net.gimite.bridge.ScriptBridge;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * @author Administrator
	 */
	public class ProtocolPacket
	{
		private static var _packets:Vector.<ProtocolPacket> = new Vector.<ProtocolPacket>();
		private static const NOT_EXIST:int = -1;
		
		protected var _name:String = "UNTITLED";
		protected var _data:Object = {};
		protected var _keyname:String = 'msuid';
		
		private var _index:int = NOT_EXIST;
		
		public function ProtocolPacket(data:* = null)
		{
			var clzName:String = getQualifiedClassName(this);
			_name = SocketProtocolInfo.getTagName(this) || _name;
			_keyname = SocketProtocolInfo.getKey(this) || _keyname;
			if(data != null){
				if(data is String && _keyname){
					fillData(_keyname, data);
				}
				else if(data is Object){
					fillData(data);
				}
			}
			_index = _packets.push(this) - 1;
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
			var packet:ProtocolPacket = findPacket(clzName);
			if(packet != null){
				return packet.reset();
			}
			return null;
		}
		
		private static function findPacket(clzName:String):ProtocolPacket
		{
			var clazz:Class = getDefinitionByName(clzName) as Class;
			for(var i:uint = 0, length:uint = _packets.length; i < length; i ++){
				if(_packets[i] is clazz){
					return _packets[i];
				}
			}
			return null;
		}
		
		public static function createPacket(name:String):ProtocolPacket
		{
			var clzName:String = SocketProtocolInfo.getClassNameByTagName(name);
			if(clzName == null){
				return new ProtocolPacket();
			}
			var clazz:Class = getDefinitionByName(clzName) as Class;
			return new clazz();
		}
		
		public final function get tagname():String
		{
			return _name;
		}
		
//		public final function get data():Object
//		{
//			return _data;
//		}
		
		public final function getData(key:*):String
		{
			return _data[key];
		}
		
		public final function fillData(key:*, value:String = ''):ProtocolPacket
		{
			if(key){
				if(value){
					_data[key] = value;
				}
				else if(key is String && _keyname){
					_data[_keyname] = key;
				}
				else if(key is Object){
					_data = key;
				}
			}
			return this;				
		}
		
		public function serialize(json:Boolean = true):String
		{
			if(json){
				return toJSONString();
			}
			return toXMLString();
		}
		
		public function process():void
		{
			
		}
		
		protected function dispose():void
		{
			ProtocolPacketManager.instance.removePacket(this);
		}
		
		protected function notifyJSBridge(data:Object):void
		{
			ScriptBridge.instance.fire(new ProtocolEvent(ProtocolEvent.SUCCESS, data));
		}
		
		public final function reset():ProtocolPacket
		{
			_data = {};
			return this;
		}
		
		public final function toJSONString():String
		{
			var result:Object = {};
			result[_name] = _data;
			return JSON.stringify(result);
		}
		
		public final function toXMLString():String
		{
			return toXML().toXMLString().replace(/\/>$/, '></' + _name + '>');
		}
		
		private function toXML():XML
		{
			var xml:XML = <{_name}/>;
			for(var key:String in _data){
				xml.@[key] = _data[key];
			}
			return xml;
		}
	}
}
