package socket;

import java.util.Arrays;

import snappy.SnappyFramedDecoder;
import snappy.SnappyFramedEncoder;

public class SnappySocket 
{
	private SnappyFramedEncoder encoder;
    private SnappyFramedDecoder decoder;
    
    public SnappySocket()
    {
    	encoder = new SnappyFramedEncoder();
        decoder = new SnappyFramedDecoder();
    }
    
    public byte[] decode(byte[] bytes) throws Exception
    {
        return decoder.decode(bytes);
    }

    public byte[] encode(byte[] bytes) throws Exception
    {
        return encoder.encode(bytes);
    }
}
