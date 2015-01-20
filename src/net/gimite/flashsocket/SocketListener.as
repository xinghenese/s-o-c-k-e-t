package net.gimite.flashsocket
{
	import flash.events.Event;
	/**
	 * @author Administrator
	 */
	public interface SocketListener
	{
		function closeHandler(e:Event):void;
		function connectHandler(e:Event):void;
		function ioErrorHandler(e:Event):void;
		function securityErrorHandler(e:Event):void;
		function socketDataHandler(e:Event):void;
	}
}
