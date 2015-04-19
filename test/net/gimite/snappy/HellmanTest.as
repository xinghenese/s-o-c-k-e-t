package net.gimite.snappy {
	import com.hurlant.math.BigInteger;
	import flash.display.Sprite;
	import net.gimite.flashsocket.ProtocolParser;
	import net.gimite.flashsocket.StaticClass;
	import net.gimite.hellman.Hellman;
	import net.gimite.logger.Logger;
	import net.gimite.packet.HandShakeProtocolPacket;
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.packet.SocketProtocolName;
	import net.gimite.util.ByteArrayUtil;
	/**
	 * @author Reco
	 */
	public class HellmanTest extends Sprite {
		
		private static const PRIME:String = "f488fd584e49dbcd20b49de49107366b336c380d451d0f7c88b31c7c5b2d8ef6f3c923c043f0a55b188d8ebb558cb85d38d334fd7c175743a31d186cde33212cb52aff3ce1b1294018118d7c84a70a72d686c40319c807297aca950cd9969fabd00a509b0246d3083d66a45d419f9c7cbd894b221926baaba25ec355e92f78c7";
		private static const decPRIME:String = "171718397966129586011229151993178480901904202533705695869569760169920539808075437788747086722975900425740754301098468647941395164593810074170462799608062493021989285837416815548721035874378548121236050948528229416139585571568998066586304075565145536350296006867635076744949977849997684222020336013226588207303";
		
		private static var pbk:String;
				
		public function HellmanTest(){
			Logger.log('Welcome');
			
			var p:BigInteger = new BigInteger(PRIME, 16, true);
			
			Logger.info('pri', toArrayString(p.toString(16)));
			Logger.info('decPrime', decPRIME);
			
			var hellman:Hellman = new Hellman();
			Logger.info('public-key', toArrayString(hellman.createPub().toString(16)));
			Logger.info('public-bytes', ByteArrayUtil.toArrayString(hellman.createPub().toByteArray(), true, 16));
			
			pbk = hellman.getPublicKey();
			Logger.info('base64-encoded-public-key', pbk);
			
			try{
//				var packet:ProtocolPacket = sendInitPacket();
//				var xml:String = packet.toXMLString();
//				var json:String = packet.toJSONString()
//				Logger.info('xml', xml);
//				Logger.info('json', json);

var xml:String = (<HSK pbk={pbk}></HSK>).toXMLString();
				
				ProtocolParser.instance.parse(ByteArrayUtil.createByteArray(true, xml));
				
			}
			catch(e:Error){
				Logger.log('error in create packet');
				Logger.error(e);
			}
			
//			try{
//				var pt:StaticClass = new ProtocolPacketName();
//			}
//			catch(e:Error){
//				Logger.log('StaticClass');
//			}
//			Logger.info('')
			
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
