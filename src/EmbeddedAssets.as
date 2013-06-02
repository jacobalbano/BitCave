package
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.ByteArray;
	
	/**
	* Generated with LibraryBuilder for FLAKit
	* http://www.thaumaturgistgames.com/FLAKit
	*/
	public class EmbeddedAssets
	{
		[Embed(source = "../lib/graphics/backdrop1.png")] private const FLAKIT_ASSET$52606051:Class;
		[Embed(source = "../lib/graphics/backdrop2.png")] private const FLAKIT_ASSET$59749475:Class;
		[Embed(source = "../lib/graphics/backdropStatic.png")] private const FLAKIT_ASSET$322591374:Class;
		[Embed(source = "../lib/graphics/dude.png")] private const FLAKIT_ASSET$440930714:Class;
		[Embed(source = "../lib/graphics/houseExterior.png")] private const FLAKIT_ASSET$39783439:Class;
		[Embed(source = "../lib/graphics/houseInterior.png")] private const FLAKIT_ASSET$2099549051:Class;
		[Embed(source = "../lib/graphics/inventory.png")] private const FLAKIT_ASSET$1470039683:Class;
		[Embed(source = "../lib/graphics/kindling.png")] private const FLAKIT_ASSET$_1853219409:Class;
		[Embed(source = "../lib/graphics/lipstick.png")] private const FLAKIT_ASSET$_558759954:Class;
		[Embed(source = "../lib/graphics/loveLetter.png")] private const FLAKIT_ASSET$_2005218760:Class;
		[Embed(source = "../lib/graphics/photo.png")] private const FLAKIT_ASSET$_1352081153:Class;
		[Embed(source = "../lib/graphics/ring.png")] private const FLAKIT_ASSET$983178900:Class;
		[Embed(source = "../lib/graphics/roses.png")] private const FLAKIT_ASSET$_727175355:Class;
		[Embed(source = "../lib/graphics/tiles.png")] private const FLAKIT_ASSET$_500502085:Class;
		[Embed(source = "../lib/audio/jetpack.mp3")] private const FLAKIT_ASSET$37703755:Class;
		[Embed(source = "../lib/Library.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_1371418527:Class;
		
		public function EmbeddedAssets()
		{
			Library.addImage(new String("graphics/backdrop1.png").split("/").join("."), new FLAKIT_ASSET$52606051);
			Library.addImage(new String("graphics/backdrop2.png").split("/").join("."), new FLAKIT_ASSET$59749475);
			Library.addImage(new String("graphics/backdropStatic.png").split("/").join("."), new FLAKIT_ASSET$322591374);
			Library.addImage(new String("graphics/dude.png").split("/").join("."), new FLAKIT_ASSET$440930714);
			Library.addImage(new String("graphics/houseExterior.png").split("/").join("."), new FLAKIT_ASSET$39783439);
			Library.addImage(new String("graphics/houseInterior.png").split("/").join("."), new FLAKIT_ASSET$2099549051);
			Library.addImage(new String("graphics/inventory.png").split("/").join("."), new FLAKIT_ASSET$1470039683);
			Library.addImage(new String("graphics/kindling.png").split("/").join("."), new FLAKIT_ASSET$_1853219409);
			Library.addImage(new String("graphics/lipstick.png").split("/").join("."), new FLAKIT_ASSET$_558759954);
			Library.addImage(new String("graphics/loveLetter.png").split("/").join("."), new FLAKIT_ASSET$_2005218760);
			Library.addImage(new String("graphics/photo.png").split("/").join("."), new FLAKIT_ASSET$_1352081153);
			Library.addImage(new String("graphics/ring.png").split("/").join("."), new FLAKIT_ASSET$983178900);
			Library.addImage(new String("graphics/roses.png").split("/").join("."), new FLAKIT_ASSET$_727175355);
			Library.addImage(new String("graphics/tiles.png").split("/").join("."), new FLAKIT_ASSET$_500502085);
			Library.addSound(new String("audio/jetpack.mp3").split("/").join("."), new FLAKIT_ASSET$37703755);
			Library.addXML(new String("Library.xml").split("/").join("."), getXML(FLAKIT_ASSET$_1371418527));
		}
		private function getXML(c:Class):XML{var d:ByteArray = new c;var s:String = d.readUTFBytes(d.length);return new XML(s);}
	}
}
