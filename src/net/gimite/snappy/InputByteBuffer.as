package net.gimite.snappy
{
	import net.gimite.logger.Logger;
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
	
	    public function InputByteBuffer(bytes:ByteArray = null)
	    {
			if(bytes){
				writeBytes(bytes);
				position = 0;
			}			
	        super();
	    }
		
//		public static function fromByteArray(bytes:ByteArray):InputByteBuffer
//		{
//			var buffer:InputByteBuffer = new InputByteBuffer(), pos:int = bytes.position;
//			bytes.position = 0;
//			bytes.readBytes(buffer);
//			bytes.position = pos;
//			return buffer;
//		}
	
	    public function getByte(offset:int = -1):int //byte to int
	    {
			return getData(offset);
	    }
	
	    public function getInt(offset:int = -1):int
	    {
	        return getData(offset, readInt);
	    }
	
	    public function getUnsignedByte(offset:int = -1):uint //short to int
	    {
			return uint(getByte(offset)) & 0xFF;
	    }
	
	    public function getUnsignedMedium(offset:int = -1):int
	    {
	        return uint(getInt(offset)) & 0xFFFFFF;
	    }
		
		private function getData(offset:int = -1, read:Function = null):int
		{
			var pos:int = position;
			if(offset >= 0)
			{
				position = offset;
			}
			try{
				var result:int = (read || readByte).call(this);
			}
			catch(e:Error){
				Logger.error(e.name, e.message);
			}
			finally{				
				position = pos;	
				return result;
			}
//			for(var i:int = 0, data:int = 0, bit:int = 8; i < size; i++)
//			{
//				data |= (super.readByte() & 0xff) << (bit * (size - 1 - i));
//			}			
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
			var result:InputByteBuffer = new InputByteBuffer();
			readBytes(result, position, length);
//	        var result:InputByteBuffer = Array.prototype.slice.call(this, position, position = position + length); //Array.prototype.slice in AS acts as if Arrays.copyOfRange in Java
//	        return result;
			return result;
	    }
	
	    public function readUnsignedMedium():int
	    {
	        var data:int = getUnsignedMedium();
			position += 3;
	        return data;
	    }
	
	    public function isReadable():Boolean
	    {
	        return this.bytesAvailable > 0;
	    }
	
	    public function markIndex():void
	    {
	        markerIndex = index;
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
