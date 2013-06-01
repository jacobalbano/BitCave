package com.jacobalbano.punkutils 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class DeferredCallback extends Entity 
	{
		private var callback:Function;
		
		public function DeferredCallback(f:Function) 
		{
			callback = f;
		}
		
		override public function update():void 
		{
			if (callback())
			{
				world.remove(this);
			}
		}
		
	}

}