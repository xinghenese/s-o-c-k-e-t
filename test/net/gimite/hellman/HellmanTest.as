package net.gimite.hellman
{
	import net.gimite.util.Dec;
	import net.gimite.util.ByteArrayUtil;
	import com.hurlant.util.Base64;
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	import flash.display.Sprite;
	/**
	 * @author Reco
	 */
	public class HellmanTest extends Sprite
	{
		public function HellmanTest()
		{
			var hellman:KeyExchange = new Hellman();
	        Logger.info("pbk", hellman.getPublicKey());
	        
	        var publicKeyFromServer:String = "AMwaGwx/TVCza98BKMVyzlgorNjTrh6iWCRZ0PUIUCZapPp4yKXu2CiHl1D0cDDAPC8bIxtotwXdolCV2tVhkk4hJg7FYAPxVGe8bHED2XPInKMbYO58JArDVcldFXKb7qSi57Ez4eFZ0zEfhJaWvoc9PeVTSgGdNN1zY6DMsYRF";
	        Logger.info('publicKeyString', Base64.decodeToByteArray(publicKeyFromServer));
//			var publicKey:ByteArray = Dec.toArray(Base64.decode(publicKeyFromServer));
			var publicKey:ByteArray = Base64.decodeToByteArray(publicKeyFromServer);
	        Logger.info("pbkFromServer", publicKeyFromServer);
	        Logger.info("base64-decoded-pbkFromServer", ByteArrayUtil.toArrayString(publicKey, true));
	//        Logger.info("base64-decoded-pbkFromServer", new String(publicKey));
	        var RC4Key:String = hellman.getEncryptKey(publicKey);
	        Logger.info("RC4Key", RC4Key);
		}
	}
}
