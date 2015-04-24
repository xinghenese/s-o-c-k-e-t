package net.gimite.snappy
{
	import com.adobe.protocols.dict.events.ConnectedEvent;
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
//			Connection.instance.connect();
			var packet:ProtocolPacket = new AuthenticateProtocolPacket({
				ver: "3.8.15.1",
				zip: "1",
				dev: "1", 
				v: "1.0", 
				token: "csyKLiEOLLTHWeBCWhEYIYP1XHX29zXkNxeGpDiu4AZ8m_u_rvOAs0rahTj1Gp5ME3IRoPORJXm5ISBjin1tOcf6qfjXFg2C60RXywN9xgYrozz1RV5ZODstLkbXeQNOumv1GdiBGQU_F-UZDgaKfSgQkxg16d2vC3L3qnRSEYA", 
				devn: "Sony Xperia Z - 4.2.2 - API 17 - 1080x1920_e4165df6-a6d8-4873-a5ea-d433085fb120", 
				msuid: "30147510"
			});
			var connection:ConnectionExtender  = new ConnectionExtender()
			Connection.instance.request(packet);
		}
	}
}

import net.gimite.util.ByteArrayUtil;
import flash.utils.ByteArray;
import net.gimite.packet.ProtocolPacket;
import net.gimite.connection.Connection;

class ConnectionExtender extends Connection
{	
	override public function request(packet:ProtocolPacket)
	{
		var data:ByteArray = ByteArrayUtil.createByteArray(true, packet.toXMLString());
		
	}
}
