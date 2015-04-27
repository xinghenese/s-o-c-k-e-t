package net.gimite.offlineflashsocket
{
	import net.gimite.connection.AbstractConnection;
	import flash.utils.getQualifiedClassName;
	import net.gimite.logger.Logger;
	/**
	 * @author Reco
	 */
	public class SocketLog
	{
		public static function log(connection:AbstractConnection, socket:AbstractFlashSocket, method:String = null, msg:* = ''):void
		{
			var connectionName:String = getQualifiedClassName(connection).split('::')[1];
			var socketName:String = getQualifiedClassName(socket).split('::')[1];
//			var socketName:String = 'socket';
//			var socketName:String = connection.socket ? getQualifiedClassName(connection.socket).split('::')[1] : 'socket';
			var name:String = connectionName + '->' + socketName;
			if(method == null){
				Logger.log(name);
			}
			else{
				Logger.info(name + '->' + method, msg);
			}			
		}
	}
}
