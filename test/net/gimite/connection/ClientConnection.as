package net.gimite.connection
{
	import net.gimite.offlineflashsocket.AbstractFlashSocket;
	import net.gimite.offlineflashsocket.FlashSocketEvent;
	import flash.events.Event;
	/**
	 * @author Reco
	 */
	public class ClientConnection extends AbstractConnection
	{
		private static var INSTANCE:ClientConnection = null;
		
		private var remote:AbstractConnection = null;
		
		public function ClientConnection(enforcer:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():ClientConnection
		{
			if(INSTANCE == null){
				INSTANCE = new ClientConnection(new SingletonEnforcer());
			}
			return INSTANCE;
		}
	}
}

class SingletonEnforcer
{
	
}
