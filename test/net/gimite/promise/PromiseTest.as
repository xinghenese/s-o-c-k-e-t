package net.gimite.promise
{
	import flash.utils.setTimeout;
	import net.gimite.async.Promise;
	import net.gimite.logger.Logger;
	import flash.display.Sprite;
	/**
	 * @author Administrator
	 */
	public class PromiseTest extends Sprite
	{
		private var promiseCount:int = 0;
		
		public function PromiseTest()
		{
			Logger.log('start');
			setTimeout(testPromise, 1000);
//			setTimeout(function():void{Logger.log('timeout1');}, 3000);
//			setTimeout(function():void{Logger.log('timeout2');}, 0);
//			  testPromise();
		}
		
		private function testPromise():void {
			var thisPromiseCount:int = ++promiseCount;
			
			Logger.log(thisPromiseCount + ') Started (<small>Sync code started</small>)');
			
				// We make a new promise: we promise the string 'result' (after waiting 3s)
				var p1:Promise = new Promise(
				
			  	// The resolver function is called with the ability to resolve or 
			    // reject the promise
			    function(resolve:Function, reject:Function):void {
					Logger.log(thisPromiseCount + ') Promise started (<small>Async code started</small>)');
					
					// This only is an example to create asynchronism
					setTimeout(
				        function():void {
				          // We fulfill the promise !
				          resolve(thisPromiseCount);
				        }
					, Math.random() * 2000 + 1000);
			    });
				
				// We define what to do when the promise is fulfilled
				
				p1
				.then(
			    // Just log the message and a value
			    	function(val:*):* {
						Logger.log((val++) + ') Promise fulfilled (<small>Async code terminated</small>)');
						return new Promise(function(resolve:Function, reject:Function):void{
//							resolve(val * 10);
							resolve(new Error('asd'));
//							throw new Error('errrrrrr');
						});
			    	})
				.then(
					function(val:*):*{
						val += 6;
						Logger.log(val + ') Promise fulfilled (<small>Async code terminated</small>)');
						return val;
				})
				.then(
					function(val:*):*{
						val += 6;
						Logger.log(val + ') Promise fulfilled (<small>Async code terminated</small>)');
						return val;
				})
				.capture(
					function(reason:*):void{
						Logger.error(reason);
					}
				)				
				.then(
					function(val:*):*{
						val += 6;
						Logger.log(val + ') Promise fulfilled (<small>Async code terminated</small>)');
						return val;
				});
				
//				Logger.log(thisPromiseCount + ') Promise made (<small>Sync code terminated</small>)');
			}
	}
}
