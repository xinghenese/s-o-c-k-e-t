package net.gimite.snappy
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	/**
	 * @author Administrator
	 */
	public class Readable implements IDataInput
	{
		private var readable:ByteArray;
		
		public function Readable(bytes:ByteArray)
		{
//			bytes.writeBytes(readable);
			readable = bytes;
			readable.position = 0;
		}
		
		public function readByte():int
		{
			return readable.readByte();
		}
		
		public function readUnsignedByte():uint
		{
			return readable.readUnsignedByte();
		}
		
		public function readBoolean():Boolean
		{
			return readable.readBoolean();
		}
		
		public function readShort():int
		{
			return readable.readShort();
		}
		
		public function readUnsignedShort():uint
		{
			return readable.readUnsignedShort();
		}
		
		public function readInt():int
		{
			return readable.readInt();
		}
		
		public function readUnsignedInt():uint
		{
			return readable.readUnsignedInt();
		}
		
		public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			readable.readBytes(bytes, offset, length);
		}
		
		public function readFloat():Number
		{
			return readable.readFloat();
		}
		
		public function readDouble():Number
		{
			return readable.readDouble();
		}
		
		public function readMultiByte(length:uint, charSet:String):String
		{
			return readable.readMultiByte(length, charSet);
		}
		
		public function readUTF():String
		{
			return readable.readUTF();
		}
		
		public function readUTFBytes(length:uint):String
		{
			return readable.readUTFBytes(length);
		}
		
		public function readObject():*
		{
			return readable.readObject();
		}
		
		public function toBytes():ByteArray
		{
			return readable;
		}
		
		public function get bytesAvailable():uint
		{
			return readable.bytesAvailable;
		}
		
		public function get endian():String
		{
			return readable.endian;
		}
		
		public function set endian(value:String):void
		{
			readable.endian = value;
		}
		
		public function get objectEncoding():uint
		{
			return readable.objectEncoding;
		}
		
    	public function set objectEncoding(value:uint):void
		{
			readable.objectEncoding = value;
		}
	}
}
