package tilelighting 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	/**
	 * ...
	 * @author alex larioza
	 */
	public class TileLighting extends XMLEntity
	{
		static public const REQUEST_LIGHT:String = "requestLight";
		static public const RECIEVE_LIGHT:String = "recieveLight";
		private var _ambientLevel:int;
		/**
		 * The ambient (or global) lighting level.
		 */
		public function get ambientLevel():int { return _ambientLevel; }
		public function set ambientLevel(value:int):void { _ambientLevel = value; }
		
		private var _autoUpdate:Boolean;
		/**
		 * If true, the lighting auto-updates (default). If false, you must call the updateLighting() method manually.
		 */
		public function get autoUpdate():Boolean { return _autoUpdate; }
		public function set autoUpdate(value:Boolean):void { _autoUpdate = value; }
		
		private var _padding:int;
		/**
		 * The amount of tiles to update outside of the screen bounds.
		 */
		public function get padding():int { return _padding; }
		public function set padding(value:int):void { _padding = value; }
		
		private var _count:int;
		/**
		 * The current number of lights (enabled and disabled)
		 */
		public function get count():int { return _count; }
		
		private var _screenColumns:int;
		private var _screenRows:int;
		private var _maxLightLevel:int;
		private var _lights:Dictionary;
		private var _tiles:Tilemap;
		private var _grid:Grid;
		
		/**
		 * Creates a new tiled lighting entity.
		 * @param	image	The source class to use for lighting. Index 0 must be the darkest tile with following indexes being increasingly brighter.
		 * @param	width	The width (in pixels) of the tilelighting.
		 * @param	height	The height (in pixels) of the tilelighting.
		 * @param	tileWidth	The width of each tile.
		 * @param	tileHeight	The height of each tile.
		 */
		public function TileLighting(image:*, width:Number, height:Number, tileWidth:int, tileHeight:int)
		{
			layer = -50;
			type = "tileLighting";
			
			_count = 0;
			_autoUpdate = true;
			_ambientLevel = 0;
			_padding = 2;
			_screenColumns = Math.floor(FP.screen.width / tileWidth) + _padding;
			_screenRows = Math.floor(FP.screen.height / tileHeight) + _padding;
			_lights = new Dictionary();
			_maxLightLevel = new Image(image).width / tileWidth - 1;
			
			_tiles = new Tilemap(image, width, height, tileWidth, tileHeight);
			_tiles.floodFill(0, 0);
			
			_grid = new Grid(width, height, tileWidth, tileHeight);
			
			graphic = _tiles;
			mask = _grid;
			
			addResponse(REQUEST_LIGHT, onGetLight);
		}
		
		private function onGetLight(args:Array):void 
		{
			var sender:XMLEntity = args[0];
			
			if (sender == null)
			{
				return;
			}
			
			var light:TileLight = new TileLight(0, 0, 0, 3);
			addLight(light);
			sender.onMessage(RECIEVE_LIGHT, light);
		}
		
		/**
		 * Updates the entity.
		 */
		override public function update():void 
		{
			super.update();
			
			if (autoUpdate)
			{
				updateLighting();
			}
		}
		
		/**
		 * Updates the lighting.
		 */
		public function updateLighting():void
		{
			// get camera tile position
			var camX:int = Math.floor(world.camera.x / _tiles.tileWidth);
			var camY:int = Math.floor(world.camera.y / _tiles.tileHeight);
			
			// clamp within level bounds
			camX = FP.clamp(camX, 0, _tiles.columns);
			camY = FP.clamp(camY, 0, _tiles.rows);
			
			// only reset tiles on camera
			_tiles.setRect(camX, camY, _screenColumns, _screenRows, _ambientLevel);
			
			// draw each light
			for each (var light:TileLight in _lights)
			{
				// if not enabled, skip
				if (light.enabled)
				{
					// if not on camera, skip
					if (light.column + light.radius > camX && light.column - light.radius < camX + _screenColumns
					&& light.row + light.radius > camY && light.row - light.radius < camY + _screenRows)
					{
						var xx:int = light.column - light.radius;
						var yy:int = light.row - light.radius;
						var index:int;
						var prevIndex:int;
						
						for (var i:int = xx; i < xx + (light.radius << 1); i++)
						{
							for (var j:int = yy; j < yy + (light.radius << 1); j++)
							{
								// stops tiles from "bleeding over" to the other side of the tile map
								if (i >= 0 && i < _tiles.columns && j >= 0 && j < _tiles.rows) 
								{
									// examine the block
									if (!checkBlock(light.column, light.row, i, j))
									{
										index = Math.ceil(FP.scaleClamp(FP.distance(light.column, light.row, i, j), 0, light.radius, light.brightness + light.falloff, 0));
										prevIndex = _tiles.getTile(i, j);
										_tiles.setTile(i, j, FP.clamp(index + prevIndex, 0, _maxLightLevel));
									}
								}
							}
						}
					}
				}
			}
		}
		
		/**
		 * Checks a tile for collisions
		 * @param	column1
		 * @param	row1
		 * @param	column2
		 * @param	row2
		 * @return
		 */
		private function checkBlock(column1:int, row1:int, column2:int, row2:int):Boolean
		{
			// If the distance is less than 1, just check start point.
			if (FP.distance(column1, row1, column2, row2) < 1)
			{
				return _grid.getTile(column1, row1);
			}
			
			// Get information about the line we're about to raycast.
			var xDelta:int = Math.abs(column2 - column1),
				yDelta:int = Math.abs(row2 - row1),
				xSign:Number = column2 > column1 ? 1 : -1,
				ySign:Number = row2 > row1 ? 1 : -1,
				x:Number = column1, y:Number = row1;
			
			// Do a raycast from the start to the end point.
			if (xDelta > yDelta)
			{
				ySign *= yDelta / xDelta;
				if (xSign > 0)
				{
					while (x < column2)
					{
						if (_grid.getTile(x, y)) return true;
						x += xSign; y += ySign;
					}
				}
				else
				{
					while (x > column2)
					{
						if (_grid.getTile(x, y)) return true;
						x += xSign; y += ySign;
					}
				}
			}
			else
			{
				xSign *= xDelta / yDelta;
				if (ySign > 0)
				{
					while (y < row2)
					{
						if (_grid.getTile(x, y)) return true;
						x += xSign; y += ySign;
					}
				}
				else
				{
					while (y > row2)
					{
						if (_grid.getTile(x, y)) return true;
						x += xSign; y += ySign;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * Adds a light to the tile lighting.
		 * @param	light	The light to add.
		 */
		public function addLight(light:TileLight):void
		{
			_lights[light] = light;
			_count++;
		}
		
		/**
		 * Removes a light from the tile lighting.
		 * @param	light	The light to remove.
		 */
		public function removeLight(light:TileLight):void
		{
			delete _lights[light];
			_count--;
		}
		
		/**
		 * Returns the lighting level (tile index) of the specified tile.
		 * @param	column
		 * @param	row
		 * @return	The light level (tile index)
		 */
		public function getLightLevel(column:int, row:int):int
		{
			return _tiles.getTile(column, row);
		}
		
		/**
		 * Sets the specified rectangle of tiles to block light.
		 * @param	column	Column of top-left tile
		 * @param	row		Row of top-left tile.
		 * @param	width	Width of the rectangle.
		 * @param	height	Height of the rectangle.
		 * @param	blockLight	Set true if the tiles in the rectangle should block light and false if otherwise.
		 */
		public function setBlockLightRect(column:int, row:int, width:int, height:int, blockLight:Boolean = true):void
		{
			_grid.setRect(column, row, width, height, blockLight);
		}
		
		/**
		 * Sets the specified tile to block light.
		 * @param	column	The column of the tile.
		 * @param	row		The row of the tile.
		 * @param	blockLight	Set true if the tiles in the rectangle should block light and false if otherwise.
		 */
		public function setBlockLight(column:int, row:int, blockLight:Boolean = true):void
		{
			_grid.setTile(column, row, blockLight);
		}
	}

}