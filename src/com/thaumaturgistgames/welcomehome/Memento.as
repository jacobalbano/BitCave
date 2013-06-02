package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Memento extends XMLEntity 
	{
		private var alert:Text;
		private var alertEnt:Entity;
		private var alerting:Boolean;
		public var filename:String;
		
		public function Memento(name:String, x:Number, y:Number) 
		{
			filename = "graphics.dungeon." + name + ".png";
			
			var img:Image = new Image(Library.getImage(filename).bitmapData);
			img.scale = .5;
			img.centerOrigin();
			
			this.x = x;
			this.y = y + (img.scaledHeight / 2);
			
			graphic = img;
			setHitbox(img.scaledWidth, img.scaledHeight);
			centerOrigin();
			type = "memento";
			
			alert = new Text("E", x, y - 32);
			alert.size = 18;
			alert.alpha = 0;
			alert.centerOrigin();
			
			alerting = false;
		}
		
		override public function added():void 
		{
			super.added();
			
			alertEnt = world.addGraphic(alert);
		}
		
		override public function removed():void 
		{
			world.remove(alertEnt);
			super.removed();
		}
		
		override public function update():void 
		{
			super.update();
			
			if (alerting)
			{
				if (!collide("player", x, y))
				{
					trace("NOPE");
					alerting = false;
					
					var tweenOut:VarTween = new VarTween(null, Tween.ONESHOT);
					tweenOut.tween(alert, "alpha", 0, 0.4);			
					addTween(tweenOut, true);
				}
			}
			else
			{
				if (collide("player", x, y))
				{
					trace("YUP");
					alerting = true;
					
					var tweenIn:VarTween = new VarTween(null, Tween.ONESHOT);
					tweenIn.tween(alert, "alpha", 1, 0.4);			
					addTween(tweenIn, true);
				}
			}
		}
		
	}

}