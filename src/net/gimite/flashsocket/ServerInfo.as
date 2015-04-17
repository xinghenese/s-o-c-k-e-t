package net.gimite.flashsocket
{
	/**
	 * @author Administrator
	 */
	public class ServerInfo extends Array
	{
		private var INSTANCE:ServerInfo = null;
		private const INFOS:Array = ["192.168.0.110", "192.168.1.66", "192.168.1.67", "192.168.1.68", "192.168.0.66", "192.168.0.67", "192.168.0.68"];
		
		public function ServerInfo(infos:Array = null)
		{
			if(infos == null){
				infos = INFOS;
			}
			return infos;
		}
		
//		public function get():ServerInfo
//		{
//			
//		}
	}
}
