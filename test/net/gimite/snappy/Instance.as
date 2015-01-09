package net.gimite.snappy
{
	import flash.system.System;
	/**
	 * @author Administrator
	 */
	public class Instance extends Parent
	{
		public function Instance():void{
			
		}
		
		public function main():void{
			setName("Child")
			trace(getName())
		}
	}
}
