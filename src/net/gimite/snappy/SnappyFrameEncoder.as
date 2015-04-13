package net.gimite.snappy
{
	import net.gimite.logger.Logger;
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
	    private static const STREAM_START:ByteArray = (function():ByteArray	//initialization of static const ByteArray Object
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(0xff);
			bytes.writeByte(0x06);
			bytes.writeByte(0x00);
			bytes.writeByte(0x00);
			for(var i:int = 0, str:String = "sNaPpY", len:int = str.length; i < len; i++)
			{
				bytes.writeByte(int(str.charCodeAt(i)) & 0xFF);
			}
			return bytes;
		})();// = {byte (0xff), 0x06, 0x00, 0x00, 0x73, 0x4e, 0x61, 0x50, 0x70, 0x59 };

		public function SnappyFrameEncoder()
		{
		}
	
	    public function encode(bytes:ByteArray):ByteArray// throws Exception
	    {
			var bytesIn:InputByteBuffer = new InputByteBuffer(bytes);
	        var bytesOut:OutputByteBuffer = new OutputByteBuffer();
	        encodeBytesBuffer(bytesIn, bytesOut);
	        return bytesOut.getBytes();
	    }
	
	    private function encodeBytesBuffer(bytesIn:InputByteBuffer, bytesOut:OutputByteBuffer):void //throw Exception
	    {
	        if (!bytesIn.isReadable())
	        {
	            return;
	        }
	
	        if (!started)
	        {
	            started = true;
	            bytesOut.writeBytes(STREAM_START);
				Logger.info("STREAM_START", STREAM_START);
				Logger.info("STREAM_START", Bytes.toArrayString(STREAM_START));
	        }
	
	        var dataLength:int = bytesIn.bytesAvailable;
	        if (dataLength > MIN_COMPRESSIBLE_LENGTH)
	        {
	            while (true)
	            {
	                const lengthIdx:int = bytesOut.position + 1;
	                if (dataLength < MIN_COMPRESSIBLE_LENGTH)
	                {
	                    var slice:InputByteBuffer = bytesIn.readSlice(dataLength);
	                    writeUnencodedChunk(slice, bytesOut, dataLength);
	                    break;
	                }
	
	                bytesOut.writeInt(0);
	                if (dataLength > Bytes.SHORT_MAX_VALUE)
	                {
	                    slice = bytesIn.readSlice(Bytes.SHORT_MAX_VALUE);
	                    calculateAndWriteChecksum(slice, bytesOut);				
						
						var bytes:ByteArray = bytesOut.getBytes();
	                    snappy.encode(slice, bytesOut);
	                    setChunkLength(bytesOut, lengthIdx);
						
	                    dataLength -= Bytes.SHORT_MAX_VALUE;
	                }
	                else
	                {
	                    slice = bytesIn.readSlice(dataLength);
	                    calculateAndWriteChecksum(slice, bytesOut);
						
						var bytes:ByteArray = bytesOut.getBytes();
	                    snappy.encode(slice, bytesOut);				
				
	                    setChunkLength(bytesOut, lengthIdx);
				
	                    break;
	                }
	            }
	        }
	        else
	        {
	            writeUnencodedChunk(bytesIn, bytesOut, dataLength);
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
	    private static function calculateAndWriteChecksum(slice:InputByteBuffer, bytesOut:OutputByteBuffer):void
	    {
	        bytesOut.writeInt(Bytes.swapInt(Snappy.calculateChecksum(slice)));
	    }
	
	    private static function setChunkLength(bytesOut:OutputByteBuffer, lengthIdx:int):void
	    {
	        var chunkLength:int = bytesOut.position - lengthIdx - 3;
			Logger.log('chunkLength: ' + chunkLength);
	        if (chunkLength >>> 24 != 0)
	        {
	            throw new SnappyException("compressed data too large: " + chunkLength);
	        }
	        bytesOut.setMedium(lengthIdx - 1, Bytes.swapMedium(chunkLength));
	    }
	
	    /**
	     * Writes the 2-byte chunk length to the output array.
	     * 
	     * @param out
	     *            The array to write to
	     * @param chunkLength
	     *            The length to write
	     */
	    private static function writeChunkLength(bytesOut:OutputByteBuffer, chunkLength:int):void
	    {
	        bytesOut.writeMedium(Bytes.swapMedium(chunkLength));
	    }
	
	    private static function writeUnencodedChunk(bytesIn:InputByteBuffer, bytesOut:OutputByteBuffer, dataLength:int):void
	    {
	        bytesOut.writeByte(1);
	        writeChunkLength(bytesOut, dataLength + 4);
	        calculateAndWriteChecksum(bytesIn, bytesOut);
	        bytesOut.writeBytes(bytesIn, bytesIn.position, dataLength);
	    }
	}
}
