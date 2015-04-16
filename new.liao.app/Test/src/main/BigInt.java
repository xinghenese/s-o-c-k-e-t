package main;

import java.math.BigInteger;
import snappy.Hellman;

public class BigInt
{
    public static void main(String[] args)
    {
        final String PRIME = "171718397966129586011229151993178480901904202533705695869569760169920539808075437788747086722975900425740754301098468647941395164593810074170462799608062493021989285837416815548721035874378548121236050948528229416139585571568998066586304075565145536350296006867635076744949977849997684222020336013226588207303";
        BigInteger p = new BigInteger(PRIME);
        Hellman hellman = new Hellman();
        
        info("PRIME", p.toString(16));
        
        info("public", hellman.createPub().toString(16));
    }
    
    private static void info(String type, String msg)
    {
        System.out.print("[" + type + "]\t" + msg + "\n");
    }
}
