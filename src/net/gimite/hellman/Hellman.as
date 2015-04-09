package net.gimite.hellman
{
	import flash.utils.ByteArray;
	import com.hurlant.math.BigInteger;
	/**
	 * @author Administrator
	 */
	public class Hellman
	{
		private var p:BigInteger; // public key
    	private var g:BigInteger; // public base

	    private static const PRIME:String = "171718397966129586011229151993178480901904202533705695869569760169920539808075437788747086722975900425740754301098468647941395164593810074170462799608062493021989285837416815548721035874378548121236050948528229416139585571568998066586304075565145536350296006867635076744949977849997684222020336013226588207303";
	    private static const BASE:String = "2";
	    private var privateKey:String = "";
	
	    private var priv:BigInteger;

	    /**
	     * Initalize public key and base
	     * 
	     * @param p
	     * @param g
	     */
	    public function Hellman()
	    {
	        this.p = new BigInteger(PRIME);
	        this.g = new BigInteger(BASE);
	        for (var i:int = 0; i < 12; i++)
	        {
				//randomVal:long
	            var randomVal:int = (int) (Math.random() * 1000000000);
				//problem
//	            this.privateKey += String.valueOf(randomVal);
	        }
	        this.priv = new BigInteger(privateKey);
	    }
	
	    /**
	     * Creates a public exponent Using your private key
	     * 
	     * @param priv
	     * @return
	     */
	    public function  createPub():BigInteger
	    {
	        priv.toString();
	        return this.g.modPow(priv, this.p);
	    }
	
	    public function  getPublicKey():String
	    {
			//problem
			return '';
//	        return RC4Encrypt.get().base64Encode(createPub().toByteArray());
	    }
	
	    /**
	     * Returns the shared key
	     * 
	     * @param pub
	     * @param priv
	     * @return
	     */
	    public function  getShared(pub:BigInteger):BigInteger
	    {
	        return pub.modPow(priv, this.p);
	    }
	
	    public function  getRCKey(publicKey:ByteArray):String
	    {
	        try
	        {
				//problem
//	            var bigIntegerWrap:BigInteger = new BigInteger(1, publicKey);
//	            var bitIntSecretKey:BigInteger = getShared(bigIntegerWrap);
//	            var result:ByteArray = Base64Util.base64Encrypt(bitIntSecretKey.toByteArray());
//	            var secret: String = new String(result);
//	            return MD5Util.md5Encrypt(secret);
	        }
//	        catch (e:Exception)
	        {
	            //Logger.logThrowable(e);
	        }
	
	        return null;
	    }
	}
}
