package net.gimite.connection
{
	import net.gimite.offlineflashsocket.FlashSocketEvent;
	import net.gimite.offlineflashsocket.AbstractFlashSocket;
	import flash.events.Event;
	/**
	 * @author Reco
	 */
	public class ServerConnection extends AbstractConnection
	{
		private static var INSTANCE:ServerConnection = null;
		
		private var remote:AbstractConnection = null;
		
		public function ServerConnection(enforcer:SingletonEnforcer)
		{
			
		}
		
		public static function get instance():ServerConnection
		{
			if(INSTANCE == null){
				INSTANCE = new ServerConnection(new SingletonEnforcer());
			}
			return INSTANCE;
		}
	}
}

class SingletonEnforcer
{
	
}
