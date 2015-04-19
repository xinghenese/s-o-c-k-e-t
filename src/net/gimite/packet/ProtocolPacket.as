package net.gimite.packet
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class ProtocolPacket
	{
		protected var _name:String = "UNTITLED";
		protected var _data:Object = {};
		protected var _keyvalue:String;
		
		public function ProtocolPacket(data:* = null)
		{
			_name = SocketProtocolName.getName(getQualifiedClassName(this)) || _name;
			if(data != null){
				if(data is String && _keyvalue){
					fillData(_keyvalue, data);
				}
				else if(data is Object){
					fillData(data);
				}				
			}
		}
		
		public static function createPacket(name:String):ProtocolPacket
		{
			var clzName:String = SocketProtocolName.getClassName(name);
			if(clzName == null){
				return new ProtocolPacket();
			}
			var clazz:Class = getDefinitionByName(clzName) as Class;
			return new clazz();
		}
		
		public final function get name():String
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
		
		public final function toJSONString():String
		{
			return JSON.stringify(this);
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
