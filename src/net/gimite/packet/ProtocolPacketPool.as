package net.gimite.packet
{
	import net.gimite.logger.Logger;
	import flash.utils.getDefinitionByName;
	/**
	 * @author Administrator
	 */
	public class ProtocolPacketPool
	{
		private static var INSTANCE:ProtocolPacketPool = null;	
		private var _packets:Vector.<ProtocolPacket>;
		
		public function ProtocolPacketPool(enforcer:SingletonEnforcer)
		{
			_packets = new Vector.<ProtocolPacket>();
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
			var index:int = _packets.indexOf(packet);
			if(index != -1){
				_packets.splice(index, 1);
			}
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
				Logger.info('packet is HSK', packet is HandShakeProtocolPacket);
				Logger.info('packet is null', packet == null);
				if(packet != null){
					return packet.reset().fillData(data);
				}
				var clazz:Class = getDefinitionByName(clzName) as Class;
				packet = new clazz(data);
				_packets.push(packet);
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
			
			//TestBlock
			var p:ProtocolPacket = new HandShakeProtocolPacket();
			Logger.info('p is HandShakeProtocolPacket', p is clazz);
			//
			
			var length:uint = _packets.length;
			if(length == 0){
				return null;
			}	
			for(var i:uint = 0; i < length; i ++){
				if(_packets[i] is clazz){
					Logger.info('i', i);
					return _packets[i];
				}
			}
			return null;
		}
	}
}

class SingletonEnforcer{}