package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Engine;
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class House extends XMLEntity 
	{
		private var interior:Entity;
		private var exterior:Entity;
		private var playerInside:Boolean;
		private var mementos:Vector.<Entity>;
		
		public function House(x:Number, y:Number, mementos:Array) 
		{
			super();
			this.x = x;
			this.y = y;
			
			interior = new Entity(x, y, new Image(Library.getImage("graphics.house.indoor.png").bitmapData));
			interior.mask = new Pixelmask(Library.getImage("graphics.house.mask.png").bitmapData);
			interior.type = "houseInterior";
			
			exterior = new Entity(x, y, new Image(Library.getImage("graphics.house.outdoor.png").bitmapData));
			
			setHitbox(512, 192, -32, -32);
			
			playerInside = false;
			
			this.mementos = new Vector.<Entity>();
			
			for each (var m:String in mementos)
			{
				this.mementos.push(new Entity(x, y, new Image(Library.getImage("graphics.house." + m + ".png").bitmapData)));
			}
		}
		
		override public function added():void 
		{
			super.added();
			
			world.add(interior);
			
			for each (var e:Entity in mementos)
			{
				world.add(e);
			}
			
			world.add(exterior);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (playerInside)
			{
				if (collide("player", x, y))
				{
					playerInside = false;
					
					var tweenOut:VarTween = new VarTween(null, Tween.ONESHOT);
					tweenOut.tween(exterior.graphic as Image, "alpha", 0, 0.2);			
					addTween(tweenOut, true);
				}
			}
			else
			{
				if (!collide("player", x, y))
				{
					playerInside = true;
					
					var tweenIn:VarTween = new VarTween(null, Tween.ONESHOT);
					tweenIn.tween(exterior.graphic as Image, "alpha", 1, 0.2);			
					addTween(tweenIn, true);
				}
			}
		}
	}

}