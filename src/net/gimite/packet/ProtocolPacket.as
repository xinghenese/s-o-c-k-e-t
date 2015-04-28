package net.gimite.packet
{
	import net.gimite.bridge.ScriptBridge;
	import com.hurlant.util.der.Set;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class ProtocolPacket
	{
		private static var _packets:Vector.<ProtocolPacket> = new Vector.<ProtocolPacket>();
		
		protected var _name:String = "UNTITLED";
		protected var _data:Object = {};
		protected var _keyname:String = 'msuid';
		
		public function ProtocolPacket(data:* = null)
		{
			var clzName:String = getQualifiedClassName(this);
			_name = SocketProtocolInfo.getName(clzName) || _name;
			_keyname = SocketProtocolInfo.getKey(clzName) || _keyname;
			if(data != null){
				if(data is String && _keyname){
					fillData(_keyname, data);
				}
				else if(data is Object){
					fillData(data);
				}
			}
			_packets.push(this);
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
		
		public static function createPacket2(name:String):ProtocolPacket
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
		
		public final function fillData(key:*, value:String = ''):void
		{
			if(key){
				if(value){
					_data[key] = value;
				}
				else if(key is Object){
//					for(var prop in key){
//						if(key.hasOwnProperty(prop)){
//							_data[prop] = key[prop];
//						}						
//					}
					_data = key;
				}
			}					
		}
		
		public function process():void
		{
			
		}
		
		protected function notifyJSBridge(data:Object):void
		{
			ScriptBridge.instance.fire(new ProtocolEvent(ProtocolEvent.SUCCESS, data));
		}
		
		protected final function reset():ProtocolPacket
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
