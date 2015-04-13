package net.gimite.snappy
{
	import flash.utils.Endian;
	import net.gimite.util.ByteArrayUtil;
	import flash.display.Sprite;
	import net.gimite.logger.Logger;
	import com.hurlant.math.BigInteger;
	import net.gimite.util.Dec;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class DecTest extends Sprite
	{
		public function DecTest(){
					
			var str:String = "171718397966129586011229151993178480901904202533705695869569760169920539808075437788747086722975900425740754301098468647941395164593810074170462799608062493021989285837416815548721035874378548121236050948528229416139585571568998066586304075565145536350296006867635076744949977849997684222020336013226588207303";
			
			var str2:String = "1234567890123";
			
			Logger.info('unit', uint(10) & 0xFF);
			
			var a:ByteArray = Dec.toArray(str2);
//			var b:BigInteger = new BigInteger(str);
			var c:BigInteger = new BigInteger(a);
//			var d:BigInteger = new BigInteger('100');
			
			Logger.log("AAA: " + str);
			Logger.info('a', ByteArrayUtil.toArrayString(a));
//			Logger.log("b: " + b.toString());
			Logger.log("c: " + c.toString(10));
//			Logger.log("d: " + d.toString(10));
			
			var num:String = '1234567890123';
			Logger.log('num: ' + num);
			
			var toarr:Array = toArray(num);
			
			var intBaseExtra:uint = Math.pow(10, 8) + 2;
			var arrBaseExtra:Array = Dec.simpleToArray(intBaseExtra);
			Logger.log('base_extra: 5^8');
			Logger.info('base_extra', intBaseExtra);
			Logger.info('simpleToArray', arrBaseExtra);
			Logger.info('sumToCheck', Dec.fromArray(arrBaseExtra));
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.writeInt(intBaseExtra);
			Logger.info('bytes', ByteArrayUtil.toArrayString(bytes));
			
			var bytes1:ByteArray = new ByteArray();
			bytes1.endian = Endian.LITTLE_ENDIAN;
			bytes1.writeInt(toarr[1]);
			Logger.info('bytes1', ByteArrayUtil.toArrayString(bytes1));
			
			var bytes2:ByteArray = ByteArrayUtil.mutiplyByteArrays(bytes, bytes1);
			Logger.info('mutiply-arr', ByteArrayUtil.toArrayString(bytes2));
			bytes2.position = 0;
			try{
				while(bytes2.bytesAvailable > 0){
					Logger.info('mutiply-num', bytes2.readInt());
				}				
			}
			catch(e:Error){
				
			}			
			
			var bytes3:ByteArray = new ByteArray();
			bytes3.endian = Endian.LITTLE_ENDIAN;
			bytes3.writeInt(intBaseExtra * toarr[1]);
			Logger.info('bytes', ByteArrayUtil.toArrayString(bytes3));
			Logger.info('num', Dec.fromArray(bytes3));
			
		}
		
		public function toArray(dec:String):Array{
			var _resl:Array = new Array();
			var pos:int = dec.length;
			var last_pos:int = pos;
			var i:int = 0;
			do{
				last_pos = pos;
				pos = Math.max(pos-8, 0);
				var d:int = int(dec.substring(pos, last_pos));
				_resl[i++] = d;
				
			}while(pos>0);

			return _resl;
		}
	}
}
