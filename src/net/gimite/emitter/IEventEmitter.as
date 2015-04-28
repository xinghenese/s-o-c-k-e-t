package net.gimite.emitter
{
	import flash.events.Event;
	/**
	 * @author Administrator
	 */
	public interface IEventEmitter
	{
		function on(type:String, listener:Function):void;
		
		function off(type:String, listener:Function):void;
		
		function once(type:String, listener:Function):void;
		
		function fire(event:Event, callback:Function = null):void;
	}
}
