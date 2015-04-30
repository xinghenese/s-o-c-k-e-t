package net.gimite.packet
{
	import net.gimite.logger.Logger;
	import net.gimite.connection.Connection;
	/**
	 * @author Administrator
	 */
	public class PingProtocolPacket extends ProtocolPacket
	{
		private static const times:int = 60;
		private var currenttime:int = 0;
		
		public function PingProtocolPacket(data:*)
		{
			super(data);
		}
		
		override public function process():void
		{
			if(currenttime ++ < times){
				sendPingPacket();
			}
		}
		
		private function sendPingPacket():void
		{
			var packet:ProtocolPacket = ProtocolPacketManager.instance.createPingProtocolPacket();
			if(packet != null){
				packet.fillData({
					msuid: "30032005",
					msqid: Authentication.instance.getSequenceKey()
				});
				Logger.info('the ' + currenttime + ' time to send PingPacket');
				Connection.instance.request(packet);
			}			
		}
	}
}
