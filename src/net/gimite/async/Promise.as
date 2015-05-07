package net.gimite.async
{
	import flash.events.Event;
	import net.gimite.emitter.EventEmitter;
	import net.gimite.logger.Logger;
	/**
	 * @author Administrator
	 */
	public class Promise extends EventEmitter
	{
		private var _state:int = State.PENDING;
		private var _value:*;
		private var _reason:String;
		private var _id:int;
		
		private static var _id_:int = 0;
		
		public function Promise(executor:Function)
		{
			_id = _id_ ++ ;
			run(executor, _resolve, _reject);
		}
		
		public function then(onFulfilled:Function, onRejected:Function = null):Promise
		{
			var that:Promise = this;
			var executor:Function = function(resolve:Function, reject:Function):void{
				if(that._state ==  State.FULFILLED){
					Logger.log('Promise#onFulfilled');
					if(onFulfilled){
						resolve(onFulfilled(that._value));
					}
					else{
						resolve(that._value);
					}
				}
				else if(that._state == State.REJECTED){
					Logger.log('Promise#onRejected');
					if(onRejected){
						onRejected(that._reason);
					}
					reject(that._reason);
				}
			};
			return new Promise(function(resolve:Function, reject:Function):void{
				var self:Promise = this as Promise;
				if(that._state == State.PENDING){
					Logger.log('Promise#state == PENDING');
					that.onstatechange = function(e:Event):void{
						
						//data flows from the last promise to the current promise
						synchronize(that, self);
						Logger.log('this: ' + self.print());
						
						run(executor, resolve, reject);
					};
				}
				else{
					Logger.log('Promise#state == SETTLED');
					deffer(function():void{
						
						//data flows from the last promise to the current promise
						synchronize(that, self);
						Logger.log('this: ' + self.print());
						
						run(executor, resolve, reject);
					});
				}
			});
		}
		
		public function capture(onRejected:Function):Promise
		{
			Logger.log('capture');
			return then(undefined, onRejected);
		}
		
		private function _resolve(value:*):void
		{
			Logger.groupStart('Promise#resolve');
			if(value is Error){
				Logger.log('Promise#resolve/Error');
				_reject(value);
				return;
			}
			if(value is Promise){
				Logger.log('Promise#resolve/Promise');
				var p:Promise = value as Promise;
				if(p._state == State.PENDING){
					_value = p.run()._value;
				}
				else if(p._state == State.REJECTED){
					_reject(p._reason);				
				}
			}
			else{
				Logger.log('Promise#resolve/Else');
				_value = value;
			}
			Logger.log('value: ' + _value);
			_state = State.FULFILLED;
			Logger.groupEnd();
			
			//control flows from the current promise to the next promise('s executor).
			fire(new PromiseEvent());
		}
		
		private function _reject(reason:*):void
		{
			Logger.groupStart('Promise#reject');
			if(reason is Promise){
				Logger.log('Promise#reject/Promise');
				var p:Promise = reason as Promise;
				if(p._state = State.PENDING){
					_value = p.run()._value;
					_state = State.FULFILLED;
				}
				else if(p._state = State.FULFILLED){
					_state = State.FULFILLED;
				}
				else{
					_state = State.REJECTED;
				}
			}
			else{
				if(reason is Error){
					Logger.log('Promise#reject/Error');
					_reason = reason.name + ': ' + reason.message;
				}
				else{
					Logger.log('Promise#reject/Else');
					_reason = reason.toString();
				}
				Logger.log('reason: ' + _reason);
				_state = State.REJECTED;
			}
			Logger.groupEnd();
			
			//control flows from the current promise to the next promise('s executor).
			fire(new PromiseEvent());
		}
		
		private static function synchronize(promise1:Promise, promise2:Promise):void
		{
			promise2._value = promise1._value;
			promise2._reason = promise1._reason;
		}
		
		private function set onstatechange(handler:Function):void
		{
			once(PromiseEvent.CHANGE_STATUS, handler);
		}
		
		private function run(executor:Function = null, ...args):Promise
		{
			Logger.log('Promise#run executor');
			try{
				if(executor == null){
					executor = _resolve;
					args = [_value];
				}
				executor.apply(this, args);
			}
			catch(e:Error){
				_reject(e);
			}
			finally{
				return this;
			}
		}
		
		private function print():String
		{
			return JSON.stringify({
				id: _id,
				state: State.toString(_state),
				value: _value,
				reason: _reason
			});
		}
	}
}
import flash.events.Event;

class State
{
	public static const PENDING:int = 0;
	public static const FULFILLED:int = 1;
	public static const REJECTED:int = 2;
	public static const SETTLED:int = 3;
	
	public static function toString(state:int):String
	{
		return (['PENDING', 'FULFILLED', 'REJECTED', 'SETTLED'])[state];
	}
}

class PromiseEvent extends Event
{
	public static const CHANGE_STATUS:String = 'changeStatus';
	
	public function PromiseEvent()
	{
		super(CHANGE_STATUS, false, false);
	}
}