package net.gimite.snappy
{
	import net.gimite.util.ByteArrayUtil;
	import net.gimite.logger.Logger;
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
	    private var started:Boolean = false;
	    private var corrupted:Boolean;
	
	    public function SnappyFramedDecoder(validateChecksums:Boolean = false):void
	    {
	        this.validateChecksums = validateChecksums;
	    }
		
		public function decode(bytes:ByteArray):ByteArray
		{
			var bytesIn:InputByteBuffer = new InputByteBuffer(bytes);
			var bytesOut:Vector.<ByteArray> = new Vector.<ByteArray>();
//			Logger.log('pass?inner');
			
//			Logger.log(bytesIn);
			
			while(bytesIn.bytesAvailable)
			{
				var outSize:int = bytesOut.length;
				var oldInputLength:int = bytesIn.bytesAvailable;
//				Logger.info('oldInputLength', oldInputLength);
//				Logger.info('started', started);
				
				try{
					decodeByteBuffer(bytesIn, bytesOut);
				}
				catch(e:Error){
//					Logger.log('error in decodeByteBuffer');
//					Logger.error(e.name, e.message);	
//					Logger.log(e.getStackTrace());
				}
				
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
					throw new SnappyException(".decode() did not read anything but decoded a message.");
				}
			}
			
	        var buf:OutputByteBuffer = new OutputByteBuffer();
			bytesOut.forEach(function(item:ByteArray, index:int, vector:Vector.<ByteArray>):void{
				buf.writeBytes(item);
			});
	        return buf.getBytes();
		}
	
	    protected function decodeByteBuffer(bytesIn:InputByteBuffer, bytesOut:Vector.<ByteArray>):void	//List<ByteArray> to Array// throws Exception
	    {
			if (corrupted)
	        {
	            bytesIn.skipBytes(bytesIn.bytesAvailable);
	            return;
	        }
	
	        try
	        {
	            var pos:int = bytesIn.position;
//				Logger.log('pos: ' + pos);
	            const inSize:int = bytesIn.bytesAvailable;
//				Logger.log('inSize: ' + inSize);
	            if (inSize < 4)
	            {
	                // We need to be at least able to read the chunk type identifier
	                // (one byte),
	                // and the length of the chunk (3 bytes) in order to proceed
	                return;
	            }
				
//				Logger.info('bytesIn', ByteArrayUtil.toArrayString(bytesIn));
	
				//一条报文根据内容的功能类型分割成若干个数据块chunk。每个chunk的第一个字节表示chunk的类型，接着后三个字节表示chunk的长度(需作swapMedium处理),
				//这样可以根据不同chunk类型作不同处理，并且根据后三个字节所表示的chunk长度来分配一定大小的ouputbuffer，然后将一边处理chunk内容，
				//一边将处理后的内容写到ouputbuffer中
	            const chunkTypeVal:uint = bytesIn.getUnsignedByte();
	            const chunkType:int = ChunkType.mapChunkType(chunkTypeVal);
	            const chunkLength:int = Bytes.swapMedium(bytesIn.getUnsignedMedium(pos + 1));
				
//				Logger.info('bytesIn.getUnsignedMedium', bytesIn.getUnsignedMedium(pos + 1));
//				
//				Logger.info('chunkTypeVal', chunkTypeVal);
//				Logger.info('chunkType', chunkType);
//				Logger.info('chunkLength', chunkLength);
//				Logger.info('started', started);
	
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
//	                    Logger.info('pos', bytesIn.position);
	                    bytesIn.skipBytes(4).readBytes(identifier, 0, chunkLength);
						
//						Logger.info('identifier', ByteArrayUtil.toArrayString(identifier));
	
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
//						Logger.log('COMPRESSED_DATA');
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
						
//						Logger.info('checksum', checksum);
//						Logger.info('validateChecksums', validateChecksums);
//						Logger.info('pos', bytesIn.position);
//						Logger.info('chunk', ByteArrayUtil.toByteString(bytesIn.getInt()));
						
	                    var uncompressed:OutputByteBuffer = new OutputByteBuffer();
						
						try{
//							Logger.info('bytesIn', ByteArrayUtil.toArrayString(bytesIn));
							var tmp:InputByteBuffer = bytesIn.readSlice(chunkLength - 4);
//							Logger.info('readSlice', ByteArrayUtil.toArrayString(tmp));
							snappy.decode(tmp, uncompressed);
						}
	                    catch(e:Error){
//							Logger.log('error in snappy.decode');
							Logger.error(e.name, e.message);
						}
	                    if (validateChecksums)
	                    {
	                        var inUncompressed:InputByteBuffer = uncompressed as InputByteBuffer;
	                        Snappy.validateChecksum(checksum, inUncompressed, 0, uncompressed.position);
	                    }
						
//						Logger.info('uncompressed', uncompressed);
//						Logger.info('uncompressed', ByteArrayUtil.toArrayString(uncompressed));
						
	                    bytesOut.push(uncompressed.getBytes());
	                    snappy.reset();
	                    break;
	            }
	        }
	        catch (e:Error)
	        {
//				Logger.log('corrupted...');
	            corrupted = true;
	            throw e;
	        }
	    }
	    
	}
}
