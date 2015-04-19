package net.gimite.flashsocket
{
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	import net.gimite.packet.ProtocolPacket;
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
			Logger.info('data', data);
			var raw:String = data.toString();
			var parsed:Object = null;	
			try{
				parsed = parseXML(raw);
			}
			catch(e:Error){
				parsed = parseJSON(raw);
			}
			finally{
				if(parsed != null){
					var packet:ProtocolPacket = ProtocolPacket.createPacket(parsed.name);
					packet.fillData(parsed.data);
					fireDataParsed(packet);
				}
			}
		}
		
		private function parseJSON(data:String):Object
		{
			return JSON.parse(data);
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
		
		private function fireDataParsed(packet:ProtocolPacket):void
		{
			packet.process();
		}
	}
}

class SingletonEnforcer
{
	
}
