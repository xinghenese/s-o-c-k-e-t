package net.gimite.packet
{
	import net.gimite.hellman.KeyExchange;
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
		private var keyExchange:KeyExchange = null;
		
		public function HandShakeProtocolPacket()
		{
			keyExchange = new Hellman();
			super(keyExchange.getPublicKey());
		}
		
		override public function process():void
		{
			generateEncryptKey();
			sendInitPacket();
		}
		
		private function generateEncryptKey():void
		{
//			Logger.log();
//			Logger.log('generateEncryptKey');
//			Logger.info('parsed', toJSONString());
//			Logger.info('parsed', toXMLString());
			var pbk:String = getData('pbk');
//			Logger.info('pbk', pbk);
			var pbkBytes:ByteArray = Base64.decodeToByteArray(pbk);
//			Logger.info('pbk-decoded', ByteArrayUtil.toArrayString(pbkBytes));
			var key:String = keyExchange.getEncryptKey(pbkBytes);
//			Logger.info('gen-key', key);
			encryptkey = key;
		}
		
		private function sendInitPacket():void
		{
			Logger.log('sendInitPacket');
			var packet:ProtocolPacket = new AuthenticateProtocolPacket({
				msuid: "30032005",
				zip: "1",
				v: "1.0",
				ver: "4.1",
				dev: "1",
				token: "DXIBNW4Z_llL-lfbLUv51PS39jrO1ihZ51xxskjsxsenPk4XQpo5Djs55i2utFHC-DNiC7XwVss0OjMe19BF6xTz7SqiaJv3TENs4GFS_kkjFQYojUUps8qbZ4o-Yd6EJUqMWMf6BZcodrqL1EQP__JmCQJFq3DqNjPNS4OdxTs", 
				devn: "Sony Xperia Z - 4.2.2 - API 17 - 1080x1920_b0c56658-4c96-419d-aaba-68cc2ceb750d"
			});
			Connection.instance.request(packet);
		}
		
		private function set encryptkey(key:String):void
		{
			RC4Encrypt.instance.encryptkey = key.length > RC4Encrypt.KEY_LENGTH ? key.substring(0, RC4Encrypt.KEY_LENGTH) : key;
		}
	}
}
