package net.gimite.packet
{
	import net.gimite.crypto.IHash;
	import net.gimite.crypto.RSAHash;
	import net.gimite.logger.Logger;
	/**
	 * @author Reco
	 */
	public class Authentication
	{
		public static const INVALID_SEQUENCE:Number = -1; //long
		
		private static const HASH_KEY:String = 'Ml1A&Yx<D5Q8-5gY/KpxrK@z^;O+n[uIpW\"h:JN;dt4/P=:44cy@`Cfn)z^8=eAt';
	    private var sequence:Number = INVALID_SEQUENCE; //AtomicLong
		
		private static var INSTANCE:Authentication = null;
		private var authHash:IHash = null;
	
	    public function Authentication(enforcer:SingletonEnforcer)
	    {
			authHash = RSAHash.instance;
	    }
	
	    public static function get instance():Authentication
	    {
			if(INSTANCE == null){
				INSTANCE = new Authentication(new SingletonEnforcer());
			}
	        return INSTANCE;
	    }
	
	    public function getSequence():Number //long
	    {
	        return sequence;
	    }
	
	    public function getSequenceKey():String
	    {
	        if (!isAuthenticated())
	        {
				throw new Error("Not authenticated yet!");
	        }			
			return authHash.hashEncode((++ sequence) + '', HASH_KEY);
	    }
	
	    public function invalidateSequence():void
	    {
	        sequence = INVALID_SEQUENCE;
	    }
	
	    public function isValidSequence(value:Number/*long*/):Boolean
	    {
			Logger.info('isValidValue', value);
	        return INVALID_SEQUENCE != value;
	    }
	
	    public function isAuthenticated():Boolean
	    {
	        return sequence != INVALID_SEQUENCE;
	    }
	
	    public function setSequence(value:Number/*long*/):void
	    {
	        sequence = ~~value;
	    }
		
		public function validateSequence(value:*):Boolean
		{
			Logger.info('start to validate', value);
			if(value is Number){
				return isValidSequence(value as Number);
			}
			if(value is String){
				Logger.info('value', value);
				var decoded:String = authHash.hashDecode(value as String, HASH_KEY);
				var seq:Number = ~~parseFloat(decoded);
				Logger.info('decoded', decoded);
				Logger.info('sequence', seq);
				if(isValidSequence(seq)){
					setSequence(seq);
					Logger.info('this.sequence', this.sequence);
					return true;
				}
			}
			return false;
		}
	}
}

class SingletonEnforcer
{
	
}
