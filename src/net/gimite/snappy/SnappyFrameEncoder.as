package net.gimite.snappy
{
	/**
	 * @author Administrator
	 */
	public class SnappyFrameEncoder
	{
		/**
	     * The minimum amount that we'll consider actually attempting to compress.
	     * This value is preamble + the minimum length our Snappy service will
	     * compress (instead of just emitting a literal).
	     */
	    private static const MIN_COMPRESSIBLE_LENGTH:int = 18;
	
	    /**
	     * All streams should start with the "Stream identifier", containing chunk
	     * type 0xff, a length field of 0x6, and 'sNaPpY' in ASCII.
	     */
	    private static const STREAM_START:ByteArray = {byte (0xff), 0x06, 0x00, 0x00, 0x73, 0x4e, 0x61, 0x50, 0x70, 0x59 };
	    private const snappy:Snappy = new Snappy();
	    private var started:Boolean;
	
	    public function encode(bytes:ByteArray):ByteArray throws Exception
	    {
	        var _in:InputByteBuffer:var = new InputByteBuffer(bytes);
	        var _out:OutputByteBuffer:var = new OutputByteBuffer();
	        encode(_in, _out);
	        return __out.getBytes();
	    }
	
	    private function encode(_in:InputByteBuffer, OutputByteBuffer _out):void throws Exception
	    {
	        if (!_in.isReadable())
	        {
	            return;
	        }
	
	        if (!started)
	        {
	            started = true;
	            _out.writeBytes(STREAM_START);
	        }
	
	        var dataLength:int = _in.readableBytes();
	        if (dataLength > MIN_COMPRESSIBLE_LENGTH)
	        {
	            while (true)
	            {
	                var lengthIdx:int:const = _out.getIndex() + 1;
	                if (dataLength < MIN_COMPRESSIBLE_LENGTH)
	                {
	                    var slice:InputByteBuffer = _in.readSlice(dataLength);
	                    writeUnencodedChunk(slice, _out, dataLength);
	                    break;
	                }
	
	                _out.writeInt(0);
	                if (dataLength > Short.MAX_VALUE)
	                {
	                    var slice:InputByteBuffer = _in.readSlice(Short.MAX_VALUE);
	                    calculateAndWriteChecksum(slice, _out);
	                    snappy.encode(slice, _out);
	                    setChunkLength(_out, lengthIdx);
	                    dataLength -= Short.MAX_VALUE;
	                }
	                else
	                {
	                    var slice:InputByteBuffer = _in.readSlice(dataLength);
	                    calculateAndWriteChecksum(slice, _out);
	                    snappy.encode(slice, _out);
	                    setChunkLength(_out, lengthIdx);
	                    break;
	                }
	            }
	        }
	        else
	        {
	            writeUnencodedChunk(_in, _out, dataLength);
	        }
	    }
	
	    /**
	     * Calculates and writes the 4-byte checksum to the output array
	     * 
	     * @param slice
	     *            The data to calculate the checksum for
	     * @param out
	     *            The output array to write the checksum to
	     */
	    private static function calculateAndWriteChecksum(slice:InputByteBuffer, OutputByteBuffer _out):void
	    {
	        _out.writeInt(Bytes.swapInt(Snappy.calculateChecksum(slice)));
	    }
	
	    private static function setChunkLength(_out:OutputByteBuffer, int lengthIdx):void
	    {
	        var chunkLength:int = _out.getIndex() - lengthIdx - 3;
	        if (chunkLength >>> 24 != 0)
	        {
	            throw new SnappyException("compressed data too large: " + chunkLength);
	        }
	        _out.setMedium(lengthIdx, Bytes.swapMedium(chunkLength));
	    }
	
	    /**
	     * Writes the 2-byte chunk length to the output array.
	     * 
	     * @param out
	     *            The array to write to
	     * @param chunkLength
	     *            The length to write
	     */
	    private static function writeChunkLength(_out:OutputByteBuffer, int chunkLength):void
	    {
	        _out.writeMedium(Bytes.swapMedium(chunkLength));
	    }
	
	    private static function writeUnencodedChunk(_in:InputByteBuffer, OutputByteBuffer _out, dataLength:int):void
	    {
	        _out.writeByte(1:(byte));
	        writeChunkLength(_out, dataLength + 4);
	        calculateAndWriteChecksum(_in, _out);
	        _out.writeBytes(_in.array(), _in.getIndex(), dataLength);
	    }
	}
}
