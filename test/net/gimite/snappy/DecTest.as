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
			
//			Logger.log(str.length);
			
//			var str2:String = "1234567890123";
			var str2:String = "12345678901234567890";
			
//			Logger.info('str2', parseInt(str2));
//			Logger.info('str2', ByteArrayUtil.toByteString(parseInt(str2)));
//			Logger.info('str2', ByteArrayUtil.toArrayString(Dec.toArray(str2)));
			
			var int1:int = 0x12345678;
//			var int1:int = 0x1234;
			var bts_int1:ByteArray = ByteArrayUtil.createByteArray(false, int1);
//			Logger.info('int1', int1.toString());
//			Logger.info('0x-int1', int1.toString(16));
//			Logger.info('bts_int1', ByteArrayUtil.toArrayString(bts_int1, true, 16));
			
			var times:int = Math.pow(5, 8);
			var bts_times:ByteArray = ByteArrayUtil.createByteArray(false, times);
//			Logger.info('times', times.toString());
//			Logger.info('0x-times', times.toString(16));
//			Logger.info('bts_times', ByteArrayUtil.toArrayString(bts_times, true, 16));
			var result:ByteArray = Dec.toArray(str);
//			var result2:ByteArray = ByteArrayUtil.createByteArray(true, result);
			Logger.info('result', ByteArrayUtil.toArrayString(result, true, 16));
			Logger.info('length', result.length);
			
//			Logger.info('result2', result2);
//			
//			Logger.log('cache?');

//			var int3:int = 60132265;
//			var bts_int3:ByteArray = ByteArrayUtil.createByteArray(false, int3);
//			Logger.info('int3', int3);
//			Logger.info('bts_int3', ByteArrayUtil.toArrayString(bts_int3, true, 16));
//			Logger.info('bts_times', ByteArrayUtil.toArrayString(bts_times, true, 16));
//			var mutiply3:ByteArray = ByteArrayUtil.mutiplyByteArrays(bts_int3, bts_times);
//			Logger.info('mutiply3', ByteArrayUtil.toArrayString(mutiply3, true, 16));
			
						
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
