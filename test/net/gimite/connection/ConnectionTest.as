package net.gimite.connection
{
	import net.gimite.packet.ProtocolPacket;
	import net.gimite.packet.ProtocolPacketTest;
	import net.gimite.logger.Logger;
	import net.gimite.util.ByteArrayUtil;
	import flash.utils.ByteArray;
	import net.gimite.flashsocket.SnappyFlashSocketTest;
	import net.gimite.flashsocket.FlashSocketTest;
	/**
	 * @author Administrator
	 */
	public class ConnectionTest
	{
		private static var INSTANCE:ConnectionTest = null;
		
		private var socket:FlashSocketTest = null;
				
		public function ConnectionTest()
		{
			
		}
		
		public static function get instance():ConnectionTest
		{
			if(INSTANCE == null){
				INSTANCE = new ConnectionTest();
			}
			return INSTANCE;
		}
		
		public function connect():void
		{
			if(socket == null){
				socket = new SnappyFlashSocketTest();
			}
		}
		
		public function request(packet:ProtocolPacket):void
		{
			connect();
			var data:ByteArray = ByteArrayUtil.createByteArray(true, packet.toXMLString());
			socket.write(data);
		}
		
		public function response(parsed:Object):void
		{
			Logger.info('Connection.reponse', JSON.stringify(parsed));
			var packet:ProtocolPacket = ProtocolPacket.refretchPacket(parsed.name);
			if(packet != null){
				packet.fillData(parsed.data);
				Logger.info('packet not null');
				packet.process();
			}			
		}
	}
}
