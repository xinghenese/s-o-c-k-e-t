package net.gimite.snappy
{
	import net.gimite.logger.Logger;
	import net.gimite.flashsocket.SnappyFlashSocket;
	import flash.display.Sprite;
	import net.gimite.flashsocket.FlashSocket;
	/**
	 * @author Administrator
	 */
	public class FlashSocketTest extends Sprite
	{
		private var host:Array = ["192.168.0.110", "192.168.1.66", "192.168.1.67", "192.168.1.68", "192.168.0.66", "192.168.0.67", "192.168.0.68"];
		private var ordinal:int = 4;
		private var socket:FlashSocket;
		
		public function FlashSocketTest():void
		{					
			connect();
		}
		
		public function connect():void
		{
			var _host:String = host[ordinal++];
			if(_host){
//				socket = new SnappyFlashSocket(_host);
				var xmlString:String = "<HSK pbk=\"Re0M65x0B6lteiG/3Wm5LiT/7EvKxl39WZE8C7g40vTEN49+bjq84/lITSmsaJG1G3qk112vLIihMgNEpOCDbFtQODTMFg0QDxTKgAQ8zuK1Bgd+/bw/xYCik4lEC66pNryT4OO+LiIa19LuAJREIPN7C3pxHfnO1Jv7l2HhoH8=\"></HSK>";
//				var xmlString:String = "<a prop=\"1\"><b></b></a>";
				try{
					Logger.info('xml', xmlString);
					Logger.info('xml', JSON.stringify(parseSimpleXMLString(xmlString)));
				}
				catch(e:Error){
					Logger.error(e);
				}
			}
		}
		
		public function parseSimpleXMLString(xml:String):Object
		{
			return parseSimpleXML(new XML(xml));
		}
		
		public function parseSimpleXML(xml:XML):Object
		{
			var result:Object = {};
			result.name = xml.name().toString();
			var attrs:XMLList = xml.attributes();
			for each(var attr:XML in attrs){
				result[attr.name().toString()] = attr.toString();
			}
			return result;
		}
	}
}
