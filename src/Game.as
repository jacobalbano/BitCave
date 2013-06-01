package
{
	import com.thaumaturgistgames.flakit.Engine;
	import com.thaumaturgistgames.flakit.Library;
	
	[Frame(factoryClass = "Preloader")]
	[SWF(width = "800", height = "600")]
	public class Game extends Engine 
	{
		public static var instance:Game;
		public function Game()
		{
			//	Initialize library
			CONFIG::debug {
				super(Library.USE_XML);	
			}
			
			CONFIG::release {
				super(Library.USE_EMBEDDED, EmbeddedAssets);
			}
			
			instance = this;
		}
		
		override public function init():void 
		{
			super.init();
			//	Entry point
			addChild(new FPGame());
		}
	}

}