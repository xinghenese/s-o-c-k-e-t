package net.gimite.connection
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	import net.gimite.logger.Logger;
	import net.gimite.offlineflashsocket.SocketAdapter;
	import net.gimite.packet.AuthenticateProtocolPacket;
	import net.gimite.packet.ProtocolPacket;
	/**
	 * @author Reco
	 */
	public class ConnectionTest extends Sprite
	{
		public function ConnectionTest()
		{
			var packet:ProtocolPacket = new AuthenticateProtocolPacket({
				ver: "3.8.15.1",
				zip: "1",
				dev: "1", 
				v: "1.0", 
				token: "csyKLiEOLLTHWeBCWhEYIYP1XHX29zXkNxeGpDiu4AZ8m_u_rvOAs0rahTj1Gp5ME3IRoPORJXm5ISBjin1tOcf6qfjXFg2C60RXywN9xgYrozz1RV5ZODstLkbXeQNOumv1GdiBGQU_F-UZDgaKfSgQkxg16d2vC3L3qnRSEYA", 
				devn: "Sony Xperia Z - 4.2.2 - API 17 - 1080x1920_e4165df6-a6d8-4873-a5ea-d433085fb120", 
				msuid: "30147510"
			});
			
//			var packet2:ProtocolPacket = new AuthenticateProtocolPacket({
//				ver: "12345",
//				zip: "6",
//				dev: "7", 
//				v: "8.0", 
//				token: "cvOAs0rahTj1Gp5ME3IRoPORJXm5ISBjin1tOcf6qfjXFg2C60RXywN9xgYrozz1RV5ZODstLkbXeQNOumv1GdiBGQU_F-UZDgaKfSgQkxg16d2vC3L3qnRSEYAsyKLiEOLLTHWeBCWhEYIYP1XHX29zXkNxeGpDiu4AZ8m_u_r", 
//				devn: "Apple", 
//				msuid: "765710"
//			});
			
			AbstractConnection.instance.request(packet);
//			testTimer3();
		}
		
		public function testTimer3():void
		{
			var socket:SocketAdapter = new SocketAdapter();
			var et:String = 'et';
			Logger.info('socket.hasEventListener(et)-1', socket.hasEventListener(et));
			socket.on(et, function(e:Event):void{Logger.log('close1');});
			socket.fire(new Event(et));
			
		}
		
		public function testTimer2():void
		{
			var socket:SocketAdapter = new SocketAdapter();
			var et:String = 'et';
//			socket.deffer(addEventListener, et, function(e:Event):void{Logger.log('close1');});
			socket.deffer(function():void{
				socket.addEventListener(et, function(e:Event):void{Logger.log('close1');});
			});
			socket.deffer(function():void{Logger.info('socket.hasEventListener(et)-1', socket.hasEventListener(et));});
			socket.deffer(function():void{socket.fire(new Event(et));});
		}
		
		public function testTimer():void
		{
			
			var socket:SocketAdapter = new SocketAdapter();
			var et:String = 'et';
			Logger.info('socket.hasEventListener(et)-1', socket.hasEventListener(et));
			socket.once(et, function(e:Event):void{Logger.log('close1');});
//			socket.deffer(function():void{
				Logger.info('socket.hasEventListener(et)-2', socket.hasEventListener(et));
				socket.fire(new Event(et));
				Logger.info('socket.hasEventListener(et)-3', socket.hasEventListener(et));
				socket.deffer(function():void{
					Logger.info('socket.hasEventListener(et)-4', socket.hasEventListener(et));
				});
//			});
			
			
//			socket.deffer(function(... args):void{
//				Logger.info('socket.hasEventListener(et)-4', socket.hasEventListener(et));
//				for(var i:int = 0, len:int = args.length; i < len; i ++){
//					Logger.log(args[i]);
//				}
//			}, '232', '3sadf');
//			setTimeout(function(){
//				Logger.info('socket.hasEventListener(Event.CLOSE)-4', socket.hasEventListener(Event.CLOSE));
//			}, 0);
		}
	}
}
