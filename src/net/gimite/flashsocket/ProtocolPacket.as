package net.gimite.flashsocket
{
	/**
	 * @author Administrator
	 */
	public class ProtocolPacket
	{
		private var _name:String = "UNTITLED";
		private var _data:Object = {};
		
		public function ProtocolPacket(name:String)
		{
			_name = name;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function fillData(key:String, value:String):void
		{
			_data[key] = value;
		}
		
		public function toXMLString():String
		{
			return toXML().toXMLString().replace(/\/>$/, '></' + _name + '>');
		}
		
		public function toXML():XML
		{
			var xml:XML = <{_name}></{_name}>;
			for(var key:String in _data){
				xml.@[key] = _data[key];
			}
			return xml;
		}
	}
}
