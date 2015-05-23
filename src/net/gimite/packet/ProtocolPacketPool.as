package net.gimite.packet
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import net.gimite.logger.Logger;
	import flash.utils.getDefinitionByName;
	/**
	 * @author Administrator
	 */
	public class ProtocolPacketPool
	{
		private static var INSTANCE:ProtocolPacketPool = null;	
		private var packets:Vector.<ProtocolPacket>;
		private var timers:Object = {};
		
		public function ProtocolPacketPool(enforcer:SingletonEnforcer)
		{
			packets = new Vector.<ProtocolPacket>();
		}
		
		public static function get instance():ProtocolPacketPool
		{
			if(INSTANCE == null){
				INSTANCE = new ProtocolPacketPool(new SingletonEnforcer());
			}
			return INSTANCE;
		}
		
		/*********************************************************************************/
		
		/**
		 * remove the packet from the packets pool.
		 */
		public function removePacket(packet:ProtocolPacket):void
		{
			var index:int = packets.indexOf(packet);
			if(index != -1){
				packets.splice(index, 1);
			}
			Logger.info('removePacket', packets);
		}
		
		/**
		 * fetch the packet from the packets pool according to the <i>clzName</i>. if the class 
		 * called <i>clzName</i> does not exist, return null; else if the packet does not exist
		 * in the packets pool, create a new instance of the packet class, push it into the packets
		 * pool and then return it.
		 */
		public function fetchPacket(clzName:String, data:* = null):ProtocolPacket
		{
			try{
				var packet:ProtocolPacket = findPacket(clzName);
				if(packet != null){
					//remove the one-off packet from the packets pool
//					if(!SocketProtocolInfo.isReusable(clzName)){
//						removePacket(packet);
//					}
					var delay:int = SocketProtocolInfo.getTimeout(clzName);
					//remove the one-off packet from the packets pool with no delay.
					if(delay == 0){
						removePacket(packet);
					}
					//delay removing the packet.
					else if(delay > 0){
						var timer:uint = timers[clzName] || 0;
						//if there is already a timer to delay removing the packet, reset the timer,
						//which helps avoid duplicate and ineffective removals.
						if(timer > 0){
							clearTimeout(timer);
						}
						timers[clzName] = setTimeout(function():void{
							removePacket(packet);
						}, delay);
					}
					return packet.reset().fillData(data);
				}
				var clazz:Class = getDefinitionByName(clzName) as Class;
				packet = new clazz(data);
				packets.push(packet);
				return packet;
			}
			catch(e:Error){
				Logger.error(e);
				return null;
			}
			
			return null;
		}
		
		/**
		 * find out the packet from packets pool according to the <i>clzName</i>. it should be noted
		 * that <i>getDefinitionByName</i> would throw referenceError if the class called <i>clzName</i>
		 * does not exist, yet we let the error spread through the outer function instead of catching
		 * it so as to differ this invalid situation, non-existence of the packet class, from another 
		 * invalid situation, non-presence of the packet in the packets pool, and later in the outer 
		 * function we can decide how to deal with either of them respectively.
		 */
		private function findPacket(clzName:String):ProtocolPacket
		{
			var clazz:Class = getDefinitionByName(clzName) as Class; //maybe throw ReferenceError
			var length:uint = packets.length;
			Logger.info('packets', packets);
			
			if(length == 0){
				return null;
			}	
			for(var i:uint = 0; i < length; i ++){
				if(packets[i] is clazz){
					return packets[i];
				}
			}
			
			return null;
		}
	}
}

class SingletonEnforcer{}