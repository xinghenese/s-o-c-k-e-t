package net.gimite.crypto
{
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	import net.gimite.util.ByteArrayUtil;
	/**
	 * @author Reco
	 */
	public class RC4Encrypt extends Crypto
	{
		private static var _instance:RC4Encrypt = null;
		private static var _enable:Boolean = true;
		
		private var _rc4:RC4Entity;
		private var _ready:Boolean = false;
		
		public function RC4Encrypt(enforcer:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():RC4Encrypt
		{
			if(_instance == null){
				_instance = new RC4Encrypt(new SingletonEnforcer());
			}
			return _instance;
		}
		
		public static function get enable():Boolean
		{
			return _enable;
		}
		
		public static function set enable(enable:Boolean):void
		{
			_enable = enable;
		}
		
		override public function set encryptKey(key:ByteArray):void
		{
			super.encryptKey = key;
			_rc4 = new RC4Entity(key);
			_ready = true;
		}
		
		override public function get ready():Boolean
		{
			return _ready;
		}
		
		override public function encrypt(rawBytes:ByteArray, key:ByteArray = null):ByteArray
		{
			return RC4(rawBytes);
		}
		
		override public function decrypt(rawBytes:ByteArray, key:ByteArray = null):ByteArray
		{
			return RC4(rawBytes);
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

class SingletonEnforcer{}

