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
		[Embed(source = "../lib/graphics/dude.png")] private const FLAKIT_ASSET$440930714:Class;
		[Embed(source = "../lib/graphics/inventory.png")] private const FLAKIT_ASSET$1470039683:Class;
		[Embed(source = "../lib/graphics/lighting.png")] private const FLAKIT_ASSET$_91208009:Class;
		[Embed(source = "../lib/graphics/map.png")] private const FLAKIT_ASSET$_1820201831:Class;
		[Embed(source = "../lib/graphics/testBackdrop.png")] private const FLAKIT_ASSET$_918861568:Class;
		[Embed(source = "../lib/graphics/house/indoor.png")] private const FLAKIT_ASSET$635852750:Class;
		[Embed(source = "../lib/graphics/house/letter.png")] private const FLAKIT_ASSET$643860955:Class;
		[Embed(source = "../lib/graphics/house/lipstick.png")] private const FLAKIT_ASSET$1266961385:Class;
		[Embed(source = "../lib/graphics/house/outdoor.png")] private const FLAKIT_ASSET$_2051456371:Class;
		[Embed(source = "../lib/graphics/house/photo.png")] private const FLAKIT_ASSET$1772776841:Class;
		[Embed(source = "../lib/graphics/house/ring.png")] private const FLAKIT_ASSET$_539999924:Class;
		[Embed(source = "../lib/graphics/house/roses.png")] private const FLAKIT_ASSET$20446495:Class;
		[Embed(source = "../lib/graphics/dungeon/backdrop1.png")] private const FLAKIT_ASSET$197345101:Class;
		[Embed(source = "../lib/graphics/dungeon/backdrop2.png")] private const FLAKIT_ASSET$199507789:Class;
		[Embed(source = "../lib/graphics/dungeon/backdropStatic.png")] private const FLAKIT_ASSET$846475593:Class;
		[Embed(source = "../lib/graphics/dungeon/kindling.png")] private const FLAKIT_ASSET$2035546594:Class;
		[Embed(source = "../lib/graphics/dungeon/lipstick.png")] private const FLAKIT_ASSET$489575611:Class;
		[Embed(source = "../lib/graphics/dungeon/loveLetter.png")] private const FLAKIT_ASSET$1858266453:Class;
		[Embed(source = "../lib/graphics/dungeon/photo.png")] private const FLAKIT_ASSET$2023039996:Class;
		[Embed(source = "../lib/graphics/dungeon/ring.png")] private const FLAKIT_ASSET$_815811649:Class;
		[Embed(source = "../lib/graphics/dungeon/roses.png")] private const FLAKIT_ASSET$1341214596:Class;
		[Embed(source = "../lib/graphics/dungeon/tiles.png")] private const FLAKIT_ASSET$_1731132538:Class;
		[Embed(source = "../lib/audio/jetpack.mp3")] private const FLAKIT_ASSET$37703755:Class;
		[Embed(source = "../lib/Library.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_1371418527:Class;
		
		public function EmbeddedAssets()
		{
			Library.addImage(new String("graphics/dude.png").split("/").join("."), new FLAKIT_ASSET$440930714);
			Library.addImage(new String("graphics/inventory.png").split("/").join("."), new FLAKIT_ASSET$1470039683);
			Library.addImage(new String("graphics/lighting.png").split("/").join("."), new FLAKIT_ASSET$_91208009);
			Library.addImage(new String("graphics/map.png").split("/").join("."), new FLAKIT_ASSET$_1820201831);
			Library.addImage(new String("graphics/testBackdrop.png").split("/").join("."), new FLAKIT_ASSET$_918861568);
			Library.addImage(new String("graphics/house/indoor.png").split("/").join("."), new FLAKIT_ASSET$635852750);
			Library.addImage(new String("graphics/house/letter.png").split("/").join("."), new FLAKIT_ASSET$643860955);
			Library.addImage(new String("graphics/house/lipstick.png").split("/").join("."), new FLAKIT_ASSET$1266961385);
			Library.addImage(new String("graphics/house/outdoor.png").split("/").join("."), new FLAKIT_ASSET$_2051456371);
			Library.addImage(new String("graphics/house/photo.png").split("/").join("."), new FLAKIT_ASSET$1772776841);
			Library.addImage(new String("graphics/house/ring.png").split("/").join("."), new FLAKIT_ASSET$_539999924);
			Library.addImage(new String("graphics/house/roses.png").split("/").join("."), new FLAKIT_ASSET$20446495);
			Library.addImage(new String("graphics/dungeon/backdrop1.png").split("/").join("."), new FLAKIT_ASSET$197345101);
			Library.addImage(new String("graphics/dungeon/backdrop2.png").split("/").join("."), new FLAKIT_ASSET$199507789);
			Library.addImage(new String("graphics/dungeon/backdropStatic.png").split("/").join("."), new FLAKIT_ASSET$846475593);
			Library.addImage(new String("graphics/dungeon/kindling.png").split("/").join("."), new FLAKIT_ASSET$2035546594);
			Library.addImage(new String("graphics/dungeon/lipstick.png").split("/").join("."), new FLAKIT_ASSET$489575611);
			Library.addImage(new String("graphics/dungeon/loveLetter.png").split("/").join("."), new FLAKIT_ASSET$1858266453);
			Library.addImage(new String("graphics/dungeon/photo.png").split("/").join("."), new FLAKIT_ASSET$2023039996);
			Library.addImage(new String("graphics/dungeon/ring.png").split("/").join("."), new FLAKIT_ASSET$_815811649);
			Library.addImage(new String("graphics/dungeon/roses.png").split("/").join("."), new FLAKIT_ASSET$1341214596);
			Library.addImage(new String("graphics/dungeon/tiles.png").split("/").join("."), new FLAKIT_ASSET$_1731132538);
			Library.addSound(new String("audio/jetpack.mp3").split("/").join("."), new FLAKIT_ASSET$37703755);
			Library.addXML(new String("Library.xml").split("/").join("."), getXML(FLAKIT_ASSET$_1371418527));
		}
		private function getXML(c:Class):XML{var d:ByteArray = new c;var s:String = d.readUTFBytes(d.length);return new XML(s);}
	}
}
