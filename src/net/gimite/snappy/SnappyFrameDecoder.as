package net.gimite.snappy
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class SnappyFrameDecoder
	{		
		private static const SNAPPY:ByteArray;// = ['s', 'N', 'a', 'P', 'p', 'Y' ];
	    private const snappy:Snappy = new Snappy();
	    private const validateChecksums:Boolean;
	    private var started:Boolean;
	    private var corrupted:Boolean;
	
//	    public function SnappyFramedDecoder()
//	    {
//	        this(false);
//	    }
	
	    public function SnappyFramedDecoder(validateChecksums:Boolean = false)	//overload with default arguments assignment
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
	    public function decode():ByteArray// throws Exception
	    {
			if(arguments[0] is ByteArray){
				return decodeBytes(arguments[0]);
			}
			else if(arguments[0] is InputByteBuffer && arguments[1] is OutputByteBuffer)
			{
				decodeByteBuffer(arguments[0], arguments[1]);
			}
	    }
		
		protected function decodeBytes(bytes:ByteArray):ByteArray
		{
			var _in:ByteArray = bytes;
			var _out:Array = new Array();
			
			while(_in.bytesAvailable)
			{
				var outSize:int = _out.length;
				var oldInputLength:int = _in.bytesAvailable;
				decodeByteBuffer(_in, _out);
				
				if(outSize == _out.length)
				{
					if(oldInputLength == _in.bytesAvailable)
					{
						break;
					}
					else{
						continue;
					}
				}
				
				if(oldInputLength == _in.bytesAvailable)
				{
					throw new SnappyException();
				}
			}
			
			var len:int = 0;
			for (var _each:ByteArray in _out)
	        {
	            len += _each.length;
	        }
	        var buf:OutputByteBuffer = new OutputByteBuffer(len);
	        for (_each in _out)
	        {
	            buf.writeBytes(_each);
	        }
	        return buf.getBytes();
			
//			var _in:InputByteBuffer = new InputByteBuffer(bytes);
//	        var _out:List<ByteArray> = new ArrayList<ByteArray>();
//			var _out:Array = new Array();	//List<ByteArray> to Array
//	        while (_in.isReadable())
//	        {
//	            var outSize:int = _out.size();
//	            var oldInputLength:int = _in.readableBytes();
//	            decodeByteBuffer(_in, _out);
//	
//	            if (outSize == _out.size())
//	            {
//	                if (oldInputLength == _in.readableBytes())
//	                {
//	                    break;
//	                }
//	                else
//	                {
//	                    continue;
//	                }
//	            }
//	
//	            if (oldInputLength == _in.readableBytes())
//	            {
//	                throw new SnappyException(".decode() did not read anything but decoded a message.");
//	            }
//	        }
//	
//	        // we calculate the total bytes to avoid multiple memory allocation.
//	        var len:int = 0;
//	        for (var _each:ByteArray in _out)
//	        {
//	            len += _each.length;
//	        }
//	        var buf:OutputByteBuffer = new OutputByteBuffer(len);
//	        for (_each in _out)
//	        {
//	            buf.writeBytes(_each);
//	        }
//	        return buf.getBytes();
		}
	
	    protected function decodeByteBuffer(_in:InputByteBuffer, _out:Array):void	//List<ByteArray> to Array// throws Exception
	    {
	        if (corrupted)
	        {
	            _in.skipBytes(_in.readableBytes());
	            return;
	        }
	
	        try
	        {
	            var pos:int = _in.position;
	            const inSize:int = _in.bytesAvailable;
	            if (inSize < 4)
	            {
	                // We need to be at least able to read the chunk type identifier
	                // (one byte),
	                // and the length of the chunk (3 bytes) in order to proceed
	                return;
	            }
	
	            const chunkTypeVal:uint = _in.getUnsignedByte(pos);
	            const chunkType:ChunkType = mapChunkType(byte(chunkTypeVal));
	            const chunkLength:int = Bytes.swapMedium(_in.getUnsignedMedium(pos + 1));
	
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
	
	                    var identifier:ByteArray = new byte[chunkLength];
	                    _in.skipBytes(4).readBytes(identifier);
	
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
	
	                    _in.skipBytes(4 + chunkLength);
	                    break;
	                case ChunkType.RESERVED_UNSKIPPABLE:
	                    // The spec mandates that reserved unskippable chunks must
	                    // immediately
	                    // return an error, as we must assume that we cannot decode
	                    // the stream
	                    // correctly
	                    throw new SnappyException("Found reserved unskippable chunk type: 0x"
	                            + Integer.toHexString(chunkTypeVal));
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
	
	                    _in.skipBytes(4);
	                    if (validateChecksums)
	                    {
	                        var checksum:int = Bytes.swapInt(_in.readInt());
	                        Snappy.validateChecksum(checksum, _in, _in.getIndex(), chunkLength - 4);
	                    }
	                    else
	                    {
	                        _in.skipBytes(4);
	                    }
	                    _out.add(_in.readSlice(chunkLength - 4).array());
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
	
	                    _in.skipBytes(4);
	                    var checksum:int = Bytes.swapInt(_in.readInt());
	                    var uncompressed:OutputByteBuffer = new OutputByteBuffer();
	                    snappy.decode(_in.readSlice(chunkLength - 4), uncompressed);
	                    if (validateChecksums)
	                    {
	                        var inUncompressed:InputByteBuffer = new InputByteBuffer(uncompressed.array());
	                        Snappy.validateChecksum(checksum, inUncompressed, 0, uncompressed.getIndex());
	                    }
	                    _out.add(uncompressed.getBytes());
	                    snappy.reset();
	                    break;
	            }
	        }
	        catch (Exception e)
	        {
	            corrupted = true;
	            throw e;
	        }
	    }
	
	    
	
	    
	}
}
