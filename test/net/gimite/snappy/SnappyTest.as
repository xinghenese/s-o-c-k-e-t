package net.gimite.snappy
{
	import net.gimite.logger.Logger;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Sprite;
	/**
	 * @author Administrator
	 */
	public class SnappyTest extends Sprite
	{
		public function SnappyTest()
		{
//			var loader:Loader = new Loader();
//			loader.load(new URLRequest("SnappyTest.swf"));
//			stage.addChild(loader);
			this.graphics.clear();
			this.graphics.beginFill(0x999999);
			this.graphics.drawCircle(100,100,100);  
			trace("SnappyTest");
			Logger.info("Test", "Snappy");
		}		
	}
}
