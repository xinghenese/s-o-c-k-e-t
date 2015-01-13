package net.gimite.logger
{
	import flash.external.ExternalInterface;
	/**
	 * @author Reco
	 */
	public class Logger
	{
		private static var callLog:Function = (function():Function
		{
			var fn:Function;
			if(ExternalInterface.available)
			{
				fn = function(task:String):Function
				{
					if(task == "log")
					{
						return function(msg:String = ""):void
						{
							ExternalInterface.call("console.log", "%cINFO: ", "color:green; font-weight:bold;", msg);
						}
					}
					else
					{
						return function(tag:String = "", msg:String = ""):void
						{
							ExternalInterface.call("console." + task, "%c[" + tag + "]: ", "font-weight:bold;", msg);
						}	
					}									
				};
			}
			else
			{
				fn = function(task:String):Function
				{
					if(task == "log")
					{
						return function(msg:String = ""):void
						{
							trace(msg);
						}	
					}
					else
					{
						return function(tag:String = "", msg:String = ""):void
						{
							trace("[" + tag + "]: ", msg);
						}	
					}									
				};
			}
			return fn;
		})();
		
		public static var log : Function = callLog("log");
		public static var info : Function = callLog("info");
		public static var warn : Function = callLog("warn");
		public static var error : Function = callLog("error");

	}
}
