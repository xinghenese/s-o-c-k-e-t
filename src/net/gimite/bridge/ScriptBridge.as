package net.gimite.bridge
{
	import flash.events.Event;
	import net.gimite.packet.ProtocolEvent;
	import flash.external.ExternalInterface;
	import net.gimite.emitter.EventEmitter;
	/**
	 * @author Administrator
	 */
	public class ScriptBridge extends EventEmitter
	{
		private static var INSTANCE:ScriptBridge = null;
		
		public function ScriptBridge(enforcer:SingletonEnforcer)
		{
			on(ProtocolEvent.SUCCESS, notifyJS);
			on(ProtocolEvent.ERROR, scriptError);
		}
		
		public static function get instance():ScriptBridge
		{
			if(INSTANCE == null){
				INSTANCE = new ScriptBridge(new SingletonEnforcer());
			}
			return INSTANCE;
		}
		
		public function exposeToJS(name:String, callback:Function):void
		{
			ExternalInterface.addCallback(name, callback);
		}
		
		public function notifyJS(event:Event):void
		{
			ExternalInterface.call('protocol', (event as ProtocolEvent).message);
		}
		
		public function scriptError(event:Event):void
		{
			
		}
	}
}

class SingletonEnforcer
{
	
}
