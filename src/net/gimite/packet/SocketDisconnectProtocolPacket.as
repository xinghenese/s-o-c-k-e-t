package net.gimite.packet
{
	import net.gimite.connection.Connection;
	/**
	 * @author Administrator
	 */
	public class SocketDisconnectProtocolPacket extends ProtocolPacket
	{
		public function SocketDisconnectProtocolPacket(data:* = null)
		{
			super(data);
		}
		
		override public function process():void
		{
			Connection.instance.close();
		}
	}
}
