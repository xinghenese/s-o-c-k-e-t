package net.gimite.async
{
	import net.gimite.emitter.EventEmitter;
	/**
	 * @author Administrator
	 */
	public class oldPromise extends EventEmitter
	{
		
		private var state:int = State.PENDING;
		private var execute:Function;
		private var returnValue:* = null;
		private var reason:String = '';
		
		public function oldPromise(execute:Function)
		{
			this.execute = execute;
		}
		
		public function get status():int
		{
			return state;
		}
		
		public function then(resolve:Function, reject:Function = null):oldPromise
		{
			state = State.SETTLED;
			if(execute != null){
				try{
					execute(
						function(value:*):void{
							returnValue = resolve(value);	
							state = State.FULFILLED;
						}, 
						function(e:Error):void{
							reject(e);
							state = State.REJECTED;
						}
					);
				}
				catch(e:Error){
					reject(e);
					state = State.REJECTED;
				}
				finally{
					execute = null;
				}
			}
			else{
				executeByDefault(resolve, reject);
			}
			
			if(returnValue is oldPromise){
				return returnValue as oldPromise;
			}
			state = State.PENDING;
			return this;
		}
		
		public function capture(reject:Function):oldPromise
		{
			if(state = State.REJECTED){
				reject();
			}
			state = State.PENDING;
			return this;
		}
		
		private function resolve(value:*):void
		{
			returnValue = value;
			state = State.FULFILLED;
		}
		
		private function reject(e:*):void
		{
			if(e is Error){
				reason = e.name + ': ' + e.message;
			}
			else{
				reason = e.toString();
			}
			state = State.REJECTED;
		}
		
		private final function executeByDefault(resolve:Function, reject:Function):void
		{
			try{
				returnValue = resolve(returnValue);
				state = State.FULFILLED;
			}
			catch(e:Error){
				reject(e);
				state = State.REJECTED;
			}
		}
	}
}

class State
{
	public static const PENDING:int = 0;
	public static const FULFILLED:int = 1;
	public static const REJECTED:int = 2;
	public static const SETTLED:int = 3;
}
