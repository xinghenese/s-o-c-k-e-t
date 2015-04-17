package net.gimite.snappy {
	import net.gimite.flashsocket.ProtocolPacket;
	import net.gimite.util.ByteArrayUtil;
	import net.gimite.hellman.Hellman;
	import com.hurlant.math.BigInteger;
	import net.gimite.logger.Logger;
	import flash.display.Sprite;
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
				Logger.info('xml', sendInitPacket());
				Logger.log('xml');
			}
			catch(e:Error){
				Logger.error(e);
			}
//			Logger.info('')
			
		}
		
		private static function sendInitPacket():String{
//			var packet:ProtocolPacket = new ProtocolPacket('HSK');
//			packet.fillData('pbk', pbk);
			var o:Object = {'pbk':pbk};
			var a = o.a;
			var b = o.b;
			
			var xml = <HSK></HSK>;
			
			for(var key in o){
				xml.@[key] = o[key];
			}
			
//			var xml:XML = <xml a={o.c}  b = {o.d}></xml>;
			return xml.toXMLString().replace(/\/>$/, '></' + 'HSK' + '>');
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
