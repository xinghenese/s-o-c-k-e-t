package net.gimite.snappy
{
	import flash.errors.EOFError;
	import flash.utils.ByteArray;
	/**
	 * @author Administrator
	 */
	public class InputByteBuffer extends ByteArray
	{		
	    private static const EMPTY_BUFFER:InputByteBuffer = new InputByteBuffer(new ByteArray()); //java:new byte[0]. In AS, constructor ByteArray could not take arugments
	    private const buf:ByteArray;
	    private var index:int = 0;
	    private var markerIndex:int = 0;
	
	    public function InputByteBuffer()
	    {
	        super();
	    }
	
		//to Modify
	    public function array():ByteArray
	    {
	        return buf;
	    }
	
	    public function getByte(offset:int):int //byte to int
	    {
	        checkIndex(offset, 1);
	        return buf[offset]; //should return buf[offset] & 0xFF?
	    }
	
	    public function getIndex():int
	    {
	        return this.position;
	    }
	
	    public function getInt(offset:int):int
	    {
	        checkIndex(offset, 4);
	        return (buf[offset] & 0xff) << 24 | (buf[offset + 1] & 0xff) << 16 | (buf[offset + 2] & 0xff) << 8
	                | buf[offset + 3] & 0xff;
	    }
	
	    public function getUnsignedByte(offset:int):int //short to int
	    {
	        return int(getByte(offset) & 0xFF);
	    }
	
	    public function getUnsignedMedium(offset:int):int
	    {
	        return (buf[offset] & 0xff) << 16 | (buf[offset + 1] & 0xff) << 8 | buf[offset + 2] & 0xff;
	    }
	
	    public function isReadable():Boolean
	    {
	        return this.bytesAvailable > 0;
	    }
	
	    public function length():int
	    {
	        return buf.length;
	    }
	
	    public function markIndex():void
	    {
	        markerIndex = index;
	    }
	
	    public function readByte(advance:Boolean = false):int //byte to int
	    {
//	        checkReadableBytes(1);
//	        return buf[index++]; //should return buf[index++] & 0xFF?
			var _data = super.readByte();
			if(advance)
			{
				position --;
			}
			return _data;
	    }
	
	    override public function readBytes(bytes:ByteArray):void//:InputByteBuffer
	    {
//	        checkReadableBytes(bytes.length);
//	        System.arraycopy(buf, index, bytes, 0, bytes.length); //Array.prototype.slice in AS acts as if System.arraycopy in Java
//	        setIndex(index + bytes.length);
//	        return this;
			super.readBytes(bytes, 0, bytes.length);
	    }
	
	    public function readInt():int
	    {
	        checkReadableBytes(4);
	        var result:int = getInt(index);
	        index += 4;
	        return result;
	    }
	
	    public function readShort():int //short to int
	    {
	        checkReadableBytes(2);
	        var result:int =  int(buf[index] << 8 | buf[index + 1] & 0xFF); //short to int
	        index += 2;
	        return result;
	    }
	
	    public function readSlice(length:int):InputByteBuffer
	    {
	        if (length == 0)
	        {
	            return EMPTY_BUFFER;
	        }
	        if (index + length > buf.length)
	        {
	            throw new IndexOutOfBoundsException();
	        }
	
	        var result:InputByteBuffer = new InputByteBuffer(Array.prototype.slice.call(buf, index, index + length)); //Array.prototype.slice in AS acts as if Arrays.copyOfRange in Java
	        index += length;
	        return result;
	    }
	
	    public function readUnsignedByte():int //short to int
	    {
	        return int(readByte() & 0xFF);
	    }
	
	    public function readUnsignedMedium():int
	    {
	        checkReadableBytes(3);
	        var result:int = (buf[index] & 0xff) << 16 | (buf[index + 1] & 0xff) << 8 | buf[index + 2] & 0xff;
	        index += 3;
	        return result;
	    }
	
	    public function readableBytes():int
	    {
	        return buf.length - index;
	    }
	
	    public function resetIndex():void
	    {
	        index = markerIndex;
	    }
	
	    public function setIndex(value:int):void
	    {
	        this.index = value;
	    }
	
	    public function skipBytes(length:int):InputByteBuffer
	    {
	        checkReadableBytes(length);
	        setIndex(index + length);
	        return this;
	    }
	
	    private function checkIndex(offset:int, length:int):void
	    {
	        if (offset + length > buf.length)
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
