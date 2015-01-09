package net.gimite.snappy
{
	/**
	 * @author Administrator
	 */
	public final class ShortUtil
	{
		private var value:int;
		
		public function Short(num:int)
		{
			value = num & 0xFFFF;
		}
	}
}
