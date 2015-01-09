package net.gimite.snappy
{
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class OutputByteBuffer
	{
		private static const DEFAULT_CAPACITY:int = 256;
	    private var buf:ByteArray;
	    private var index:int;
	
//	    public function OutputByteBuffer()
//	    {
//	        this(DEFAULT_CAPACITY);
//	    }
	
	    public function OutputByteBuffer(capacity:int = DEFAULT_CAPACITY)	//overload with default arguments assignment
	    {
	        this.buf = new byte[capacity];
	    }
	
	    public function array():ByteArray
	    {
	        return buf;
	    }
	
	    public function ensureWritable(length:int):void
	    {
	        if (buf.length - index > length)
	        {
	            return;
	        }
	
	        var capacity:int = (buf.length + length) | 0xff;
	        expand(capacity);
	    }
	
	    public function getBytes():ByteArray
	    {
	        var bytes:ByteArray = new byte[index];
	        System.arraycopy(buf, 0, bytes, 0, index);
	        return bytes;
	    }
	
	    public function getIndex():int
	    {
	        return index;
	    }
	
	    public function setMedium(index:int, value:int):void
	    {
	        buf[index] = (byte) (value >>> 16);
	        buf[index + 1] = (byte) (value >>> 8);
	        buf[index + 2] = (byte) value;
	    }
	
	    public function writeByte(b:byte):void
	    {
	        checkCapacity(1);
	        buf[index++] = b;
	    }
	
//	    public function writeBytes(bytes:ByteArray):void
//	    {
//	        writeBytes(bytes, 0, bytes.length);
//	    }
	
	    public function writeBytes(bytes:ByteArray, offset:int = 0, length:int = bytes.length):void	//overload with default arguments assignment
	    {
	        checkCapacity(length);
	        System.arraycopy(bytes, offset, buf, this.index, length);
	        this.index += length;
	    }
	
	    public function writeInt(value:int):void
	    {
	        checkCapacity(4);
	        buf[index++] = (byte) (value >>> 24);
	        buf[index++] = (byte) (value >>> 16);
	        buf[index++] = (byte) (value >>> 8);
	        buf[index++] = (byte) value;
	    }
	
	    public function writeMedium(value:int):void
	    {
	        checkCapacity(3);
	        buf[index++] = (byte) (value >>> 16);
	        buf[index++] = (byte) (value >>> 8);
	        buf[index++] = (byte) value;
	    }
	
	    private function checkCapacity(expandLength:int):void
	    {
	        while (index + expandLength > buf.length)
	        {
	            expand();
	        }
	    }
	
//	    private function expand():void
//	    {
//	        expand(buf.length << 1);
//	    }
	
	    private function expand(capacity:int = buf.length << 1):void	//overload with default arguments assignment
	    {
	        var newBuf:ByteArray = new byte[capacity];
	        System.arraycopy(buf, 0, newBuf, 0, index);
	        this.buf = newBuf;
	    }
	}
}
