package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class MiniMap extends XMLEntity
	{
		private var icon:Entity;
		
		public function MiniMap(img:Image) 
		{
			super();
			
			graphic = img;
			
			graphic.scrollX = graphic.scrollY = 0;
			img.centerOrigin();
			img.alpha = 0;
			
			x = FP.screen.width / 2;
			y = FP.screen.height / 2;
			
			name = "minimap";
			
			icon = new Entity(0, 0, new Image(Library.getImage("graphics.map.png").bitmapData));
			icon.graphic.scrollX = icon.graphic.scrollY = 0;
			icon.setHitboxTo(icon.graphic);
			icon.x = FP.screen.width - (icon.graphic as Image).width;
		}
		
		override public function added():void 
		{
			super.added();
			world.add(icon);
		}
		
		override public function removed():void 
		{
			world.remove(icon);
			super.removed();
		}
		
		override public function update():void 
		{
			super.update();
			
			if ((graphic as Image).alpha == 1)
			{
				if (!icon.collidePoint(icon.x, icon.y, Input.mouseX, Input.mouseY))
				{
					var tweenOut:VarTween = new VarTween(null, Tween.ONESHOT);
					tweenOut.tween((graphic as Image), "alpha", 0, 0.4);			
					addTween(tweenOut, true);
				}
			}
			
			if ((graphic as Image).alpha == 0)
			{
				if (icon.collidePoint(icon.x, icon.y, Input.mouseX, Input.mouseY))
				{
					var tweenIn:VarTween = new VarTween(null, Tween.ONESHOT);
					tweenIn.tween((graphic as Image), "alpha", 1, 0.4);			
					addTween(tweenIn, true);
				}
			}
		}
		
	}

}