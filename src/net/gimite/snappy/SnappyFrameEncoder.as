package net.gimite.snappy
{
	import flash.utils.ByteArray;
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
	    private const snappy:Snappy = new Snappy();
	    private var started:Boolean;	
	    /**
	     * All streams should start with the "Stream identifier", containing chunk
	     * type 0xff, a length field of 0x6, and 'sNaPpY' in ASCII.
	     */
//	    private static const STREAM_START:ByteArray = (function():ByteArray	//initialization of static const ByteArray Object
//		{
//			var bytes:ByteArray = new ByteArray();
//			bytes.writeByte(0xff);
//			bytes.writeByte(0x06);
//			bytes.writeByte(0x00);
//			bytes.writeByte(0x00);
//			for(var i:int = 0, str:String = "sNaPpY", len:int = str.length; i < len; i++)
//			{
//				bytes.writeByte(int(str.charCodeAt(i)) & 0xFF);
//			}
//			return bytes;
//		})();// = {byte (0xff), 0x06, 0x00, 0x00, 0x73, 0x4e, 0x61, 0x50, 0x70, 0x59 };

		private static const STREAM_START:ByteArray = new ByteArray();
		
		STREAM_START.writeByte(0xff);
		STREAM_START.writeByte(0x06);
		STREAM_START.writeByte(0x00);
		STREAM_START.writeByte(0x00);
		for(var i:int = 0, str:String = "sNaPpY", len:int = str.length; i < len; i++)
		{
			STREAM_START.writeByte(int(str.charCodeAt(i)) & 0xFF);
		}

		public function SnappyFrameEncoder()
		{
//			STREAM_START
		}
	
	    public function encode(bytes:ByteArray):ByteArray// throws Exception
	    {
	        var _in:InputByteBuffer = InputByteBuffer(bytes);
	        var _out:OutputByteBuffer = new OutputByteBuffer();
	        encodeBytesBuffer(_in, _out);
	        return _out.getBytes();
	    }
	
	    private function encodeBytesBuffer(_in:InputByteBuffer, _out:OutputByteBuffer):void //throw Exception
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
	                const lengthIdx:int = _out.getIndex() + 1;
	                if (dataLength < MIN_COMPRESSIBLE_LENGTH)
	                {
	                    var slice:InputByteBuffer = _in.readSlice(dataLength);
	                    writeUnencodedChunk(slice, _out, dataLength);
	                    break;
	                }
	
	                _out.writeInt(0);
	                if (dataLength > Short.MAX_VALUE)
	                {
	                    slice:InputByteBuffer = _in.readSlice(Short.MAX_VALUE);
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
	    private static function calculateAndWriteChecksum(slice:InputByteBuffer, _out:OutputByteBuffer):void
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
	    private static function writeChunkLength(_out:OutputByteBuffer, chunkLength:int):void
	    {
	        _out.writeMedium(Bytes.swapMedium(chunkLength));
	    }
	
	    private static function writeUnencodedChunk(_in:InputByteBuffer, _out:OutputByteBuffer, dataLength:int):void
	    {
	        _out.writeByte(1:(byte));
	        writeChunkLength(_out, dataLength + 4);
	        calculateAndWriteChecksum(_in, _out);
	        _out.writeBytes(_in.array(), _in.getIndex(), dataLength);
	    }
	}
}
