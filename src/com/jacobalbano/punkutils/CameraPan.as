package com.jacobalbano.punkutils 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import net.flashpunk.Entity;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.punkutils.OgmoWorld;
	
	/**
	 * @author Jacob Albano
	 */
	public class CameraPan extends XMLEntity 
	{
		public var wrapAround:Boolean;
		public var worldWidth:int;
		public var worldHeight:int;
		public var buffer:int;
		public var scrollSpeed:int;
		
		private var leftBuffer:Rectangle;
		private var rightBuffer:Rectangle;
		private var topBuffer:Rectangle;
		private var bottomBuffer:Rectangle;
		
		private var tween:VarTween;
		public var speedX:Number;
		public var speedY:Number;
		private var inXBuffer:Boolean;
		private var inYBuffer:Boolean;
		private var xTween:VarTween;
		private var yTween:VarTween;
		
		public function CameraPan() 
		{
			super();
			worldWidth = 0;		//	default
			worldHeight = 0;	//	default
			tween = new VarTween;
			addTween(tween, true);
			speedX = 0;
			speedY = 0;
		}
		
		override public function added():void 
		{
			super.added();
			
			FP.camera.x = x;
			FP.camera.y = y;
			
			var oWorld:OgmoWorld = world as OgmoWorld;
			if (!oWorld)
			{
				return;
			}
			
			this.worldWidth = oWorld.size.x;
			this.worldHeight = oWorld.size.y;
			oWorld.wraparound = this.wrapAround;
			
			leftBuffer = new Rectangle(0, 0, buffer, FP.height);
			rightBuffer = new Rectangle(FP.width - buffer, 0, buffer, FP.height);
			topBuffer = new Rectangle(0, 0, FP.width, buffer);
			bottomBuffer = new Rectangle(0, FP.height - buffer, FP.width, buffer);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (wrapAround || (FP.camera.x >= 0 && FP.camera.x + FP.width <= worldWidth))
			{
				if (leftBuffer.contains(getTestX(), getTestY()))
				{
					onEnterLeft();
				}
				else if (rightBuffer.contains(getTestX(), getTestY()))
				{
					onEnterRight();
				}
				else
				{
					onExitX();
				}
			}
			
			if (wrapAround || FP.camera.y >= 0 && FP.camera.y + FP.height <= worldHeight)
			{
				if (topBuffer.contains(getTestX(), getTestY()))
				{
					onEnterTop();
				}
				else if (bottomBuffer.contains(getTestX(), getTestY()))
				{
					onEnterBottom();
				}
				else
				{
					onExitY();
				}
			}
			
			var point:Point = new Point();
			point.x = speedX;
			point.y = speedY;
			point.normalize(scrollSpeed);
			
			//if (inXBuffer && inYBuffer)
			//{
				//trace("both");
				//speedX = point.x;
				//speedY = point.y;
			//}
			
			FP.camera.x += speedX;
			FP.camera.y += speedY;
			
			if (!wrapAround)
			{
				if (FP.width <= worldWidth)
				{
					if (FP.camera.x < 0)
					{
						FP.camera.x = 0;
					}
					else if (FP.camera.x + FP.width >= worldWidth)
					{
						FP.camera.x = worldWidth - FP.width;
					}
				}
				
				if (FP.height <= worldHeight)
				{
					if (FP.camera.y < 0)
					{
						FP.camera.y = 0;
					}
					else if (FP.camera.y + FP.height >= worldHeight)
					{
						FP.camera.y = worldHeight - FP.height;
					}
				}
			}
			else
			{
				FP.camera.x = FP.camera.x % worldWidth;
				FP.camera.y = FP.camera.y % worldHeight;
			}
		}
		
		protected function getTestY():Number 
		{
			return Input.mouseY;
		}
		
		protected function getTestX():Number
		{
			return Input.mouseX;
		}
		
		private function onEnterRight():void 
		{
			if (!inXBuffer)
			{
				
				inXBuffer = true;
				if (xTween)
				{
					xTween.cancel();
				}
				
				xTween = new VarTween(null, ONESHOT);
				tween.tween(this, "speedX", scrollSpeed, 0.25);
				addTween(xTween, true);
			}
		}
		
		private function onEnterLeft():void 
		{
			if (!inXBuffer)
			{
				inXBuffer = true;
				if (xTween)
				{
					xTween.cancel();
				}
				
				xTween = new VarTween(null, ONESHOT);
				tween.tween(this, "speedX", -scrollSpeed, 0.25);
				addTween(xTween, true);
			}
		}
		
		private function onExitX():void
		{
			if (inXBuffer)
			{
				inXBuffer = false;
				if (xTween)
				{
					xTween.cancel();
				}
				
				xTween = new VarTween(null, ONESHOT);
				xTween.tween(this, "speedX", 0, 1);
				addTween(xTween, true);
			}
		}
		
		private function onEnterBottom():void 
		{
			if (!inYBuffer)
			{
				inYBuffer = true;
				if (yTween)
				{
					yTween.cancel();
				}
				
				yTween = new VarTween(null, ONESHOT);
				tween.tween(this, "speedY", scrollSpeed, 0.25);
				addTween(yTween, true);
			}
		}
		
		private function onEnterTop():void 
		{
			if (!inYBuffer)
			{
				inYBuffer = true;
				if (yTween)
				{
					yTween.cancel();
				}
				
				yTween = new VarTween(null, ONESHOT);
				tween.tween(this, "speedY", -scrollSpeed, 0.25);
				addTween(yTween, true);
			}
		}
		
		private function onExitY():void
		{
			if (inYBuffer)
			{
				inYBuffer = false;
				if (yTween)
				{
					yTween.cancel();
				}
				
				yTween = new VarTween(null, ONESHOT);
				yTween.tween(this, "speedY", 0, 1);
				addTween(yTween, true);
			}
		}
	}

}