package net.gimite.spi
{
	/**
	 * @author Reco
	 */
	public class Authentication
	{
		public static const INVALID_SEQUENCE:int = -1; //long
	    // split to protect us
	    // order: 0 - 2 - 4 - 6 - 1 - 3 -5 - 7
//	    private static const HASH_KEY_CHARS_0:Array = [ 'M', 'l', '1', 'A', '&', 'Y', 'x', '<' ];
		private static const HASH_KEY_CHARS_0:String = 'Ml1A&Yx<';
//	    private static const HASH_KEY_CHARS_1:Array = W', '\"', 'h', ':', 'J', 'N', ';' ];
		private static const HASH_KEY_CHARS_1:String = 'pW\"h:JN;';
//	    private static const HASH_KEY_CHARS_2:Array = [ 'D', '5', 'Q', '8', '-', '5', 'g', 'Y' ];
		private static const HASH_KEY_CHARS_2:String = 'D5Q8-5gY';
//	    private static const HASH_KEY_CHARS_3:Array = [ 'd', 't', '4', '/', 'P', '=', ':', '4' ];
		private static const HASH_KEY_CHARS_3:String = 'dt4/P=:4';
//	    private static const HASH_KEY_CHARS_4:Array = [ '/', 'K', 'p', 'x', 'r', 'K', '@', 'z' ];
		private static const HASH_KEY_CHARS_4:String = '/KpxrK@z';
//	    private static const HASH_KEY_CHARS_5:Array = [ '4', 'c', 'y', '@', '`', 'C', 'f', 'n' ];
		private static const HASH_KEY_CHARS_5:String = '4cy@`Cfn';
//	    private static const HASH_KEY_CHARS_6:Array = [ '^', ';', 'O', '+', 'n', '[', 'u', 'I' ];
		private static const HASH_KEY_CHARS_6:String = '^;O+n[uI';
//	    private static const HASH_KEY_CHARS_7:Array = [ ')', 'z', '^', '8', '=', 'e', 'A', 't' ];
		private static const HASH_KEY_CHARS_7:String = ')z^8=eAt';
	    private static const moduleNumbers:Array = [ 0x8985, 0xb8c7, 0xa531, 0x788c, 0xfab9, 0x3189, 0x8a64,
	            0xcdf1 ];
	
	    // Ml1A&Yx<D5Q8-5gY/KpxrK@z^;O+n[uIpW\"h:JN;dt4/P=:44cy@`Cfn)z^8=eAt
	    public static const HASH_KEY:String = (function():String{
//			var buffer:StringBuffer = new StringBuffer();
//	        assemblyString(buffer, HASH_KEY_CHARS_0);
//	        assemblyString(buffer, HASH_KEY_CHARS_2);
//	        assemblyString(buffer, HASH_KEY_CHARS_4);
//	        assemblyString(buffer, HASH_KEY_CHARS_6);
//	        assemblyString(buffer, HASH_KEY_CHARS_1);
//	        assemblyString(buffer, HASH_KEY_CHARS_3);
//	        assemblyString(buffer, HASH_KEY_CHARS_5);
//	        assemblyString(buffer, HASH_KEY_CHARS_7);
//			return buffer;
			return HASH_KEY_CHARS_0 + HASH_KEY_CHARS_2 + HASH_KEY_CHARS_4 + HASH_KEY_CHARS_6 + 
				HASH_KEY_CHARS_1 + HASH_KEY_CHARS_3 + HASH_KEY_CHARS_5 + HASH_KEY_CHARS_7;
	
	        var modBuf:String = '';
	        for (var num:int in moduleNumbers)
	        {
	            modBuf = modBuf + num.toString(16);
	        }
		})();
		
		
	    private var sequence:int = INVALID_SEQUENCE; //AtomicLong
	    private var publicKey:String = '';
		
		private static var INSTANCE:Authentication = null;
	
	    public static function get():Authentication
	    {
			if(INSTANCE == null){
				INSTANCE = new Authentication(new SingletonEnforcer());
			}
	        return INSTANCE;
	    }
	
	    public function Authentication(enforcer:SingletonEnforcer)
	    {
	    }
	
	    public function getPublicKey():String
	    {
	        return publicKey;
	    }
	
	    public function getSequence():int //long
	    {
	        return sequence;
	    }
	
	    public function getSequenceKey():String
	    {
	        if (!isAuthenticated())
	        {
//	            throw new RuntimeException("Not authenticated yet!");
				throw new Error("Not authenticated yet!");
	        }
	
//	        return RsaCrypto.encrypt(Long.toString(sequence.incrementAndGet()), HASH_KEY);
	    }
	
	    public function invalidateSequence():void
	    {
	        sequence = INVALID_SEQUENCE;
	    }
	
	    public function isValidSequence(value:int/*long*/):Boolean
	    {
	        return INVALID_SEQUENCE != value;
	    }
	
	    public function isAuthenticated():Boolean
	    {
	        return sequence != INVALID_SEQUENCE;
	    }
	
	    public function setSequence(value:int/*long*/):void
	    {
	        sequence = value;
	    }
	}
}

class SingletonEnforcer
{
	
}
