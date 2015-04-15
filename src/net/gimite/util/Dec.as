package net.gimite.util
{
	import flash.utils.Endian;
	import net.gimite.snappy.Bytes;
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class Dec
	{
		private static var base:int = 256;
		private static const deci:int = 10;
		private static const split:int = 8;
		private static const extra:int = Math.pow(5, split);
		private static const extra_bytes:ByteArray = ByteArrayUtil.createByteArray(false, extra);
		
		public static function toArray(dec:String):ByteArray{
			if(dec.length == 0){
				return new ByteArray();
			}
			
//			Logger.log('extra: ' + extra);
			
			var result:ByteArray = ByteArrayUtil.createByteArray(false);
			
			var pos:int = dec.length;
			var last_pos:int = pos;
			var i:int = 0;
			do{
				last_pos = pos;
				pos = Math.max(pos - split, 0);
				
				//Checked
				var _bytes:ByteArray = ByteArrayUtil.createByteArray(false, parseInt(dec.substring(pos, last_pos)));
				Logger.log(dec.substring(pos, last_pos));
//				Logger.info('_bytes', ByteArrayUtil.toArrayString(_bytes));				
//				Logger.info('cal', fromArray(_bytes));
				//
				
				var bytes:ByteArray = i > 0 ? ByteArrayUtil.mutiplyByteArrays(_bytes, extra_bytes) : _bytes;
				
//				if(i==1){
					Logger.info('original' + i, ByteArrayUtil.toArrayString(_bytes, true, 16));
					Logger.info('times', ByteArrayUtil.toArrayString(extra_bytes, true, 16));
					Logger.info('multiply' + i, ByteArrayUtil.toArrayString(bytes, true, 16));
//				}
				
				
//				Logger.info('bytes', ByteArrayUtil.toArrayString(bytes));
//				Logger.info('num      ', fromArray(bytes));
//				Logger.info('right-num', int(dec.substring(pos, last_pos))*extra);

				for(var j:int = 0, len:int = ByteArrayUtil.getSignificantLength(bytes); j<len; j++){
					//进位
					ByteArrayUtil.setCarry(result, i + j, bytes[j] + (result[i + j] || 0));
				}
				i++;
				
			}while(pos>0);
			
//			Logger.log('dec-array: ' + ByteArrayUtil.toArrayString(result));
//			Logger.log('endian: ' + result.endian);
			
			return result;
		}
		
		public static function fromArray(arr:*, little_endian:Boolean = true):int{
			if(!(arr is ByteArray || arr is Array)){
				return 0;
			}
			var sum:int = 0;
			
			if(arr is ByteArray && arr.endian == Endian.LITTLE_ENDIAN || arr is Array && little_endian){
				for(var i:int = arr.length - 1; i>=0; i--){
					sum = sum * base + arr[i];
				}
			}
			else{
				for(i = 0; i<arr.length; i++){
					sum = sum * base + arr[i];
				}
			}			
			
			return sum;
		}
		
		public static function setBase(b:int):void{
			base = b;
		}
		
		public static function simpleToArray(dec:*):Array{
			var d:uint = uint(dec);
			var result:Array = new Array();
			do{
				result.push(d % base);
			}while((d = ~~(d / base)) > 0);	
			return result;	
		}
	}
}
