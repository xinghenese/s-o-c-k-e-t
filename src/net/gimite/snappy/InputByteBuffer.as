package net.gimite.snappy
{
	import flash.errors.EOFError;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class InputByteBuffer extends ByteArray
	{		
	    private static const EMPTY_BUFFER:InputByteBuffer = new InputByteBuffer(); //java:new byte[0]. In AS, constructor ByteArray could not take arugments
	    private var index:int = 0;
	    private var markerIndex:int = 0;
	
	    public function InputByteBuffer(length:int = 0)
	    {
	        super();
			this.length = length;
	    }
	
	    public function getIndex():int
	    {
	        return this.position;
	    }
	
	    public function getByte(offset:int = position):int //byte to int
	    {
			return getData(1, offset);
	    }
	
	    public function getInt(offset:int = position):int
	    {
	        return getData(4, offset);
	    }
	
	    public function getUnsignedByte(offset:int = position):uint //short to int
	    {
	        return uint(getByte(offset) & 0xFF);
	    }
	
	    public function getUnsignedMedium(offset:int = position):int
	    {
	        return getData(3, offset);
	    }
		
		private function getData(size:int, offset:int = position):int
		{
			checkIndex(offset, size);
			for(var i:int = 0, data:int = 0, bit:int = 8; i < size; i++)
			{
				data |= (super.readByte() & 0xff) << (bit * (size - 1 - i));
			}
			position -= size;
			return data;			
		}
	
	    public function isReadable():Boolean
	    {
	        return this.bytesAvailable > 0;
	    }
	
	    public function length():int
	    {
	        return length;
	    }
	
	    public function markIndex():void
	    {
	        markerIndex = index;
	    }
	
	    public function readSlice(length:int):InputByteBuffer
	    {
	        if (length == 0)
	        {
	            return EMPTY_BUFFER;
	        }
	        if (bytesAvailable < length)
	        {
	            throw new RangeError();
	        }	
//	        var result:InputByteBuffer = Array.prototype.slice.call(this, position, position = position + length); //Array.prototype.slice in AS acts as if Arrays.copyOfRange in Java
//	        return result;
			return InputByteBuffer(Array.prototype.slice.call(this, position, position = position + length));
	    }
	
	    public function readUnsignedMedium():int
	    {
	        var data = getData(3);
			position += 3;
	        return data;
	    }
	
	    public function readableBytes():int
	    {
	        return bytesAvailable;
	    }
	
	    public function resetIndex():void
	    {
	        position = markerIndex;
	    }
	
	    public function setIndex(value:int):void
	    {
	        position = value;
	    }
	
	    public function skipBytes(length:int):InputByteBuffer
	    {
	        checkReadableBytes(length);
	        position += length;
	        return this;
	    }
	
	    private function checkIndex(offset:int, length:int):void
	    {
	        if (offset + length > super.length)
	        {
	            throw new EOFError();
	        }
	    }
	
	    private function checkReadableBytes(length:int):void
	    {
	        checkIndex(position, length);
	    }
	}
}
