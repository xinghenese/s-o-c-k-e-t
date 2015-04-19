package net.gimite.hellman
{
	import net.gimite.logger.Logger;
	import net.gimite.util.ByteArrayUtil;
	import com.hurlant.crypto.prng.ARC4;
	import flash.utils.ByteArray;
	/**
	 * @author Reco
	 */
	public class RC4Encrypt
	{
		private static var _instance:RC4Encrypt = null;
		private static var _ready:Boolean = false;
		private static var _enable:Boolean = true;
		
		public static const KEY_LENGTH:uint = 32;
		
		private var _rc4:ARC4 = null;
		private var _hellman:Hellman = null;
		private var _key:ByteArray = null;
		
		public function RC4Encrypt(enforcer:SingletonEnforcer)
		{
//			if(_hellman == null){
//				_hellman = new Hellman();
//			}
		}
		
		public static function get instance():RC4Encrypt
		{
			if(_instance == null){
				_instance = new RC4Encrypt(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public static function get ready():Boolean
		{
			return _enable && _ready;
		}
		
		public static function get enable():Boolean
		{
			return _enable;
		}
		
		public static function set enable(enable:Boolean):void
		{
			_enable = enable;
		}
		
		public function generateKeyPair():Hellman
		{
			return new Hellman();
		}
		
		public function set encryptkey(key:String):void
		{
			Logger.info('key', key);
			_key = ByteArrayUtil.createByteArray(true, key);
			_rc4 = new ARC4(_key);
			_ready = true;
		}
		
		public function RC4(bytes:ByteArray):ByteArray
		{
			if(_ready){
				_rc4.encrypt(bytes);
			}			
			return bytes;
		}
	}
}

class SingletonEnforcer
{
	
}

