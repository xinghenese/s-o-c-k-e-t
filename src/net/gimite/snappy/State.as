package net.gimite.snappy
{
	/**
	 * @author Administrator
	 */
	internal class State
	{
		private static const states:Array = ['READY', 'READING_PREAMBLE', 'READING_TAG', 'READING_LITERAL', 'READING_COPY'];
		
		public static const READY:int = 0;
		public static const READING_PREAMBLE:int = 1;
		public static const READING_TAG:int = 2;
		public static const READING_LITERAL:int = 3;
		public static const READING_COPY:int = 4;
		
		public static function getState(state:int):String
		{
			return states[state];
		}
		
		
	}
}
