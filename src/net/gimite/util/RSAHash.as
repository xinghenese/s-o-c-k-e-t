package net.gimite.util
{
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class RSAHash extends CodeHashAdapter
	{
		private static var INSTANCE:RSAHash = null;
		
		public function RSAHash(enforcer:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():RSAHash
		{
			if(INSTANCE == null){
				INSTANCE = new RSAHash(new SingletonEnforcer());
			}
			return INSTANCE;
		}
		
		private static const CIPHER_DELIMETER:String = 'l'; // l letter
		
		override public function hashEncode(rawText:String, hashKey:String = null):String
		{
			var hashText:String = '',
				pwdLength:int = hashKey.length,
				strLength:int = rawText.length;
			
			for(var i:int = 0, j:int = 0; i < strLength; i ++){
				if(i > 0){
					hashText += CIPHER_DELIMETER;
				}
				hashText += rawText.charCodeAt(i) ^ hashKey.charCodeAt(j);
				j = j % pwdLength + 1;
			}
			
			return hashText;
		}
		
		override public function hashDecode(hashText:String, hashKey:String = null):String
		{
			var rawText:String = '',
				pwdLength:int = hashKey.length,
				hashTexts:Array = hashText.split(CIPHER_DELIMETER),
				i:int = 0;
				
			for each(var text in hashTexts){
				rawText += String.fromCharCode(parseInt(text) ^ hashKey.charCodeAt(i));
				i = i % pwdLength + 1;
			}
			
			return rawText;
		}
	}
}

class SingletonEnforcer
{
	
}

