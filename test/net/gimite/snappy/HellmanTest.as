package net.gimite.snappy {
	import net.gimite.hellman.KeyExchange;
	import com.hurlant.util.Base64;
	import flash.utils.ByteArray;
	import com.hurlant.math.BigInteger;
	import flash.display.Sprite;
	import net.gimite.flashsocket.ProtocolParser;
	import net.gimite.hellman.Hellman;
	import net.gimite.logger.Logger;
	import net.gimite.packet.HandShakeProtocolPacket;
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.packet.SocketProtocolInfo;
	import net.gimite.util.ByteArrayUtil;
	/**
	 * @author Reco
	 */
	public class HellmanTest extends Sprite {
		
		private static var pbk:String;
				
		public function HellmanTest(){
			Logger.log('Welcome');
			
			var hellman:KeyExchange = new Hellman();
			
			pbk = hellman.getPublicKey();
			Logger.info('base64-encoded-public-key', pbk);
			
			
//			var pbkFromServer:String = "aIPoZs+F0pBpPZj91IDkrc1Rvhh5AGH/rvVSFcXmji1ezhKEOOxsLY5Fs81cOk1YAA6MKjpp4p0dRxwNZ3iNIREDO4+FE9dm1V+4owpQtp8Y+gNhlO6iUzTOee3W2hxf1X+A72iqy9aDQz74cSOsUkuVfKjx/RLsUOb0KV5R22U=";
//			Logger.info('pbkFromServer', pbkFromServer);

			var pbkArraysFromServer:Array = [0, -75, 120, -89, 15, 8, -74, 34, -43, -29, 13, 114, -24, -44, -4, -68, 0, -42, 64, -104, -79, -76, 2, 25, -118, 116, -10, -84, -40, -62, -21, -28, 64, -43, 46, -30, 116, -7, 95, -3, 38, -17, 17, 110, -119, 9, -89, -5, -14, -43, 101, 5, 13, 0, -97, -104, -96, -128, -12, -49, 118, -7, 54, 11, 97, -11, 25, -119, 7, 8, 119, -12, 48, 50, -55, -27, -47, 42, -73, -126, 100, -64, 102, -60, -19, -87, 90, 99, 89, -29, 12, 37, 41, 106, 122, -105, -116, -17, -46, 2, 13, 3, -59, 80, 77, -5, -60, -99, -115, -90, -9, -102, -105, 85, 39, -27, -110, -94, -62, 100, 126, 96, 45, -56, -47, 76, 106, 42, 35];
			var pbkBytesFromServer:ByteArray = ByteArrayUtil.createByteArray(true,pbkArraysFromServer);
			
			Logger.info('pbkFromServer', Base64.encodeByteArray(pbkBytesFromServer));
			
			Logger.info('pbkBytesFromServer', pbkBytesFromServer);
			Logger.info('pbkBytesFromServer.position', pbkBytesFromServer.position);
			
			var RCkey:String = hellman.getEncryptKey(pbkBytesFromServer);
			
			Logger.info('RCKey', RCkey);
			
			Logger.log('snappy');
			
			var arr:Array = [123, 34, 72, 83, 75, 34, 58, 123, 34, 112, 98, 107, 34, 58, 34, 65, 103, 76, 57, 76, 86, 92, 47, 87, 98, 112, 104, 82, 72, 50, 89, 104, 106, 76, 107, 84, 100, 66, 78, 87, 89, 87, 111, 78, 74, 120, 67, 71, 119, 119, 114, 116, 79, 106, 87, 77, 85, 56, 71, 106, 87, 83, 120, 103, 102, 74, 112, 120, 100, 83, 84, 70, 105, 118, 89, 72, 53, 97, 51, 110, 75, 115, 85, 88, 77, 118, 100, 88, 110, 55, 48, 107, 104, 88, 97, 99, 83, 79, 48, 86, 101, 78, 89, 102, 56, 70, 122, 108, 118, 98, 105, 72, 100, 92, 47, 116, 50, 50, 102, 105, 74, 86, 121, 101, 75, 57, 88, 43, 107, 87, 118, 108, 111, 87, 119, 104, 98, 80, 85, 102, 78, 76, 83, 119, 100, 70, 88, 111, 98, 66, 48, 119, 73, 105, 82, 98, 82, 103, 68, 53, 117, 111, 76, 107, 76, 65, 85, 117, 77, 99, 83, 79, 82, 107, 117, 68, 83, 66, 118, 87, 52, 98, 78, 83, 89, 104, 98, 69, 61, 34, 125, 125];
			var bts:ByteArray = ByteArrayUtil.createByteArray(true, "<Auth ver=\"3.8.15.1\" token=\"csyKLiEOLLTHWeBCWhEYIYP1XHX29zXkNxeGpDiu4AZ8m_u_rvOAs0rahTj1Gp5ME3IRoPORJXm5ISBjin1tOcf6qfjXFg2C60RXywN9xgYrozz1RV5ZODstLkbXeQNOumv1GdiBGQU_F-UZDgaKfSgQkxg16d2vC3L3qnRSEYA\" msuid=\"30147510\" dev=\"1\" zip=\"1\" v=\"1.0\" devn=\"Sony Xperia Z - 4.2.2 - API 17 - 1080x1920_e4165df6-a6d8-4873-a5ea-d433085fb120\"></Auth>");
			
			Logger.info('before-snappy-encode', bts);
			
			var result:ByteArray = (new SnappyFrameEncoder()).encode(bts);
			
			Logger.info('after-snappy-encode', result);
			
		}
		
		
		private static function sendInitPacket():ProtocolPacket{
			var packet:ProtocolPacket = new HandShakeProtocolPacket();
			packet.fillData('pbk', pbk);
			

//			var o:Object = {'pbk':pbk};
//			var a = o.a;
//			var b = o.b;
//			
//			var xml = <HSK></HSK>;
//			
//			for(var key in o){
//				xml.@[key] = o[key];
//			}
			return packet;
		}
		
		private function parseJSON():void
		{
			try{
				var json:Object = JSON.parse('<a p="d"></a>');
				Logger.info('json', json);
			}
			catch(e:Error){
				Logger.log('error in parsing json');
				Logger.error(e);
			}
		}
		
		private function parseXML():void
		{
			try{
				var xml:XML = new XML('{a:1, b:2}');
				Logger.info('new xml string', xml.toXMLString());
				Logger.info('new xml', xml.name().toString());
			}
			catch(e:Error){
				Logger.log('error in parsing xml');
				Logger.error(e);
			}
		}
		
		private static function toArrayString(hex:String):String{
			var result:String = "]";
			if(hex == null){
				return null;
			}
			if(hex.length == 0){
				return "[]";
			}
			for(var i:int = hex.length; i > 0; i -= 2){
				var start:int = Math.max(i-2, 0);
				result = hex.substring(start, i) + ', ' + result;
			}
			result = '[' + result;
			return result;
		}
		
	}
}
