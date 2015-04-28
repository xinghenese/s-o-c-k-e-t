package net.gimite.emitter
{
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * @author Administrator
	 */
	public class EventEmitter extends EventDispatcher implements IEventEmitter
	{
		/**
		 * another function acting as original addEventListener.
		 */
		public function on(type:String, listener:Function):void
		{
			addEventListener(type, listener);
		}
		
		/**
		 * another function acting as original removeEventListener.
		 */
		public function off(type:String, listener:Function):void
		{
			removeEventListener(type, listener);
		}
		
		/**
		 * attach the one-off listener onto the eventdispatcher, which is implemented by dettaching it 
		 * right after its first execution reponse to the event to which the dispatcher listens.
		 */
		public function once(type:String, listener:Function):void
		{
			var markedListener:Function = function(event:Event):void{
				listener(event);
				listener = null;
				removeEventListener(type, markedListener);
			};
			addEventListener(type, markedListener);
		}
		
		/**
		 * another function acting as original dispatchEvent. however, you can pass a callback function, 
		 * which would execute right after firing successfully, as a parameter of the fire function. 
		 */
		public function fire(event:Event, callback:Function = null):void
		{
			var result:Boolean = dispatchEvent(event);
			if(result && callback != null){
				callback(event);
				return;
			}
			if(!result){
				error(event);
			}
		}
		
		public function deffer(callback:Function, ... args):void
		{
			var self:EventEmitter = this;
			setTimeout(function():void{
				callback.apply(self, args);
			}, 0);
		}
		
		protected function error(event:Event):void
		{
			
		}
	}
}
