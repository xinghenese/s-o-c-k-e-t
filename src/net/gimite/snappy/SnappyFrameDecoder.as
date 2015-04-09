package net.gimite.snappy
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class SnappyFrameDecoder
	{		
		private static const SNAPPY:ByteArray = (function():ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes("sNaPpY");
			return bytes;
		})();//new ByteArray();// = ['s', 'N', 'a', 'P', 'p', 'Y' ];
		
	    private const snappy:Snappy = new Snappy();
	    private var validateChecksums:Boolean;
	    private var started:Boolean;
	    private var corrupted:Boolean;
	
//	    public function SnappyFramedDecoder()
//	    {
//	        this(false);
//	    }
	
	    public function SnappyFramedDecoder(validateChecksums:Boolean = false):void	//overload with default arguments assignment
	    {
	        this.validateChecksums = validateChecksums;
	    }
	
	    /**
	     * Decodes the snappy encoded bytes.
	     * 
	     * @param bytes
	     *            the encoded bytes.
	     * @return the chunks of decoded bytes, never return null.
	     * @throws Exception
	     *             if error occurred while decoding.
	     */
	    public function decode(bytesIn:ByteArray, bytesOut:Array):ByteArray// throws Exception
	    {
			if(arguments.length == 1)
			{
				return decodeBytes(bytesIn);
			}
			else if(arguments.length == 2)
			{
				decodeByteBuffer(InputByteBuffer(bytesIn), bytesOut);
			}
	    }
		
		protected function decodeBytes(bytes:ByteArray):ByteArray
		{
			var bytesIn:ByteArray = bytes;
			var bytesOut:Array = new Array();
			
			while(bytesIn.bytesAvailable)
			{
				var outSize:int = bytesOut.length;
				var oldInputLength:int = bytesIn.bytesAvailable;
				decodeByteBuffer(InputByteBuffer(bytesIn), bytesOut);
				
				if(outSize == bytesOut.length)
				{
					if(oldInputLength == bytesIn.bytesAvailable)
					{
						break;
					}
					else
					{
						continue;
					}
				}
				
				if(oldInputLength == bytesIn.bytesAvailable)
				{
					throw new SnappyException();
				}
			}
			
			var len:int = 0;
			for (var _each:ByteArray in bytesOut)
	        {
	            len += _each.length;
	        }
	        var buf:OutputByteBuffer = new OutputByteBuffer();
	        for (_each in bytesOut)
	        {
	            buf.writeBytes(_each);
	        }
	        return buf.getBytes();
			
//			var bytesIn:InputByteBuffer = new InputByteBuffer(bytes);
//	        var bytesOut:List<ByteArray> = new ArrayList<ByteArray>();
//			var bytesOut:Array = new Array();	//List<ByteArray> to Array
//	        while (bytesIn.isReadable())
//	        {
//	            var outSize:int = bytesOut.size();
//	            var oldInputLength:int = bytesIn.readableBytes();
//	            decodeByteBuffer(bytesIn, bytesOut);
//	
//	            if (outSize == bytesOut.size())
//	            {
//	                if (oldInputLength == bytesIn.readableBytes())
//	                {
//	                    break;
//	                }
//	                else
//	                {
//	                    continue;
//	                }
//	            }
//	
//	            if (oldInputLength == bytesIn.readableBytes())
//	            {
//	                throw new SnappyException(".decode() did not read anything but decoded a message.");
//	            }
//	        }
//	
//	        // we calculate the total bytes to avoid multiple memory allocation.
//	        var len:int = 0;
//	        for (var _each:ByteArray in bytesOut)
//	        {
//	            len += _each.length;
//	        }
//	        var buf:OutputByteBuffer = new OutputByteBuffer(len);
//	        for (_each in bytesOut)
//	        {
//	            buf.writeBytes(_each);
//	        }
//	        return buf.getBytes();
		}
	
	    protected function decodeByteBuffer(bytesIn:InputByteBuffer, bytesOut:Array):ByteArray	//List<ByteArray> to Array// throws Exception
	    {
	        if (corrupted)
	        {
	            bytesIn.skipBytes(bytesIn.bytesAvailable);
	            return;
	        }
	
	        try
	        {
	            var pos:int = bytesIn.position;
	            const inSize:int = bytesIn.bytesAvailable;
	            if (inSize < 4)
	            {
	                // We need to be at least able to read the chunk type identifier
	                // (one byte),
	                // and the length of the chunk (3 bytes) in order to proceed
	                return;
	            }
	
	            const chunkTypeVal:uint = bytesIn.readUnsignedByte();
	            const chunkType:ChunkType = ChunkType.mapChunkType(chunkTypeVal);
	            const chunkLength:int = Bytes.swapMedium(bytesIn.getUnsignedMedium(pos + 1));
	
	            switch (chunkType)
	            {
	                case ChunkType.STREAM_IDENTIFIER:
	                    if (chunkLength != SNAPPY.length)
	                    {
	                        throw new SnappyException("Unexpected length of stream identifier: " + chunkLength);
	                    }
	
	                    if (inSize < 4 + SNAPPY.length)
	                    {
	                        break;
	                    }
	
	                    var identifier:ByteArray = new ByteArray();//new byte[chunkLength];
	                    bytesIn.skipBytes(4).readBytes(identifier);
	
	                    if (!Arrays.equals(identifier, SNAPPY))
	                    {
	                        throw new SnappyException("Unexpected stream identifier contents. Mismatched snappy "
	                                + "protocol version?");
	                    }
	
	                    started = true;
	                    break;
	                case ChunkType.RESERVED_SKIPPABLE:
	                    if (!started)
	                    {
	                        throw new SnappyException("Received RESERVED_SKIPPABLE tag before STREAM_IDENTIFIER");
	                    }
	
	                    if (inSize < 4 + chunkLength)
	                    {
	                        // TODO: Don't keep skippable bytes
	                        return;
	                    }
	
	                    bytesIn.skipBytes(4 + chunkLength);
	                    break;
	                case ChunkType.RESERVED_UNSKIPPABLE:
	                    // The spec mandates that reserved unskippable chunks must
	                    // immediately
	                    // return an error, as we must assume that we cannot decode
	                    // the stream
	                    // correctly
	                    throw new SnappyException("Found reserved unskippable chunk type: 0x"
	                            + chunkTypeVal.toString(16));
	                case ChunkType.UNCOMPRESSED_DATA:
	                    if (!started)
	                    {
	                        throw new SnappyException("Received UNCOMPRESSED_DATA tag before STREAM_IDENTIFIER");
	                    }
	                    if (chunkLength > 65536 + 4)
	                    {
	                        throw new SnappyException("Received UNCOMPRESSED_DATA larger than 65540 bytes");
	                    }
	
	                    if (inSize < 4 + chunkLength)
	                    {
	                        return;
	                    }
	
	                    bytesIn.skipBytes(4);
	                    if (validateChecksums)
	                    {
	                        var checksum:int = Bytes.swapInt(bytesIn.readInt());
	                        Snappy.validateChecksum(checksum, bytesIn, bytesIn.position, chunkLength - 4);
	                    }
	                    else
	                    {
	                        bytesIn.skipBytes(4);
	                    }
	                    bytesOut.push(bytesIn.readSlice(chunkLength - 4));
	                    break;
	                case ChunkType.COMPRESSED_DATA:
	                    if (!started)
	                    {
	                        throw new SnappyException("Received COMPRESSED_DATA tag before STREAM_IDENTIFIER");
	                    }
	
	                    if (inSize < 4 + chunkLength)
	                    {
	                        return;
	                    }
	
	                    bytesIn.skipBytes(4);
	                    checksum = Bytes.swapInt(bytesIn.readInt());
	                    var uncompressed:OutputByteBuffer = new OutputByteBuffer();
	                    snappy.decode(bytesIn.readSlice(chunkLength - 4), uncompressed);
	                    if (validateChecksums)
	                    {
	                        var inUncompressed:InputByteBuffer = InputByteBuffer(uncompressed);
	                        Snappy.validateChecksum(checksum, inUncompressed, 0, uncompressed.position);
	                    }
	                    bytesOut.push(uncompressed.getBytes());
	                    snappy.reset();
	                    break;
	            }
	        }
	        catch (e)
	        {
	            corrupted = true;
	            throw e;
	        }
	    }
	
	    
	
	    
	}
}
