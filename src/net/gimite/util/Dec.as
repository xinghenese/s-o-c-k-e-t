package net.gimite.util
{
	import net.gimite.snappy.Bytes;
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class Dec
	{
		private static var base:int = 256;
		
		public static function toArray(dec:String):ByteArray{
			if(dec.length == 0){
				return new ByteArray();
			}
			var _resl:Array = new Array();
			var pos:int = dec.length;
			var i:int = 0;
			do{
				pos = Math.max(pos-8, 0);
				var d:int = int(dec.substr(pos,8));
				var arr:Array = simpleToArray(d);
				for(var j:int = 0, len:int = arr.length; j<len; j++){
					_resl[i+j] = arr[j] + (_resl[i+j] || 0);
					//进位
					if(_resl[i+j] > base){
						_resl[i+j+1] = ~~(_resl[i+j] / base) + (_resl[i+j+1] || 0);
						_resl[i+j] = _resl[i+j] % base;
					}
				}
				i++;
				
			}while(pos>0);
			
			Logger.log('dec-array: ' + _resl);
			
			var result:ByteArray = Bytes.fromArray(_resl, false);
			
			Logger.log('dec-array: ' + _resl);
			Logger.log('dec-bytearray: ' + Bytes.toArrayString(result));
			Logger.log('endian: ' + result.endian);
			return result;
		}
		
		public static function fromArray(arr:ByteArray, little_endian:Boolean = true):int{
			for(var i:int = arr.length - 1, sum:int = 0; i>=0; i--){
				sum = sum * base + arr[i];
			}
			return sum;
		}
		
		public static function setBase(b:int):void{
			base = b;
		}
		
		public static function simpleToArray(dec:*):Array{
			var d:int = int(dec);
			var result:Array = new Array();
			do{
				result.push(d % base);
			}while((d = ~~(d / base)) > 0);	
			return result;	
		}
	}
}
