package com.jacobalbano.punkutils 
{
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Tileset extends XMLEntity 
	{
		public var image:String;
		public var tileWidth:Number;
		public var tileHeight:Number;
		
		public function Tileset(image:String, width:Number, height:Number, tileWidth:Number, tileHeight:Number) 
		{
			this.tileHeight = tileHeight;
			this.tileWidth = tileWidth;
			this.height = height;
			this.width = width;
			this.image = image;
		}
		
	}

}