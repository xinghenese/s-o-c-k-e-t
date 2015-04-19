package net.gimite.packet
{
	import net.gimite.connection.Connection;
	import net.gimite.hellman.RC4Encrypt;
	import flash.utils.ByteArray;
	import net.gimite.hellman.Hellman;
	import net.gimite.util.ByteArrayUtil;
	import com.hurlant.util.Base64;
	import net.gimite.logger.Logger;
	/**
	 * @author Reco
	 */
	public class HandShakeProtocolPacket extends ProtocolPacket
	{
		private var _hellman:Hellman = null;
		
		public function HandShakeProtocolPacket()
		{
			super(hellman.getPublicKey());
		}
		
		override public function process():void
		{
			generateEncryptKey();
			sendInitPacket();
		}
		
		private function getLocalKey():String
		{
			var lkey:String = hellman.getPublicKey();
			Logger.info('localkey', lkey);
			return lkey;
		}
		
		private function get hellman():Hellman
		{
			if(_hellman == null){
				_hellman = new Hellman();
			}
			return _hellman;
		}
		
		private function generateEncryptKey():void
		{
			Logger.log();
			Logger.log('generateEncryptKey');
			Logger.info('parsed', toJSONString());
			Logger.info('parsed', toXMLString());
			var pbk:String = getData('pbk');
			Logger.info('pbk', pbk);
			var pbkBytes:ByteArray = Base64.decodeToByteArray(pbk);
			Logger.info('pbk-decoded', ByteArrayUtil.toArrayString(pbkBytes));
			var key:String = hellman.getRCKey(pbkBytes);
			Logger.info('gen-key', key);
			encryptkey = key;
		}
		
		private function sendInitPacket():void
		{
			Logger.log('sendInitPacket');
			var packet:ProtocolPacket = new AuthenticateProtocolPacket({
				ver: "3.8.15.1",
				zip: "1",
				dev: "1", 
				v: "1.0", 
				token: "csyKLiEOLLTHWeBCWhEYIYP1XHX29zXkNxeGpDiu4AZ8m_u_rvOAs0rahTj1Gp5ME3IRoPORJXm5ISBjin1tOcf6qfjXFg2C60RXywN9xgYrozz1RV5ZODstLkbXeQNOumv1GdiBGQU_F-UZDgaKfSgQkxg16d2vC3L3qnRSEYA", 
				devn: "Sony Xperia Z - 4.2.2 - API 17 - 1080x1920_e4165df6-a6d8-4873-a5ea-d433085fb120", 
				msuid: "30147510"				
			});
			Connection.instance.request(packet);
		}
		
		private function set encryptkey(key:String):void
		{
			RC4Encrypt.instance.encryptkey = key.length > RC4Encrypt.KEY_LENGTH ? key.substring(0, RC4Encrypt.KEY_LENGTH) : key;
		}
	}
}
