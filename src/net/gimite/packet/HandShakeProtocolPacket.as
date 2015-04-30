package net.gimite.packet
{
	import net.gimite.bridge.ScriptBridge;
	import com.hurlant.util.Base64;
	import flash.utils.ByteArray;
	import net.gimite.connection.Connection;
	import net.gimite.crypto.Crypto;
	import net.gimite.crypto.Hellman;
	import net.gimite.crypto.RC4Encrypt;
	import net.gimite.hellman.KeyExchange;
	import net.gimite.logger.Logger;
	import net.gimite.util.ByteArrayUtil;
	/**
	 * @author Reco
	 */
	public class HandShakeProtocolPacket extends ProtocolPacket
	{
		private var keyExchange:KeyExchange;
		private var crypto:Crypto;
		
		public function HandShakeProtocolPacket(data:* = null)
		{
			keyExchange = new Hellman();
			crypto = RC4Encrypt.instance;
			super(keyExchange.getPublicKey());
		}
		
		override public function process():void
		{
			generateEncryptKey();
			sendInitPacket();
		}
		
		private function generateEncryptKey():void
		{
			var pbk:String = getData('pbk');
			var pbkBytes:ByteArray = Base64.decodeToByteArray(pbk);
			var key:String = keyExchange.getEncryptKey(pbkBytes);
			encryptKey = key;
			ScriptBridge.instance.exposeToJS('encrypt', crypto.encrypt);
			ScriptBridge.instance.exposeToJS('decrypt', crypto.decrypt);
		}
		
		private function sendInitPacket():void
		{
			Logger.log('sendInitPacket');
			var packet:ProtocolPacket = ProtocolPacketManager.instance.createAuthenticateProtocolPacket({
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
		
		private function set encryptKey(key:String):void
		{
			key = key.length > crypto.KEY_LENGTH ? key.substring(0, crypto.KEY_LENGTH) : key;
			crypto.encryptKey = ByteArrayUtil.createByteArray(true, key);
		}
	}
}
