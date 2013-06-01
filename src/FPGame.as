package  
{
	import com.jacobalbano.broadway.*
	import com.jacobalbano.slang.*;
	import com.jacobalbano.punkutils.*;
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.welcomehome.DungeonGenerator;
	import net.flashpunk.FP;
	import net.flashpunk.Engine;
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
			
			FP.stage.addChild(new DungeonGenerator());
		}
	}

}