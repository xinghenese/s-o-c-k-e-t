package net.gimite.util
{
	import flash.utils.ByteArray;
	import com.hurlant.math.BigInteger;
	import com.hurlant.crypto.rsa.RSAKey;
	/**
	 * @author Reco
	 */
	public class RSACrypto
	{
		private static var crypto:RSAKey = null;
		private static const modules:String = "132603115957505089088041933457997504366035794275682911484424202540337907536928880329139634433209282079798897115053258700708843640581709743044371656215628334013244231250869125618529784380901416145016586020968468100593316464285613853422830022187634271419224084028708997795847267573021185611331499627338668468453";
	    private static const exponents:String = "65537";
	    private static const blocksize:int = 128;
		
		private static function init():void
		{
			if(crypto == null){
				crypto = RSAKey.parsePublicKey(modules, exponents);
			}
		}
		
		public static function encrypt(value:*, key:*):void
		{
			init();
			if(value is String){
				value = ByteArrayUtil.createByteArray(true, value);
			}
			if(key is String){
				key = ByteArrayUtil.createByteArray(true, key);
			}
			if(value is ByteArray && key is ByteArray){
				
			}
//			return crypto.encrypt(, dst, length)
		}
	}
}
