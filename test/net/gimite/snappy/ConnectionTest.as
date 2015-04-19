package net.gimite.snappy
{
	import net.gimite.connection.Connection;
	import flash.display.Sprite;
	/**
	 * @author Administrator
	 */
	public class ConnectionTest extends Sprite
	{
		public function ConnectionTest()
		{
			Connection.instance.connect();
		}
	}
}
