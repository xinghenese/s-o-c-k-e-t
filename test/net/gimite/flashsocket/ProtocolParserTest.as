package net.gimite.flashsocket
{
	import net.gimite.connection.ConnectionTest;
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class ProtocolParserTest
	{
		private static var INSTANCE:ProtocolParserTest = null;
		
		public function ProtocolParserTest(enforcer:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():ProtocolParserTest
		{
			if(INSTANCE == null){
				INSTANCE = new ProtocolParserTest(new SingletonEnforcer());
			}
			return INSTANCE;
		}
		
		public function parse(data:ByteArray):void
		{
			Logger.info('ProtocolParser.parse', data);
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
					ConnectionTest.instance.response(parsed);
				}
			}
		}
		
		protected function parseJSON(data:String):Object
		{
			return JSON.parse(data);
		}
		
		protected function parseXML(data:String):Object
		{
			return parseSimpleXML(new XML(data));
		}
		
		protected function parseSimpleXML(xml:XML):Object
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
	}
}

class SingletonEnforcer
{
	
}
