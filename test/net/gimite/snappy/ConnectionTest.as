package net.gimite.snappy
{
	import net.gimite.packet.Authentication;
	import mx.utils.NameUtil;
	import net.gimite.util.RSAHash;
	import net.gimite.logger.Logger;
	import net.gimite.packet.AuthenticateProtocolPacket;
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.connection.Connection;
	import flash.display.Sprite;
	/**
	 * @author Administrator
	 */
	public class ConnectionTest extends Sprite
	{
		public function ConnectionTest()
		{
			Logger.log('ConnectionTest');
			
//			testRSAHash();
			
			Connection.instance.connect();
//			var packet:ProtocolPacket = new AuthenticateProtocolPacket({
//				ver: "3.8.15.1",
//				zip: "1",
//				dev: "1", 
//				v: "1.0", 
//				token: "csyKLiEOLLTHWeBCWhEYIYP1XHX29zXkNxeGpDiu4AZ8m_u_rvOAs0rahTj1Gp5ME3IRoPORJXm5ISBjin1tOcf6qfjXFg2C60RXywN9xgYrozz1RV5ZODstLkbXeQNOumv1GdiBGQU_F-UZDgaKfSgQkxg16d2vC3L3qnRSEYA", 
//				devn: "Sony Xperia Z - 4.2.2 - API 17 - 1080x1920_e4165df6-a6d8-4873-a5ea-d433085fb120", 
//				msuid: "30147510"
//			});
////			var connection:ConnectionExtender  = new ConnectionExtender()
//			Connection.instance.request(packet);
//			var packet:ProtocolPacket = new AuthenticateProtocolPacket({
//				msuid: "30011697",
//				zip: "1",
//				v: "1.0",
//				ver: "4.1",
//				dev: "1",
//				token: "NyepVrOzcPkaCbliwB8keHjeV7EDcVEDLRSRBRyQb1GV_MbDrOg7a0Hxdecut4RVACdY30sKPZWUdTtdpHh3gIT1RYMVmrjC-kX7gnbf-dOlbH-qRAwy1PkHA_eDuCqYrT66nLltYv3Eci99Si5ravjTpRTbexeZiTInc3wxmMU", 
//				devn: "Sony Xperia Z - 4.2.2 - API 17 - 1080x1920_b0c56658-4c96-419d-aaba-68cc2ceb750d"
//			});
//			
//			Logger.info('packet', packet.toJSONString());
		}
		
		public function testRSAHash():void
		{
			var HASH_KEY:String = 'Ml1A&Yx<D5Q8-5gY/KpxrK@z^;O+n[uIpW\"h:JN;dt4/P=:44cy@`Cfn)z^8=eAt';
			var msqid:String = '126l88l5l121l30l109';
			var decoded:String = RSAHash.instance.hashDecode(msqid, HASH_KEY);
			
			var sequence:Number = parseFloat(decoded);
			
			Logger.info('msqid', msqid);
//			Logger.info('decoded', decoded);
//			Logger.info('sequence', sequence);
//			
//			var sqString:String = '' + sequence;
//			
//			var encoded:String = RSAHash.instance.hashEncode(sqString, HASH_KEY);
//			
//			Logger.info('sqString', sqString);
//			Logger.info('encoded', encoded);
//			
//			var sqString2:String = '' + (++sequence);
//			var encoded2:String = RSAHash.instance.hashEncode(sqString2, HASH_KEY);
//			
//			Logger.info('sqString2', sqString2);
//			Logger.info('encoded2', encoded2);
			
			Authentication.instance.validateSequence(msqid);
			Logger.info('new_msqid++', Authentication.instance.getSequenceKey());
		}
	}
}
