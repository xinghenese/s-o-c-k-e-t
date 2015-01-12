package net.gimite.snappy
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class OutputByteBuffer extends ByteArray
	{
//	    private var buf:ByteArray;
//	    private var index:int;
	
//	    public function OutputByteBuffer()
//	    {
//	        this(DEFAULT_CAPACITY);
//	    }

		public function OutputByteBuffer(length:int = 256):void	//ByteArray can dynamically expand its capacity
		{
			super();
//			this.length = length;
		}
	
//	    public function OutputByteBuffer(capacity:int = DEFAULT_CAPACITY)	//overload with default arguments assignment
//	    {
//	        this.buf = new byte[capacity];
//	    }
//	
//	    public function array():ByteArray
//	    {
//	        return buf;
//	    }
	
	    public function ensureWritable(length:int):void
	    {
//	        if (bytesAvailable < length)
//	        {
//	            return;
//	        }	
//	        var capacity:int = (buf.length + length) | 0xff;
//	        expand(capacity);
			return;
	    }
	
	    public function getBytes():ByteArray
	    {
			return ByteArray(Array.prototype.slice.call(this, 0, position));
//	        var bytes:ByteArray = new byte[index];
//	        System.arraycopy(buf, 0, bytes, 0, index);
//	        return bytes;
	    }
	
	    public function getIndex():int
	    {
	        return position;
	    }
	
	    public function setMedium(offset:int, value:int):void
	    {
	        setData(3, value, offset);
	    }
	
//	    public function writeBytes(bytes:ByteArray):void
//	    {
//	        writeBytes(bytes, 0, bytes.length);
//	    }
	
	    public function writeMedium(value:int):void
	    {
	        setData(3, value);
			position += 3;
	    }
		
		private function setData(size:int, bytes:int, offset:int = position):void
		{
//			checkCapacity(size);
			for(var i:int = size - 1; i >= 0; i--)
			{
				writeByte((bytes >> i) & 0xFF);
			}
			position -= size;
		}
	
//	    private function checkCapacity(expandLength:int):void
//	    {
//	        while (index + expandLength > buf.length)
//	        {
//	            expand();
//	        }
//	    }
//	
////	    private function expand():void
////	    {
////	        expand(buf.length << 1);
////	    }
//	
//	    private function expand(capacity:int = buf.length << 1):void	//overload with default arguments assignment
//	    {
//	        var newBuf:ByteArray = new byte[capacity];
//	        System.arraycopy(buf, 0, newBuf, 0, index);
//	        this.buf = newBuf;
//	    }
	}
}
