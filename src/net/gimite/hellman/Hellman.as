package net.gimite.hellman
{
	import net.gimite.util.Dec;
	import com.hurlant.util.Base64;
	import com.hurlant.crypto.prng.ARC4;
	import net.gimite.logger.Logger;
	import com.adobe.crypto.MD5;
	import mx.utils.Base64Encoder;
	import flash.utils.ByteArray;
	import com.hurlant.math.BigInteger;
	/**
	 * @author Administrator
	 */
	public class Hellman
	{
		private var p:BigInteger; // public key
    	private var g:BigInteger; // public base

//	    private static const PRIME:String = "171718397966129586011229151993178480901904202533705695869569760169920539808075437788747086722975900425740754301098468647941395164593810074170462799608062493021989285837416815548721035874378548121236050948528229416139585571568998066586304075565145536350296006867635076744949977849997684222020336013226588207303";
	    private static const PRIME:String = "f488fd584e49dbcd20b49de49107366b336c380d451d0f7c88b31c7c5b2d8ef6f3c923c043f0a55b188d8ebb558cb85d38d334fd7c175743a31d186cde33212cb52aff3ce1b1294018118d7c84a70a72d686c40319c807297aca950cd9969fabd00a509b0246d3083d66a45d419f9c7cbd894b221926baaba25ec355e92f78c7";
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
	        this.p = new BigInteger(PRIME, 16, true);
	        this.g = new BigInteger(BASE, 16, true);
//	        for (var i:int = 0; i < 12; i++)
//	        {
//				//randomVal:long
//	            var randomVal:int = (int) (Math.random() * 1000000000);
//				//problem
//	            this.privateKey += randomVal.toString(16);
//	        }
			privateKey = '1aad644d251a39f022152430a132660125874e52e2eb04410545d80190fb92b2366e4c72af96934321a8ef12604d4e0';
	        this.priv = new BigInteger(privateKey, 16, true);
			Logger.info('PRIME', this.p.toString(10));
			Logger.info('PRIME', this.p.toString(16));
			Logger.info('priv', this.priv.toString(10));
			Logger.info('priv', this.priv.toString(16));
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
			return Base64.encodeByteArray(createPub().toByteArray());
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
	
	    public function  getRCKey(publicKey:*):String
	    {
			if(publicKey is String){
				publicKey = Dec.toArray(Base64.decode(publicKey));
			}
			if(publicKey is ByteArray){
				try
		        {
		            var bigIntegerWrap:BigInteger = new BigInteger(publicKey, 0, true);
					Logger.info('bigIntegerWrap', bigIntegerWrap.toString(16));
		            var bitIntSecretKey:BigInteger = getShared(bigIntegerWrap);
					Logger.info('bigIntSecretKey', bitIntSecretKey);
					Logger.info('base64-encoded-privateKey', Base64.encodeByteArray(bitIntSecretKey.toByteArray()));
		            return MD5.hash(Base64.encodeByteArray(bitIntSecretKey.toByteArray()));
		        }
		        catch (e:Error)
		        {
		            Logger.error(e);
		        }
			}
	        return null;
	    }
	}
}
