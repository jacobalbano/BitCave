package com.jacobalbano.punkutils 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Transition entity to fade between worlds
	 * @author Jacob Albano
	 */
	public class Transition extends Entity 
	{
		public function Transition() 
		{
			super(0, 0, FP.screen.capture());
			graphic.scrollX = graphic.scrollY = 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			var image:net.flashpunk.graphics.Image = graphic as net.flashpunk.graphics.Image;
			if ((image.alpha -= 0.075) <= 0)
			{
				FP.world.remove(this);
			}
		}
		
	}

}