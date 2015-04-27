package net.gimite.offlineflashsocket
{
	import flash.utils.setTimeout;
	import flash.events.Event;
	import net.gimite.logger.Logger;
	import flash.events.EventDispatcher;
	/**
	 * @author Reco
	 */
	public class SocketAdapter extends EventDispatcher
	{
		public function fire(event:Event, callback:Function = null):Boolean
		{			
			var result:Boolean = super.dispatchEvent(event);
			if(result){
//				SocketLog.log(this, event.type, 'fired');
				Logger.info(event.type + '.fired', event);
				if(callback != null){
					callback(event);
				}
			}
			else{
//				SocketLog.log(this, event.type, 'failed firing');
				Logger.error(event.type + ' failed firing');
				fireError();
			}
			return result;
		}
		
		public function fireError():void
		{
		}
		
		public function on(type:String, listener:Function):void
		{
			if(listener != null/* && !listener.added*/){
				var self:SocketAdapter = this;
				addEventListener(type, function(e:Event):void{
					self.deffer(listener, e);
				});
//				listener.added = true;
			}
		}
		
		public function once(type:String, listener:Function):void
		{
			if(listener != null){
				var _listener:Function = function(event:Event):void{
					setTimeout(function():void{						
						listener(event);
						listener = null;
						removeEventListener(type, _listener);
					}, 0);
				};
				addEventListener(type, _listener);
			}			
		}
		
		public function off(type:String, listener:Function):void
		{
			if(listener != null){
				removeEventListener(type, listener);
			}			
		}
		
		public function deffer(callback:Function, ... args):void
		{
			var self:SocketAdapter = this;
			setTimeout(function():void{
				callback.apply(self, args);
			}, 0);
		}
	}
}
