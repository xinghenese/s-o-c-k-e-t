package net.gimite.flashsocket
{
	import flash.events.Event;
	/**
	 * @author Administrator
	 */
	internal interface SocketListener
	{
		function handleClose(e:Event):void;
		function handleConnect(e:Event):void;
		function handleIOError(e:Event):void;
		function handleSecurityError(e:Event):void;
		function handleSocketData(e:Event):void;
	}
}
