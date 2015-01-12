package net.gimite.logger
{
	import flash.external.ExternalInterface;
	/**
	 * @author Reco
	 */
	public class Logger
	{
		public static function log(msg:String = ""):void
		{
			ExternalInterface.call("console.log", "%cINFO: ", "color:green; font-weight:bold;", msg);
		}
		
		public static function info(type:String = "", msg:String = ""):void
		{
			ExternalInterface.call("console.info", "%c[" + type + "]: ", "font-weight:bold;", msg);
		}
		
		public static function warn(type:String = "", msg:String = ""):void
		{
			ExternalInterface.call("console.warn", "%c[" + type + "]: ", "font-weight:bold;", msg);
		}
		
		public static function error(type:String = "", msg:String = ""):void
		{
			ExternalInterface.call("console.error", "%c[" + type + "]: ", "font-weight:bold;", msg);
		}
	}
}
