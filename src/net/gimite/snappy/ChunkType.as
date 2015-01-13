package net.gimite.snappy
{
	/**
	 * @author Administrator
	 */
	internal class ChunkType
	{
		private var value:int;
		
		public static const STREAM_IDENTIFIER:ChunkType = new ChunkType(0);
		public static const COMPRESSED_DATA:ChunkType = new ChunkType(1);
		public static const UNCOMPRESSED_DATA:ChunkType = new ChunkType(2);
		public static const RESERVED_UNSKIPPABLE:ChunkType = new ChunkType(3);
		public static const RESERVED_SKIPPABLE:ChunkType = new ChunkType(4);
		
		public function ChunkType(value:int)
		{
			this.value = value;
		}
		
		/**
	     * Decodes the chunk type from the type tag byte.
	     * 
	     * @param type
	     *            The tag byte extracted from the stream
	     * @return The appropriate {@link ChunkType}, defaulting to
	     *         {@link ChunkType#RESERVED_UNSKIPPABLE}
	     */
	    public static function mapChunkType(type:int):ChunkType //byte to int ChunkType to int
	    {
			type = Bytes.toByte(type);
	        if (type == 0)
	        {
	            return ChunkType.COMPRESSED_DATA;
	        }
	        else if (type == 1)
	        {
	            return ChunkType.UNCOMPRESSED_DATA;
	        }
	        else if (type == 0xff)
	        {
	            return ChunkType.STREAM_IDENTIFIER;
	        }
	        else if ((type & 0x80) == 0x80)
	        {
	            return ChunkType.RESERVED_SKIPPABLE;
	        }
	        else
	        {
	            return ChunkType.RESERVED_UNSKIPPABLE;
	        }
	    }
	}
}
