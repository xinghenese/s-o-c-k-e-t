package net.gimite.logger
{
	import net.gimite.util.ByteArrayUtil;
	import flash.utils.ByteArray;
	import flash.external.ExternalInterface;
	/**
	 * @author Reco
	 */
	public class Logger
	{
		private static var callLog:Function = (function():Function
		{
			var fn:Function;
			var length:int = 160;
			if(ExternalInterface.available)
			{
				fn = function(task:String):Function
				{
					if(task == 'log')
					{
						return function(msg:String = ''):void
						{
							ExternalInterface.call('console.log', '%cINFO: %c', 
								'color:green; font-weight:bold;', 'word-break:break-all;', msg);
						}
					}
					else
					{
						return function(tag:String = '', msg:String = ''):void
						{
							ExternalInterface.call('console.' + task, '%c[' + tag + ']: %c', 
								'font-weight:bold;', 'word-break:break-all;', msg);
						}
					}									
				};
			}
			else
			{
				fn = function(task:String):Function
				{
					if(task == 'log')
					{
						return function(msg:String = ''):void
						{
							trace(msg);
						}	
					}
					else
					{
						return function(tag:String = '', msg:String = ''):void
						{
							trace('[' + tag + ']: ', msg);
						}	
					}									
				};
			}
			return fn;
		})();
		
		public static var log : Function = callLog('log');
//		public static var info : Function = callLog('info');
		public static var info : Function = (function():Function{
			var _info:Function = callLog('info');
			return function(tag:String = '', msg:* = null):void{
				if(msg is ByteArray){
					_info(tag, msg);
					_info(tag, ByteArrayUtil.toArrayString(msg, true, 10));
				}
				else{
					_info(tag, msg);
				}
			}
		})();
		public static var warn : Function = callLog('warn');
		public static var error: Function = (function():Function{
			var _error:Function = callLog('error');
			return function(err:*, msg:String = ''):void{
				if(err is Error){
					msg = err.message;
					err = err.name;
				}
				else{
					err = err.toString();
				}
				_error(err, msg);
			};
		})();
		
		public static function ln():void{
			ExternalInterface.call('console.log', '');
		};
		private static function writeln(fn:Function):Function{
			return function(tag:String = '', msg:* = null):void{
				fn(tag, msg);
				ln();
			}
		}
		
		public static var logln:Function = writeln(log); 
		public static var infoln:Function = writeln(info);
		public static var warnln:Function = writeln(warn);
		public static var errorln:Function = writeln(error);
		
		private static function splitBlocksWithFixedLength(str:String, length:int, separate:String, firstlength:int = 0):String
		{
			firstlength = firstlength || length;
			var result:String = separate + str.substr(start, firstlength);
			var len:int = str.length;
			var start:int = firstlength;
			while(start < len){
				result += separate + str.substr(start, length);
				start += length;
			}
//			return result.substr(1);
			return result;
		}
	}
}
