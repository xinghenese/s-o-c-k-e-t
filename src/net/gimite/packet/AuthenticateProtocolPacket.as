package net.gimite.packet
{
	import net.gimite.profiles.UserProfiles;
	import net.gimite.logger.Logger;
	import net.gimite.connection.Connection;
	import net.gimite.bridge.ScriptBridge;
	/**
	 * @author Reco
	 */
	public class AuthenticateProtocolPacket extends ProtocolPacket
	{
		private static const SUCCESS:int = 0;
		
		public function AuthenticateProtocolPacket(data:*)
		{
			super(data);
		}
		
		override public function process():void
		{
			var result:int = int(_data.r);
//			var sequence:int = -1;//
			Logger.info('result at auth', result);
			Logger.info('success?', (result == SUCCESS));
			Logger.info('data', JSON.stringify(_data));
			
			if(result == SUCCESS){
			
//			dispose();
			
				if(Authentication.instance.validateSequence(_data.msqsid)){
//					notifyJSBridge({
//						name: 'Auth'
//					});

					Logger.info('data.msqid', _data.msqsid);
					
					Connection.instance.request(ProtocolPacketManager.instance.createPingProtocolPacket({
						msuid: UserProfiles.instance.userId,
						msqid: Authentication.instance.getSequenceKey()
					}));
					
					
					return;
				}
			}
			
//			Authentication.instance.invalidateSequence();
		}
	}
}
