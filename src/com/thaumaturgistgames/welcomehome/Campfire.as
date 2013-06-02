package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Campfire extends XMLEntity 
	{
		private var flames:Emitter;
		private var isLit:Boolean;
		private var player:Player;
		
		public function Campfire(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
			this.graphic = new Image(Library.getImage("graphics.dungeon.kindling.png").bitmapData);
			(graphic as Image).scale = .5;
			type = "campfire";
			setHitbox(32, 32);
			
			isLit = false;
			
			flames = new Emitter(new BitmapData(4, 4, true, 0xFFFF9900), 4, 4);
			flames.newType("flame", [0]);
			flames.setMotion("flame", 60, 32, 1, 70, 8, .25);
			flames.setAlpha("flame", 1, 0);
			flames.setColor("flame", 0xFFFFFF00, 0xFFFF5500);
		}
		
		override public function added():void 
		{
			super.added();
			
			player = world.getInstance("player");
			world.addGraphic(flames);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (FP.distance(x, y, player.x, player.y) <= 128)
			{
				flames.emit("flame", centerX, centerY + 4);
			}
		}
	}

}