package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Thermometer extends XMLEntity 
	{
		private var container:Image;
		private var containerEnt:Entity;
		private var filling:Image;
		private var fillingEnt:Entity;
		
		private var clippingMask:BitmapData;
		private var clippingArea:Rectangle;
		
		public function Thermometer(x:Number, y:Number) 
		{
			name = "thermometer";
			super();
			this.x = x;
			this.y = y;
			
			container = new Image(Library.getImage("graphics.thermometer.png").bitmapData);
			
			clippingMask = new BitmapData(200, 200, true, 0x00ffffff);
			
			clippingArea = new Rectangle(0, 0, 200, 200);
			
			filling = new Image(Library.getImage("graphics.thermometer.png").bitmapData);
			filling.color = 0xff3333;
			filling.drawMask = clippingMask;
		}
		
		override public function added():void 
		{
			super.added();
			
			containerEnt = world.addGraphic(container, 0, 28, 22);
			fillingEnt = world.addGraphic(filling, 0, 28, 22);
			
			container.scrollX = container.scrollY = filling.scrollX = filling.scrollY = 0;
			
		}
		
		public function setTemp(val:Number):void
		{
			var percent:Number = FP.clamp(1 - val, 0, 1);
			
			if (percent < .25)
				filling.color = 0xff3333;
			if (percent >= .25 && percent < .5)
				filling.color = 0xA848CC;
			if (percent >= .5 && percent < .75)
				filling.color = 0x614FC6;
			if (percent > .75)
				filling.color = 0xA8EAFF;
				
			clippingArea.y = container.height * percent;
			
			// Clear the old rectangle.
			clippingMask.fillRect(clippingMask.rect, 0x00ffffff);
			
			// Apply the new fill.
			clippingMask.fillRect(clippingArea, 0xffffffff);
			
			filling.drawMask = clippingMask;
		}
		
		override public function update():void 
		{
			super.update();
			containerEnt.layer = world.layerNearest;
			fillingEnt.layer = world.layerNearest;
		}
		
	}

}