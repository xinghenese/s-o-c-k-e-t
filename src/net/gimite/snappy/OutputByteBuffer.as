package net.gimite.snappy
{
	import com.hurlant.util.der.ByteString;
	import net.gimite.logger.Logger;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class OutputByteBuffer extends ByteArray
	{
		public function OutputByteBuffer():void	//ByteArray can dynamically expand its capacity
		{
			super();
		}
		
		public static function fromByteArray(bytes:ByteArray):OutputByteBuffer
		{
			var buffer:OutputByteBuffer = new OutputByteBuffer(), pos:int = bytes.position;
			bytes.position = 0;
			bytes.readBytes(buffer);
			bytes.position = pos;
			return buffer;
		}
	
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
			var bytes:ByteArray = new ByteArray(), length:int = position;
			position = 0;
			readBytes(bytes, 0, length);
			position = length;
			return bytes;
//			return ByteArray(Array.prototype.slice.call(this, 0, position));
//	        var bytes:ByteArray = new byte[index];
//	        System.arraycopy(buf, 0, bytes, 0, index);
//	        return bytes;
	    }
		
		public function setByte(offset:int, value:int):void{
			
		}
	
	    public function setMedium(offset:int, value:int):void
	    {
	        setData(3, value, offset);
	    }
	
	    public function writeMedium(value:int):void
	    {
	        setData(3, value);
			position += 3;
	    }
		
		private function setData(size:int, bytes:int, offset:int = -1):void
		{
			var pos:int = position;
			if(offset >= 0)
			{
				position = offset;
			}
//			checkCapacity(size);
			
			Logger.log('bytes: ' + bytes);
			var a:ByteArray = new ByteArray();
			
			for(var i:int = size - 1; i >= 0; i--)
			{
				writeByte((bytes >> (8*i)) & 0xFF);
				a.writeByte((bytes >> (8*i)) & 0xFF);
			}
			
			Logger.log('bytes: ' + Bytes.toArrayString(a));
			
			position = pos;
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
