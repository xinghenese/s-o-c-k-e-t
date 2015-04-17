package net.gimite.flashsocket
{
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class ProtocolParser
	{
		private static var INSTANCE:ProtocolParser = null;
		
		private static const secret:Number = Math.random();
		
		public function ProtocolParser(enforcer:Number)
		{
			if(enforcer != secret){
				throw new Error("Error: use Singleton instance instead.");
			}
		}
		
		public static function get instance():ProtocolParser
		{
			if(INSTANCE == null){
				INSTANCE = new ProtocolParser(secret);
			}
			return INSTANCE;
		}
		
		public function parse(data:ByteArray):void
		{
			Logger.info('data', data);
			var result:ProtocolPacket = parseSimpleXML(new XML(data.toString()));
			fireDataParsed(result);
		}
		
		private function parseSimpleXML(xml:XML):ProtocolPacket
		{
			var result:ProtocolPacket = new ProtocolPacket(xml.name().toString());
			var attrs:XMLList = xml.attributes();
			for each(var attr:XML in attrs){
				result.fillData(attr.name().toString(), attr.toString());
			}
			return result;
		}
		
		private function fireDataParsed(data:ProtocolPacket):void
		{
			Logger.info('parsed', JSON.stringify(data));
		}
	}
}
