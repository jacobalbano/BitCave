package  
{
	import com.jacobalbano.broadway.*
	import com.jacobalbano.slang.*;
	import com.jacobalbano.punkutils.*;
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.welcomehome.Campfire;
	import com.thaumaturgistgames.welcomehome.DungeonGenerator;
	import com.thaumaturgistgames.welcomehome.Inventory;
	import com.thaumaturgistgames.welcomehome.MiniMap;
	import com.thaumaturgistgames.welcomehome.OutsideWorld;
	import com.thaumaturgistgames.welcomehome.Player;
	import com.thaumaturgistgames.welcomehome.Thermometer;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Engine;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Key;
	import tilelighting.TileLighting;
	
	/**
	 * @author Jacob Albano
	 */
	
	public class FPGame extends Engine 
	{
		private var oWorld:OgmoWorld;
		
		public function FPGame() 
		{
			super(640, 480);
			FP.screen.color = 0x0;
		}
		
		override public function init():void 
		{
			super.init();
			
			FP.world = oWorld = new OgmoWorld();
			restart();
		}
		
		private function restart():void 
		{
			CONFIG::debug {
				FP.console.enable();
				FP.console.toggleKey = Key.F1;
			}
			
			Game.instance.onReload = restart;
			//	init stuff here
			
			oWorld.removeAll();
			
			var bd1:Backdrop = new Backdrop(Library.getImage("graphics.dungeon.backdropStatic.png").bitmapData, false, false);
			bd1.scrollX = bd1.scrollY = 0;
			oWorld.addGraphic(bd1);
			
			var bd2:Backdrop = new Backdrop(Library.getImage("graphics.dungeon.backdrop2.png").bitmapData);
			bd2.scrollX = 0.04;
			bd2.scrollY = 0.04;
			bd1.alpha = 0.75;
			oWorld.addGraphic(bd2);
			
			var bd3:Backdrop = new Backdrop(Library.getImage("graphics.dungeon.backdrop1.png").bitmapData, true, false);
			bd3.scrollX = 0.05;
			bd3.scrollY = 0;
			oWorld.addGraphic(bd3);
			
			var dungeon:DungeonGenerator = new DungeonGenerator();
			oWorld.add(dungeon.cave);
			var p:Point = dungeon.spawnPoint;
			
			var player:Player = new Player(p.x, p.y, true);
			oWorld.add(player);
			
			oWorld.add(dungeon.water);
			
			for each (var fire:Campfire in dungeon.campfires) 
			{
				oWorld.add(fire);
			}
			
			for each (var memento:Entity in dungeon.mementos) 
			{
				oWorld.add(memento);
			}
			
			for each (var bound:Entity in dungeon.bounds)
			{
				oWorld.add(bound);
			}
			
			oWorld.add(dungeon.lighting);
			oWorld.add(dungeon.trigger);
			
			oWorld.add(new MiniMap(dungeon.minimap));
		}
	}

}