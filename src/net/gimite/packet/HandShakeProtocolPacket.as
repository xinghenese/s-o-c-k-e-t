package net.gimite.packet
{
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
		protected var _keyvalue:String = 'pbk';
		
		public function HandShakeProtocolPacket(data:* = null)
		{
			super(data);
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
			return new Hellman();
		}
		
		private function generateEncryptKey():void
		{
			Logger.info('parsed', toJSONString());
//			Logger.info('parsed', toXMLString());
			var pbk:String = getData('pbk');
//			Logger.info('pbk', pbk);
			var pbkBytes:ByteArray = Base64.decodeToByteArray(pbk);
//			Logger.info('pbk-decoded', ByteArrayUtil.toArrayString(pbkBytes));
			var key:String = hellman.getRCKey(pbkBytes);
//			Logger.info('gen-key', key);
			encryptkey = key;
		}
		
		private function sendInitPacket()
		{
			var packet:ProtocolPacket = new AuthenticateProtocolPacket();
		}
		
		private function set encryptkey(key:String):void
		{
			RC4Encrypt.instance.encryptkey = key.length > RC4Encrypt.KEY_LENGTH ? key.substring(0, RC4Encrypt.KEY_LENGTH) : key;
		}
	}
}
