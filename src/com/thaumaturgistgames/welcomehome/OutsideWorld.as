package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.OgmoWorld;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class OutsideWorld extends OgmoWorld 
	{
		private var ground:Entity;
		
		private const PLAYER_LAYER:int = -1;
		private const INDOOR_LAYER:int = 0;
		private const OUTDOOR_LAYER:int = -2;
		
		private var clouds:Backdrop;
		
		public function OutsideWorld(mementos:Array) 
		{
			super();
			
			makeBackdrops(mementos.length <= 0 ? 1 : mementos.length >= 5 ? 5 : mementos.length);
			
			var player:Entity = add(new Player(100, 400, false));
			player.layer = PLAYER_LAYER;	//	lol a poem
			
			add(new House(400, 226, mementos));
			
			var e:Entity = addGraphic(Image.createRect(FP.width, FP.height));
			e.layer = -1000;
			e.graphic.scrollX = e.graphic.scrollY = 0;
			var tween:VarTween = new VarTween(function():void { remove(e); }, ONESHOT);
			tween.tween(e.graphic, "alpha", 0, 2);
			addTween(tween, true);
		}
		
		override public function update():void 
		{
			super.update();
			
			camera.y = 0;
			ground.x = camera.x;
			clouds.x += 0.05;
		}
		
		private function makeBackdrops(mementos:uint):void 
		{
			var i:uint = mementos;
			
			var bd1:Backdrop = new Backdrop(Library.getImage("graphics.landscapes." + i + ".sky.png").bitmapData, false, false);
			bd1.scrollX = bd1.scrollY = 0;
			addGraphic(bd1);
			
			
			clouds = new Backdrop(Library.getImage("graphics.landscapes." + i + ".clouds.png").bitmapData, true, false);
			clouds.scrollX = 0.04;
			clouds.scrollY = 0;
			addGraphic(clouds);
			
			var title:Image = new Image(Library.getImage("graphics.title.png").bitmapData);
			title.scrollX = bd1.scrollY = 0;
			title.centerOrigin();
			title.x = FP.screen.width / 2;
			title.y = title.height / 2;
			addGraphic(title);
			
			var bd3:Backdrop = new Backdrop(Library.getImage("graphics.landscapes." + i + ".ground.png").bitmapData, true, false);
			addGraphic(bd3);
			
			ground = new Entity(0, FP.screen.height - 32);
			ground.setHitbox(FP.screen.width, 32);
			ground.type = "ground";
			add(ground);
		}
		
	}

}