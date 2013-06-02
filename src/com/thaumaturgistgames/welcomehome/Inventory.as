package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.ActionScriptVersion;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Inventory extends XMLEntity
	{
		private var closedPos:Point;
		private var openedPos:Point;
		private var _isOpen:Boolean;
		
		private var items:Vector.<InventoryItem>;
		
		public function Inventory() 
		{
			super();
			
			this.graphic = new Image(Library.getImage("graphics.inventory.png").bitmapData, new Rectangle(0, 0, 256));
			setHitboxTo(graphic);
			
			openedPos = new Point((FP.screen.width / 2) - (graphic as Image).clipRect.width / 2, 0);
			closedPos = new Point(openedPos.x, -64);
			
			x = closedPos.x;
			y = closedPos.y;
			
			_isOpen = false;
			
			items = new Vector.<InventoryItem>();
			
			graphic.scrollX = graphic.scrollY = 0;
		}
		
		override public function added():void 
		{
			super.added();
			
			// TODO: Take these functions out, and call them when the player picks them up in the world, yo.
			//addItem("graphics.photo.png");
			//addItem("graphics.loveLetter.png");
			//addItem("graphics.ring.png");
			//addItem("graphics.lipstick.png");
			//addItem("graphics.roses.png");
			
			layer = world.layerNearest
		}
		
		override public function update():void 
		{
			super.update();
			
			if (collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				//Input.mouseCursor = MouseCursor.BUTTON;
				
				if (Input.mousePressed)
				{
					_isOpen = !_isOpen;
					
					(graphic as Image).clipRect.x = isOpen ? 256 : 0;
					
					var tween:VarTween = new VarTween(null, Tween.ONESHOT);
					tween.tween(this, "y", (_isOpen ? openedPos.y : closedPos.y), 0.8, Ease.bounceOut);			
					addTween(tween, true);
				}
			}
			//else
			//{
			//	Input.mouseCursor = MouseCursor.ARROW;
			//}
			
			for each (var i:InventoryItem in items)
			{
				i.update();
			}
		}
		
		public function addItem(imgFilename:String):void
		{
			if (items.length >= 5)
			{
				return;
			}
			
			var item:InventoryItem = new InventoryItem(imgFilename, items.length, this);
			items.push(item);
			world.add(item);
		}
		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		public function get itemsCollected():uint
		{
			return items.length;
		}
	}

}