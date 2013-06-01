package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.flakit.loader.ImageLoader;
	import flash.display.Graphics;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class InventoryItem extends XMLEntity
	{
		private var parent:Inventory;
		private var slot:uint;
		
		private var largeView:Image;
		private var previewing:Boolean;
		
		public function InventoryItem(imgFilename:String, slot:uint, parent:Inventory) 
		{
			super();
			
			this.graphic = new Image(Library.getImage(imgFilename).bitmapData);
			this.slot = slot;
			this.parent = parent;
			
			setHitboxTo(this.graphic);
			centerOrigin();
			(this.graphic as Image).centerOrigin();
			
			largeView = new Image(Library.getImage(imgFilename).bitmapData);
			previewing = false;
		}
		
		override public function added():void 
		{
			super.added();
			
			world.addGraphic(largeView);
			largeView.centerOrigin();
			largeView.x = FP.screen.width / 2;
			largeView.y = FP.screen.height / 2;
			largeView.scale = 6;
			largeView.alpha = 0;
		}
		
		override public function update():void 
		{
			super.update();
			x = parent.x + (28 + (slot * 50));
			y = parent.y + (32);
			
			if (parent.isOpen)
			{
				if (largeView.alpha == 1)
				{
					if (!collidePoint(x, y, Input.mouseX, Input.mouseY))
					{
						var tweenOut:VarTween = new VarTween(null, Tween.ONESHOT);
						tweenOut.tween(largeView, "alpha", 0, 0.2);			
						addTween(tweenOut, true);
					}
				}
				
				if (largeView.alpha == 0)
				{
					if (collidePoint(x, y, Input.mouseX, Input.mouseY))
					{
						var tweenIn:VarTween = new VarTween(null, Tween.ONESHOT);
						tweenIn.tween(largeView, "alpha", 1, 0.6);			
						addTween(tweenIn, true);
					}
				}
			}
		}
	}

}