package net.gimite.packet
{
	import net.gimite.bridge.ActionScriptInterface;
	import net.gimite.profiles.UserProfiles;
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
		private var bridge:ScriptBridge = ScriptBridge.instance;
		
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
			encryptKey = keyExchange.getEncryptKey(pbkBytes);
			bridge.exposeToJS(ActionScriptInterface.ENCRYPT, crypto.encrypt);
			bridge.exposeToJS(ActionScriptInterface.DECRYPT, crypto.decrypt);
		}
		
		private function sendInitPacket():void
		{
			Logger.log('sendInitPacket');
			var packet:ProtocolPacket = ProtocolPacketManager.instance
				.createAuthenticateProtocolPacket(UserProfiles.instance.profile);
			Connection.instance.request(packet);
		}
		
		private function set encryptKey(key:String):void
		{
			key = key.length > crypto.KEY_LENGTH ? key.substring(0, crypto.KEY_LENGTH) : key;
			crypto.encryptKey = ByteArrayUtil.createByteArray(true, key);
		}
	}
}
