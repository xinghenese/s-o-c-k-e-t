package net.gimite.flashsocket
{
	import net.gimite.connection.Connection;
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class ProtocolParser
	{
		private static var INSTANCE:ProtocolParser = null;
		
		public function ProtocolParser(enforcer:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():ProtocolParser
		{
			if(INSTANCE == null){
				INSTANCE = new ProtocolParser(new SingletonEnforcer());
			}
			return INSTANCE;
		}
		
		public function parse(data:ByteArray):void
		{
			Logger.info('ProtocolParser.parse', data);
			var raw:String = data.toString();
			var parsed:Object = null;
			try{
				parsed = parseJSON(raw);
//				parsed = parseXML(raw);
			}
			catch(e:Error){
				parsed = parseJSON(raw);
			}
			finally{
				if(parsed != null){
					Connection.instance.response(parsed);
				}
			}
		}
		
		private function parseJSON(data:String):Object
		{
			var objData:Object = JSON.parse(data);
			for(var key in objData){
				return {
					name: key,
					data: objData[key]
				}
			}
			return null;
//			return JSON.parse(data);
		}
		
		private function parseXML(data:String):Object
		{
			return parseSimpleXML(new XML(data));
		}
		
		private function parseSimpleXML(xml:XML):Object
		{
			var attrs:XMLList = xml.attributes();
			var data:Object = {};
			for each(var attr:XML in attrs){
				data[attr.name().toString()] = attr.toString();
			}
			return {
				name: xml.name().toString(),
				data: data
			}
		}
		
//		private function fireDataParsed(packet:ProtocolPacket):void
//		{
//			packet.process();
//		}
	}
}

class SingletonEnforcer
{
	
}
