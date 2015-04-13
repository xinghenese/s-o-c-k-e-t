package net.gimite.util
{
	import net.gimite.logger.Logger;
	import flash.utils.Endian;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class ByteArrayUtil
	{
		private static var base:int = 256;
		
		public static function createByteArray(big_endian:Boolean = true, value:* = null, bit:int = 0):ByteArray{
			var bytes:ByteArray = new ByteArray();
			if(!big_endian){
				bytes.endian = Endian.LITTLE_ENDIAN;
			}
			if(value){
				switch (true){
					case (value is Boolean):
						bytes.writeBoolean(value);
						break;
					case (value is uint):
						bytes.writeUnsignedInt(value);
						break;
					case (value is int):
						switch (bit){
							case 1:
								bytes.writeByte(value);
								break;
							case 2:
								bytes.writeShort(value);
								break;
							default:
								bytes.writeInt(value);
								break;
						}
						break;
					case (value is Number):
						if(bit == 32){
							bytes.writeFloat(value);					
						}
						else{
							bytes.writeDouble(value);
						}
						break;
					case (value is String):
						bytes.writeUTFBytes(value);
						break;
					case (value is ByteArray):
						bytes.writeBytes(value, 0, bit);
						break;
					default:
						break;
				}
			}
			return bytes;
		}
		
		public static function addUpByteArrays(bytes1:ByteArray, bytes2:ByteArray):ByteArray
		{
			return processWithAccordingBits(bytes1, bytes2, function(x:int, y:int, z:int):int{
				return x + y;
			});
		}
		
		public static function substractByteArrays(bytes1:ByteArray, bytes2:ByteArray):ByteArray
		{
			return processWithAccordingBits(bytes1, bytes2, function(x:int, y:int, z:int):int{
				return x - y;
			});
		}
		
		public static function mutiplyByteArrays(bytes1:ByteArray, bytes2:ByteArray):ByteArray
		{
			return processWithCrossBits(bytes1, bytes2, function(x:int, y:int, z:int):int{
				return x * y + z;
			});
		}
		
		private static function processWithAccordingBits(bytes1:ByteArray, bytes2:ByteArray, process:Function):ByteArray
		{
			var result:ByteArray = createByteArray(false);
			for(var i:int = 0, len:int = Math.max(getSignificantLength(bytes1), getSignificantLength(bytes2)); i<len; i++){
				//进位s
				setCarry(result, i, process(bytes1[i] || 0, bytes2[i] || 0, result[i]||0));
			}
			return result;
		}
		
		private static function processWithCrossBits(bytes1:ByteArray, bytes2:ByteArray, process:Function):ByteArray
		{
			var result:ByteArray = createByteArray(false);
			for(var i:int = 0, len1:int = getSignificantLength(bytes1); i<len1; i++){
				for(var j:int = 0, len2:int = getSignificantLength(bytes2); j<len2; j++){
					//进位
					setCarry(result, i + j, process(bytes1[i] || 0, bytes2[j] || 0, result[i + j] || 0));
				}
			}
			return result;
		}
		
		public static function setCarry(bytes:ByteArray, index:int, value:int):void
		{
			if(value >= base){
				bytes[index+1] = ~~(value / base) + (bytes[index+1] || 0);
				bytes[index] = value % base;
			}
			else{
				bytes[index] = value;
			}
		}
		
		public static function getSignificantLength(bytes:ByteArray):int
		{
			for(var i:int = bytes.length; i>0; i--){
				if(bytes[i - 1] != 0){
					return i;
				}
			}
			return 0;
		}
		
		public static function fromArray(arr:Array, big_endian:Boolean = true):ByteArray
		{
			var bytes:ByteArray = createByteArray(big_endian);
			arr.forEach(function(item:*, index:int, array:Array):void
			{
				bytes.writeByte(int(item));
			});
			bytes.position = 0;
			return bytes;
		}
		
		public static function toByteString(value:*, radius:int = 10):String
		{
			var bytes:ByteArray = createByteArray(true, value);
			return toArrayString(bytes);
		}
		
		public static function toArrayString(bytes:ByteArray, radius:int = 10):String
		{
			var result:String = "[", pos:int = bytes.position;
			bytes.position = 0;
			while(bytes.bytesAvailable)
			{
				result = result + bytes.readByte().toString(radius) + ", ";
			}
			bytes.position = pos;
			return result.replace(/,\s$/, "]");
		}
		
	}
}
