package net.gimite.snappy
{
	import net.gimite.util.ByteArrayUtil;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import net.gimite.logger.Logger;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Sprite;
	/**
	 * @author Administrator
	 */
	public class SnappyTest extends Sprite
	{		
		private static var snappy:String = (function():String
		{
			var a:String = "abc";
			for(var i:int = 0, str:String = "sNaPpY", len:int = str.length; i < len; i++)
			{
				a = a + ";0x" + (int(str.charCodeAt(i)) & 0xFF);
			}
			return a;
		})();
		
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
		
		private static function toArray(array:ByteArray, offset:int, length:int):void
		{
			array.position = 0;
			Logger.info("bytesAvailable", array.bytesAvailable.toString());
			Logger.info("position", array.position.toString());
			Logger.info("ByteArray", array.toString());
			Logger.log();
			
			var result:ByteArray = new ByteArray(), pos:int = array.position = 4, available:int = array.bytesAvailable;
			array.readBytes(result, offset, length);
			Logger.info("before-position", pos.toString());
			Logger.info("after-position", array.position.toString());
			Logger.info("before-bytesAvailable", available.toString());
			Logger.info("after-bytesAvailable", array.bytesAvailable.toString());
			Logger.info("toArray", result.toString());
			Logger.log();
			
			var entire:ByteArray = new ByteArray();
			pos = array.position = 4;
			available = array.bytesAvailable;
			array.readBytes(entire);
			Logger.info("before-position", pos.toString());
			Logger.info("after-position", array.position.toString());
			Logger.info("before-bytesAvailable", available.toString());
			Logger.info("after-bytesAvailable", array.bytesAvailable.toString());
			Logger.info("toArray", entire.toString());
		}
		
		private var bytesIn:Array = [60, 77, 83, 71, 82, 69, 65, 68, 67, 70, 77, 32, 118, 101, 114, 61, 34, 51, 46, 56, 46, 49, 53, 46, 53, 34, 32, 109, 115, 113, 105, 100, 61, 34, 49, 50, 52, 108, 57, 49, 108, 51, 108, 49, 49, 50, 108, 50, 49, 108, 49, 48, 55, 34, 32, 114, 109, 116, 112, 61, 34, 51, 34, 32, 117, 117, 105, 100, 61, 34, 48, 57, 49, 48, 99, 101, 56, 57, 45, 50, 101, 57, 54, 45, 52, 55, 49, 52, 45, 98, 49, 54, 53, 45, 56, 97, 53, 57, 56, 97, 54, 101, 102, 100, 52, 99, 34, 32, 109, 115, 99, 115, 61, 34, 49, 52, 50, 49, 48, 53, 51, 51, 48, 51, 48, 50, 53, 34, 32, 109, 115, 117, 105, 100, 61, 34, 51, 48, 48, 49, 49, 54, 55, 52, 34, 32, 109, 115, 116, 117, 105, 100, 61, 34, 51, 48, 48, 49, 48, 53, 57, 49, 34, 62, 60, 47, 77, 83, 71, 82, 69, 65, 68, 67, 70, 77, 62];
		
		private var dataBytes:ByteArray = (function():ByteArray
		{
			var _data:String = "<HSK pbk='ALnzSocstfzO0BGKTvkfXQzkznHuouycRKYLoETeMqlqMrI18rV75H7LnxWtejczR9xc3f5my9/DtyKnjI56l48NRqLLOopiE+VkR/vi6ktnPJJZgk8POP338hOTif2RKXjU31qAdbozdIe8+b9NEnhlR6lLdzGL+LU6xGaxSW3/'></HSK>";
			var data2:String = "<MSGREADCFM ver='3.8.15.5' msqid='124l91l3l112l21l107' rmtp='3' uuid='0910ce89-2e96-4714-b165-8a598a6efd4c' mscs='1421053303025' msuid='30011674' mstuid='30010591'></MSGREADCFM>";
			var data:String = '<HSK pbk="XHBxevmo8lAe34xM87jE+3dYxfEOhnjqt/Ca2I4PZk9SorG5v+ns4dbEn2vOoUlfScFBIAht0bylxiiBq27y3Ia08aDEYqe6b/x8uuBGfRmuAc9OT4eLFeJsrmmzDzDtTIoWHPnRv9V045oIKVnRN5girx9muphhL/AVSPQ3lGA="></HSK>';
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
//			Logger.info("dataString", bytes.toString());
//			Logger.info("dataArray", Bytes.toArrayString(bytes));
			return bytes;
		})();
		
		public var result:String = "";
		public var resultBytes:ByteArray;
				
		public static function snappyEncode(bytes:ByteArray):ByteArray
		{
			if(!(bytes is InputByteBuffer))
			{
				bytes = new InputByteBuffer(bytes);
			}
			var _out:OutputByteBuffer = new OutputByteBuffer(), snappy:Snappy = new Snappy(), encoder:SnappyFrameEncoder = new SnappyFrameEncoder();
			var out:ByteArray = encoder.encode(bytes);
//			snappy.encode(InputByteBuffer(bytes), out);
//			Logger.info("ouputString", out.toString());
//			Logger.info("outputArray", Bytes.toArrayString(out));
//			Logger.info("length", out.length);

			Logger.info('LENGTH', out.length);
			Logger.info('LENGTH', ByteArrayUtil.toByteString(out.length));
			
			var header:ByteArray = new ByteArray();
			header.writeInt(out.length);
			header.writeBytes(out);
//			Logger.log();
//			Logger.info("ouputString", header.toString());
//			Logger.info("outputArray", Bytes.toArrayString(header));
//			Logger.info("length", header.length);

			return header;
		}
		
		public static function snappyDecode(bytes:ByteArray):ByteArray
		{
			if(!(bytes is OutputByteBuffer))
			{
				bytes = OutputByteBuffer.fromByteArray(bytes);
			}
			var out:OutputByteBuffer = new OutputByteBuffer(), snappy:Snappy = new Snappy();
			snappy.encode(InputByteBuffer(bytes), out);
			return out;
		}
		
		public function SnappyTest()
		{
//			var loader:Loader = new Loader();
//			loader.load(new URLRequest("SnappyTest.swf"));
//			stage.addChild(loader);
//			this.graphics.clear();
//			this.graphics.beginFill(0x999999);
//			this.graphics.drawCircle(100,100,100);  
			trace("SnappyTest");
//			Logger.info("Test", "Snappy");
//			Logger.info("a", snappy);
//			toArray(STREAM_START, 0, 4);
//			Logger.log();
			
//			var bytes:ByteArray = Bytes.fromArray(bytesIn);
//			Logger.info("bytes", bytes.toString());
//			Logger.info("value", Bytes.toArrayString(bytes));
			
//			var result:ByteArray = snappyEncode(dataBytes);
			
			resultBytes = snappyEncode(dataBytes);
			result = resultBytes.toString();
			
//			Logger.info("bytes", result);
//			Logger.info("value", Bytes.toArrayString(resultBytes));
			
		}		
	}
}
