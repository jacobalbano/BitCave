package  
{
	import com.jacobalbano.broadway.*
	import com.jacobalbano.slang.*;
	import com.jacobalbano.punkutils.*;
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.welcomehome.DungeonGenerator;
	import com.thaumaturgistgames.welcomehome.Inventory;
	import com.thaumaturgistgames.welcomehome.Player;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Engine;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Key;
	
	/**
	 * @author Jacob Albano
	 */
	
	public class FPGame extends Engine 
	{
		private var oWorld:OgmoWorld;
		
		public function FPGame() 
		{
			super(800, 600);
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
			var platform:Entity = new Entity(0, 200);
			platform.setHitbox(500, 20);
			platform.type = "temp";
			oWorld.add(platform);
			
			var dungeon:DungeonGenerator = new DungeonGenerator();
			oWorld.add(dungeon.entity);
			var p:Point = dungeon.spawnPoint;
			
			var inv:Inventory = oWorld.add(new Inventory()) as Inventory;
			oWorld.add(new Player(p.x * 32 + 16, (p.y - 1) * 32 + 16));
		}
	}

}