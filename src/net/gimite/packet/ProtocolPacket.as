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
		protected var _name:String = "UNTITLED";
		protected var _data:Object = {};
		protected var _keyname:String = 'msuid';
		
		public function ProtocolPacket(data:* = null)
		{
			_name = SocketProtocolInfo.getTagName(this) || _name;
			_keyname = SocketProtocolInfo.getKeyName(this) || _keyname;
			fillData(data);
		}
		
		public final function get tagname():String
		{
			return _name;
		}
		
		public final function get data():Object
		{
			return _data;
		}
		
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
