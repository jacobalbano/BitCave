package com.jacobalbano.punkutils 
{
	import com.jacobalbano.punkutils.DeferredCallback;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.World;
	
	/**
	 * @author Jacob Albano
	 */
	public class OgmoWorld extends World
	{
		private var types:Dictionary;
		private var layerIndices:Dictionary;
		private var numLayers:int;
		private var defaultImage:Bitmap;
		private var canLoad:Boolean;
		
		private var tilesets:Dictionary;
		private var gridTypes:Dictionary;
		
		//public var levelName:String;
		public var wraparound:Boolean;
		public var size:Point;
		
		public function OgmoWorld() 
		{
			super();
			tilesets = new Dictionary;
			types = new Dictionary;
			layerIndices = new Dictionary;
			gridTypes = new Dictionary;
			numLayers = 0;
			size = new Point;
			canLoad = true;
			
			defaultImage = new Bitmap(new BitmapData(100, 100, false, 0xFF0080));
			var flip:Boolean = false;
			
			for (var j:int = 0; j < 10; ++j)
			{
				for (var k:int = -1; k < 10; ++k)
				{
					if (flip = !flip)
					{
						defaultImage.bitmapData.fillRect(new Rectangle(j * 10, k * 10, 10, 10), 0x00000000);
					}
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			canLoad = true;
		}
		
		public function broadcastMessage(message:String, ...args):void
		{
			function f():Boolean
			{
				var all:Array = [];
				getClass(XMLEntity, all);
				
				if (all.length == 0)
				{
					return false;
				}
				
				for each (var item:XMLEntity in all) 
				{
					item.onMessage.apply(item, [message].concat(args));
				}
				
				return true;
			}
			
			if (!f())
			{
				add(new DeferredCallback(f));
			}
		}
		
		/**
		 * Register a class with the scene builder
		 * @param	name	The name to associate with the class
		 * @param	type	The entity class that will be added to the world when the name is found in the level file. It must have a constructor that takes an XML parameter
		 */
		public function addClass(name:String, type:Class):void
		{
			types[name] = type;
		}
		
		/**
		 * Unregister a class from the scene builder
		 * @param	name	The name the class was added with
		 */
		public function removeClass(name:String):void
		{
			delete types[name];
		}
		
		/**
		 * Register a tileset with the scene builder
		 * @param	name	The name of the tileset
		 * @param	image	The bitmap to associate with the name
		 */
		public function addTileset(name:String, image:String, width:Number, height:Number, tileWidth:Number, tileHeight:Number):void
		{
			tilesets[name] = new Tileset(image, width, height, tileWidth, tileHeight);
		}
		
		/**
		 * Unregister a tileset from the scene builder
		 * @param	name	The name the tileset was added with
		 */
		public function removeTileset(name:String):void
		{
			delete tilesets[name];
		}
		
		/**
		 * Register a grid type with the scene builder
		 * @param	name	The name of the grid type
		 * @param	cellWidth	The width of the cell
		 * @param	cellHeight	The height of the cell
		 */
		public function addGridType(name:String, cellWidth:Number, cellHeight:Number):void
		{
			gridTypes[name] = new GridType(cellWidth, cellHeight);
		}
		
		/**
		 * Unregister a grid type from the scene builder
		 * @param	name	The name the type was added with
		 */
		public function removeGridType(name:String):void
		{
			delete gridTypes[name];
		}
		
		/**
		 * Load a world from an Ogmo level in the library
		 * @param	source	The level filename
		 */
		public function buildWorld(source:String):void
        {
            if (!canLoad)
            {
                return;
            }
			
			var level:XML = Library.getXML(source);
			
            removeAll();
            size.x = level.@width;
            size.y = level.@height;
           
			var list:Array = buildWorldAsArray(source);
			trace(list.length);
			addList(list);
           
            canLoad = false;
        }
		
		public function buildWorldAsArray(source:String):Array
		{
			var level:XML = Library.getXML(source);
            var layerNodes:Array = [];
			var result:Array = [];
           
            for each (var layerNode:XML in level.children())
            {
                layerNodes.push(layerNode);
            }
           
            for each (var layer:XML in layerNodes.reverse())
            {
                layerIndices[layer.name()] = ++numLayers;
				
				if (layer.@tileset != undefined)
				{
					result.push(operateOnTilemapLayer(layer));
				}
				else if (layer.@exportMode != undefined)
				{
					result.push(operateOnGridLayer(layer));
				}
				else
				{
					result.push.apply(result, operateOnEntityLayer(layer));
				}
				
            }
			
			return result;
		}
		
		private function operateOnGridLayer(layer:XML):Entity 
		{
			var type:GridType = gridTypes[new String(layer.name())];
			
			if (type == null)
			{
				return null;
			}
			
			var contents:Array = new String(layer).split("\n");
			var gridSize:Point = new Point(contents.length, contents.length > 0 ? contents[0].length : 0);
			
			var grid:Grid = new Grid(gridSize.x * type.cellWidth, gridSize.y * type.cellHeight, type.cellWidth, type.cellHeight);
			grid.loadFromString(new String(layer), "", "\n");
			
			var e:Entity = new Entity(0, 0, null, grid);
			e.type = layer.name();
			e.active = e.visible = false;
			
			return e;
		}
		
		private function operateOnTilemapLayer(layer:XML):Entity 
		{
			var tileset:Tileset = tilesets[new String(layer.@tileset)];
			
			if (tileset == null)
			{
				return null;
			}
			
			var mapSize:Point = new Point();
			var lastRow:int = 0;
			
			for each (var item:XML in layer.tile)
			{
				mapSize.x = Math.max(mapSize.x, item.@x);
				mapSize.y = Math.max(mapSize.y, item.@y);
			}
			
			++mapSize.x;
			mapSize.x *= tileset.tileWidth;
			++mapSize.y;
			mapSize.y *= tileset.tileHeight;
			
			var tilemap:Tilemap = new Tilemap(Library.getImage(tileset.image).bitmapData, mapSize.x, mapSize.y, tileset.tileWidth, tileset.tileHeight);
			
			for each (var tile:XML in layer.tile)
			{
				tilemap.setTile(tile.@x, tile.@y, tile.@id);
			}
			
			var ent:Entity = new Entity(0, 0, tilemap);
			ent.layer = numLayers;
			
			return ent;
		}
		
		private function operateOnEntityLayer(layer:XML):Array 
		{
			var result:Array = [];
			
			for each (var entity:XML in layer.children())
			{
				var ent:Entity;
			   
				var type:Class = types[entity.name()];
				if (!type)
				{
					trace("No entity type registered for", entity.name());
					continue;
				}
				else
				{
					ent = new type();
					if (ent is XMLEntity)
					{
						(ent as XMLEntity).load(entity);
					}
				}
			   
				//    Set up scale and position to match the values in the xml definition
				if (ent.graphic)
				{
					var image:Image = ent.graphic as Image;
					if (image)
					{
						var angle:int = image.angle - entity.@angle;
						var size:Point = new Point(entity.@width, entity.@height);
						
						image.scaleX = size.x / image.width || 1;
						image.scaleY = size.y / image.height || 1;
					}
				}
			   
				ent.layer = numLayers;
				
				result.push(ent);
			   
			}
			
			return result;
		}
		
		override public function begin():void 
		{
			super.begin();
		}
		
		override public function render():void 
		{
			if (wraparound)
			{
				var original:Point = FP.camera.clone();
				
				//	right
				FP.camera.x = original.x + size.x
				super.render();
				
				//	left
				FP.camera.x = original.x - size.x;
				super.render();
				
				// upper left
				FP.camera.x = original.x - size.x;
				FP.camera.y = original.y - size.y;
				super.render();
				
				//lower left
				FP.camera.x = original.x - size.x;
				FP.camera.y = original.y + size.y;
				super.render();
				
				//upper right
				FP.camera.x = original.x + size.x;
				FP.camera.y = original.y - size.y;
				super.render();
				
				// lower right
				FP.camera.x = original.x + size.x;
				FP.camera.y = original.y + size.y;
				super.render();
				
				FP.camera.x = original.x;
				
				//	down
				FP.camera.y = original.y + size.y
				super.render();
				//
				//	up
				FP.camera.y = original.y - size.y;
				super.render();
				
				FP.camera.y = original.y;
			}
			
			super.render();
		}
	}
}