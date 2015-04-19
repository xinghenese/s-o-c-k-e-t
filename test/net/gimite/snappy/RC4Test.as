package net.gimite.snappy
{
	import net.gimite.logger.Logger;
	import net.gimite.util.ByteArrayUtil;
	import flash.utils.ByteArray;
	import flash.display.Sprite;
	/**
	 * @author Administrator
	 */
	public class RC4Test extends Sprite
	{
		private var rc4:ARC4;
		
		public function RC4Test()
		{
//			var value:String = ']Y×#MFÐôO<Auth devn="Sony Xperia Z - 4.2.2 - API 17 - 1080x1920_e4165df6-a6d8-4873-a5ea-d433085fb120" token="csyKLiEOLLTHWeBCWhEYIYP1XHX29zXkNxeGpDiu4AZ8m_u_rvOAs0rahTj1Gp5ME3IRoPORJXm5ISBjin1tOcf6qfjXFg2C60RXywN9xgYrozz1RV5ZODstLkbXeQNOumv1GdiBGQU_F-UZDgaKfSgQkxg16d2vC3L3qnRSEYA" ver="3.8.15.1" msuid="30147510" v="1.0" dev="1" zip="1"></Auth>';
			var value:String = 'aaa';
			var valueBytes:ByteArray = ByteArrayUtil.createByteArray(true, value);
//			var key:String = '46ec1ecfad0b4aa28f3a3e7fa1ea82b5';
			var key:String = 'd';
			var keyBytes:ByteArray = ByteArrayUtil.createByteArray(true, key);
			
			var key2:Array = [0x46,0xec,0x1e,0xcf,0xad,0x0b,0x4a,0xa2,0x8f,0x3a,0x3e,0x7f,0xa1,0xea,0x82,0xb5];
			var key2Bytes:ByteArray = ByteArrayUtil.createByteArray(key2);
			
			try{
				rc4 = new ARC4();
				rc4.init(keyBytes);
				Logger.info('keyBytes.length', keyBytes.length);
			}
			catch(e:Error){
				Logger.error(e);
			}
			
			Logger.log();
			Logger.info('original', value);
			Logger.info('original', ByteArrayUtil.toArrayString(valueBytes));
			
			Logger.log();
			var encrypted:ByteArray = encrypt(valueBytes);
			Logger.info('after-encrypt', encrypted);
			Logger.info('after-encrypt', ByteArrayUtil.toArrayString(encrypted));
			
			Logger.log();
			var decrypted:ByteArray = encrypt(valueBytes);
			Logger.info('after-decrypt', decrypted);
			Logger.info('after-decrypt', ByteArrayUtil.toArrayString(decrypted));
			
		}
		
		private function encrypt(bytes:ByteArray):ByteArray
		{
			rc4.encrypt(bytes);
			return bytes;
		}
		
	}
}
