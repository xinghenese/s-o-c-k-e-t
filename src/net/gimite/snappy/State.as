package net.gimite.snappy
{
	/**
	 * @author Administrator
	 */
	internal class State
	{
		private var value:int;
		
		public static const READY:State = new State(0);
		public static const READING_PREAMBLE:State = new State(1);
		public static const READING_TAG:State = new State(2);
		public static const READING_LITERAL:State = new State(3);
		public static const READING_COPY:State = new State(4);
		
		public function State(value:int):void
		{
			this.value = value;
		}
	}
}
