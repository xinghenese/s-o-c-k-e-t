package net.gimite.snappy
{
	import flash.utils.Endian;
	import net.gimite.util.Dec;
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	import com.hurlant.math.BigInteger;
	import net.gimite.flashsocket.SocketListener;
	import flash.events.Event;
	import flash.display.Sprite;
	import net.gimite.flashsocket.FlashSocket;
	/**
	 * @author Administrator
	 */
	public class FlashSocketTest extends Sprite
	{
		private var host:Array = ["192.168.1.66", "192.168.1.67", "192.168.1.68"];
		private var ordinal:int = 0;
		private var socket:FlashSocket;
		
		public function FlashSocketTest():void
		{
			var str:String = "171718397966129586011229151993178480901904202533705695869569760169920539808075437788747086722975900425740754301098468647941395164593810074170462799608062493021989285837416815548721035874378548121236050948528229416139585571568998066586304075565145536350296006867635076744949977849997684222020336013226588207303";
						
			var a:ByteArray = Dec.toArray(str);
			var b:BigInteger = new BigInteger(str);
			var c:BigInteger = new BigInteger(a);
			var d:BigInteger = new BigInteger('100');
			Logger.log("AAA: " + str);
			Logger.log("b: " + b.toString());
			Logger.log("c: " + c.toString(10));
			Logger.log("d: " + d.toString(10));
			
			var num:int = 400*256*255 + 563*254 + 7;
			Logger.log('num: ' + num);
			var a2:ByteArray = Dec.toArray((num).toString());
			Logger.log('simpleToArray: ' + Bytes.toArrayString(a2));
			Logger.log('sum: ' + Dec.fromArray(a2));
			
			
			var bts:ByteArray = new ByteArray();
			bts.writeByte(10);
			bts.writeByte(20);
			
			Array.prototype.reverse.call(bts);
			
//			Logger.log('readbyte: ' + bts.readByte());
			bts.position = 0;
			Logger.log('readbyte1: ' + Bytes.toArrayString(bts));
					
			connect();
		}
		
		public function connect():void
		{
			var _host:String = host[ordinal++];
			if(_host){
				socket = new FlashSocket(_host);
			}
		}
	}
}
