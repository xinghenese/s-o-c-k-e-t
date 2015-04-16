package snappy;

import java.math.BigInteger;

public class Hellman
{
    private BigInteger p; // public key
    private BigInteger g; // public base

    private static final String PRIME = "171718397966129586011229151993178480901904202533705695869569760169920539808075437788747086722975900425740754301098468647941395164593810074170462799608062493021989285837416815548721035874378548121236050948528229416139585571568998066586304075565145536350296006867635076744949977849997684222020336013226588207303";
    private static final String BASE = "2";
    private String privateKey = "";

    private BigInteger priv;

    /**
     * Initalize public key and base
     * 
     * @param p
     * @param g
     */
    public Hellman()
    {
        this.p = new BigInteger(PRIME);
        this.g = new BigInteger(BASE);
        for (int i = 0; i < 12; i++)
        {
            long randomVal = (long) (Math.random() * 1000000000);
            this.privateKey += String.valueOf(randomVal);
        }
        this.priv = new BigInteger(privateKey);
    }

    /**
     * Creates a public exponent Using your private key
     * 
     * @param priv
     * @return
     */
    public BigInteger createPub()
    {
        priv.toString();
        return this.g.modPow(priv, this.p);
    }

    public String getPublicKey()
    {
        return "";
//        return RC4Encrypt.get().base64Encode(createPub().toByteArray());
    }

    /**
     * Returns the shared key
     * 
     * @param pub
     * @param priv
     * @return
     */
    public BigInteger getShared(BigInteger pub)
    {
        return pub.modPow(priv, this.p);
    }

    public String getRCKey(byte[] publicKey)
    {
        return "";
//        try
//        {
//            BigInteger bigIntegerWrap = new BigInteger(1, publicKey);
//            BigInteger bitIntSecretKey = getShared(bigIntegerWrap);
//            byte[] result = Base64Util.base64Encrypt(bitIntSecretKey.toByteArray());
//            String secret = new String(result);
//            return MD5Util.md5Encrypt(secret);
//        }
//        catch (Exception e)
//        {
//            Logger.logThrowable(e);
//        }
//
//        return null;
    }
}
