package com.thaumaturgistgames.welcomehome
{
	import com.thaumaturgistgames.flakit.Engine;
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.flakit.loader.ImageLoader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
    import flash.geom.Matrix;
    import flash.events.MouseEvent;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.TiledSpritemap;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import tilelighting.TileLighting;
	import net.flashpunk.Sfx;
    
    //CLICK TO GENERATE A NEW MAZE!
    public class DungeonGenerator extends Sprite
    {
		private var keys:Array;
		private var tf:TextField;
		private var roofs:Array;
		private var floors:Array;
        //Dungeon settings
        public const MAZE_WIDTH:int = 10;
        public const MAZE_HEIGHT:int = 7;
        public const DUNGEON_EXPAND:int = 3;
        public const PASS_1:int = 0;
        public const PASS_2:int = 1;
		public const PASS_3:int = 1;
        
        //Directional constants
        public const RIGHT:uint = 0;
        public const LEFT:uint = 1;
        public const DOWN:uint = 2;
        public const UP:uint = 3;
		static public const ROCK:Number = 0x5F5F5F;
		static public const WATER:Number = 0x0080FF;
		static public const AIR:Number = 0x000000;
		static public const CAMPFIRE:Number = 0xFF9900;
		static public const MEMENTO:Number = 0x00FF00;
		static public const TILE_SIZE:Number = 32;
        
        public var data:BitmapData;
        
        public function DungeonGenerator()
        {
            generate();
        }
		
        public function generate():void
        {
            data = createMaze(MAZE_WIDTH, MAZE_HEIGHT);
            data = carveDungeon(data, DUNGEON_EXPAND, PASS_1, PASS_2, PASS_3);
			var bottom:int = 0;
			
			for (var j:int = 0; j < data.height; j++)
			{
				for (var i:int = 0; i < data.width; i++)
				{
					if (data.getPixel(i, j) == 0xFFFFFF)
					{
						data.setPixel(i,j, ROCK);
					}
					
					if (data.getPixel(i, j) == AIR)
					{
						bottom = j;
					}
				}
			}
			
			roofs = [];
			floors = [];
			
			for (j = 0; j < data.height; j++)
			{
				for (i = 0; i < data.width; i++)
				{
					if (j + 1 < data.height
						&& j - 1 >= 0
						&& data.getPixel(i, j) == ROCK
						&& data.getPixel(i, j + 1) == AIR
						&& data.getPixel(i, j - 1) == AIR)
					{
						data.setPixel(i, j, 0xFF0000);
						continue;
					}
					
					if (data.getPixel(i, j) == AIR && j >= bottom - 15)
					{
						data.setPixel(i, j, WATER);
						continue;
					}
					
					if (data.getPixel(i, j) == ROCK && data.getPixel(i, j + 1) == AIR)
					{
						roofs.push(new Point(i, j));
						continue;
					}
				}
			}
			
			var count:int = 1;
			FP.shuffle(roofs);
			roofs.length = FP.rand(20) + 5;
			for (var k:int = 0; k < roofs.length; k++) 
			{
				var p:Point = roofs[k];
				startWaterfall(p.x, p.y, false);
			}
			
			for (j = 0; j < data.height; j++)
			{
				for (i = 0; i < data.width; i++)
				{
					if (i > 0 && j > 0 && data.getPixel(i, j) == ROCK && data.getPixel(i, j - 1) == AIR)
					{
						floors.push(new Point(i, j));
						continue;
					}
				}
			}
			
			if (floors.length == 0)
			{
				generate();
			}
			
			// Spawn campfires
			FP.shuffle(floors);
			for (var l:int = 0; l < 6; l++) 
			{
				p = floors[l];
				data.setPixel(p.x, p.y, CAMPFIRE);
			}
			
			// Spawn mementos
			for (var m:int = 6; m < 11; m++)
			{
				p = floors[m];
				data.setPixel(p.x, p.y, MEMENTO);
			}
        }
		
		private function startWaterfall(i:int, j:int, startHorizontal:Boolean = false):void 
		{
			if (!startHorizontal)
			{
				data.setPixel(i, j + 1, WATER);
				++j;
			}
			
			while (true)
			{
				if (i > data.width || j > data.height)
				{
					return;
				}
				
				if (data.getPixel(i, j + 1) == ROCK)
				{
					if (i > 0 && data.getPixel(i - 1, j) == AIR)
					{
						startWaterfall(i - 1, j - 1, true);
					}
					
					if (i < data.width && data.getPixel(i + 1, j) == AIR)
					{
						startWaterfall(i + 1, j - 1, true);
					}
					
					break;
				}
				else
				{
					data.setPixel(i, ++j, WATER);
				}
			}
		}
        
        public function carveDungeon(maze:BitmapData, expand:int, ...mins):BitmapData
        {
            for each (var min:int in mins)
                maze = fractal(maze, expand, min);
            return maze;
        }
        
        public function fractal(data:BitmapData, exp:int, min:int):BitmapData
        {
            data = expand(data, exp);
            data = erode(data);
            if (min >= 0)
                data = clean(data, min);
            return data;
        }
        
        public function clean(data:BitmapData, min:int):BitmapData
        {
            var copy:BitmapData = data.clone();
            for (var x:int = 1; x < data.width - 1; x++)
            {
                for (var y:int = 1; y < data.height - 1; y++)
                {
                    if (getTile(data, x, y))
                    {
                        var count:int = 0;
                        if (getTile(data, x + 1, y))
                            count++;
                        if (getTile(data, x - 1, y))
                            count++;
                        if (getTile(data, x, y + 1))
                            count++;
                        if (getTile(data, x, y - 1))
                            count++;
                        if (count <= min)
                            setTile(copy, x, y, false);
                    }
                }
            }
            return copy;
        }
        
        public function erode(data:BitmapData):BitmapData
        {
            var copy:BitmapData = data.clone();
            var w:int = data.width - 1;
            var h:int = data.height - 1;
            var fill:Array = [];
            
            for (var x:int = 0; x < data.width; x++)
            {
                for (var y:int = 0; y < data.height; y++)
                {
                    if (!getTile(data, x, y))
                    {
                        fill.length = 0;
                        fill.push(getTile(data, x - 1, y));
                        fill.push(getTile(data, x + 1, y));
                        fill.push(getTile(data, x, y - 1));
                        fill.push(getTile(data, x, y + 1));
                        fill.push(getTile(data, x + 1, y + 1));
                        fill.push(getTile(data, x - 1, y - 1));
                        fill.push(getTile(data, x + 1, y - 1));
                        fill.push(getTile(data, x - 1, y + 1));
                        
                        if (fill[int(FP.random * fill.length)])
                            setTile(copy, x, y, true);
                        else
                            setTile(copy, x, y, false);
                    }
                }
            }
            
            return copy;
        }
        
        public function expand(data:BitmapData, scale:int):BitmapData
        {
            var newData:BitmapData = createData(data.width * scale, data.height * scale);
            newData.draw(data, new Matrix(scale, 0, 0, scale));
            return newData;
        }
        
        public function createMaze(width:int, height:int):BitmapData
        {
            var data:BitmapData = createData(width, height);
            var xStack:Array = [];
            var yStack:Array = [];
            var sides:Array = [];
            
            data.fillRect(data.rect, 0xFFFFFFFF);
            
            //Pick random start point
            var x:int = 1 + int(FP.random * (width / 2)) * 2;
            var y:int = 1 + int(FP.random * (height / 2)) * 2;
            xStack.push(x);
            yStack.push(y);
            
            //Maze generation loop
            while (xStack.length > 0)
            {
                x = xStack[xStack.length - 1];
                y = yStack[yStack.length - 1];
                sides.length = 0;
                
                if (getTile(data, x + 2, y))
                    sides.push(RIGHT);
                if (getTile(data, x - 2, y))
                    sides.push(LEFT);
                if (getTile(data, x, y + 2))
                    sides.push(DOWN);
                if (getTile(data, x, y - 2))
                    sides.push(UP);
                
                if (sides.length > 0)
                {
                    var side:int = sides[int(FP.random * sides.length)];
                    switch (side)
                    {
                        case RIGHT:
                            setTile(data, x + 1, y, false);
                            setTile(data, x + 2, y, false);
                            xStack.push(x + 2);
                            yStack.push(y);
                            break;
                        case LEFT:
                            setTile(data, x - 1, y, false);
                            setTile(data, x - 2, y, false);
                            xStack.push(x - 2);
                            yStack.push(y);
                            break;
                        case DOWN:
                            setTile(data, x, y + 1, false);
                            setTile(data, x, y + 2, false);
                            xStack.push(x);
                            yStack.push(y + 2);
                            break;
                        case UP:
                            setTile(data, x, y - 1, false);
                            setTile(data, x, y - 2, false);
                            xStack.push(x);
                            yStack.push(y - 2);
                            break;
                    }
                }
                else
                {
                    xStack.pop();
                    yStack.pop();
                }
            }
            
            return data;
        }
        
        public function createData(width:int, height:int):BitmapData
        {
            return new BitmapData(width, height, false, 0xFFFFFF);
        }
        
        public function getTile(data:BitmapData, x:int, y:int):Boolean
        {
            if (x < 0 || y < 0 || x >= data.width || y >= data.height)
                return false;
            return data.getPixel(x, y) > AIR;
        }
        
        public function setTile(data:BitmapData, x:int, y:int, solid:Boolean):void
        {
            data.setPixel(x, y, solid ? 0xFFFFFF : AIR);
        }
		
		public function get lighting():TileLighting
		{
			var lighting:TileLighting = new TileLighting(Library.getImage("graphics.lighting.png").bitmapData, data.width * TILE_SIZE, data.height * TILE_SIZE, TILE_SIZE, TILE_SIZE);
			lighting.autoUpdate = true;
			
			for (var i:int = 0; i < data.width; i++) 
			{
				for (var j:int = 0; j < data.height; j++) 
				{
					var pixel:uint = data.getPixel(i, j);
					
					switch (pixel) 
					{
						case ROCK:
							lighting.setBlockLight(i, j, true);
							break;
						default:
					}
				}
			}
			
			return lighting;
		}
		
		public function get spawnPoint():Point
		{
			var p:Point = FP.choose(floors).clone();
			p.x *= TILE_SIZE;
			p.y *= TILE_SIZE;
			
			p.x += TILE_SIZE / 2;
			p.y -= TILE_SIZE / 2;
			return p;
		}
		
		public function get water():Entity
		{
			var tiles:Tilemap = new Tilemap(new BitmapData(TILE_SIZE, TILE_SIZE, false, WATER), data.width * TILE_SIZE, data.height * TILE_SIZE, TILE_SIZE, TILE_SIZE);
			var grid:Grid = new Grid(data.width * TILE_SIZE, data.height * TILE_SIZE, TILE_SIZE, TILE_SIZE);
			for (var i:int = 0; i < data.width; i++) 
			{
				for (var j:int = 0; j < data.height; j++) 
				{
					if (data.getPixel(i, j) == WATER)
					{
						tiles.setTile(i, j, 0);
						grid.setTile(i, j, true);
					}
				}
			}
			
			tiles.alpha = 0.5;
			var e:Entity = new Entity(0, 0, tiles, grid);
			e.type = "water";
			return e;
		}
		
		public function get cave():Entity 
		{
			var tiles:Tilemap = new Tilemap(Library.getImage("graphics.dungeon.tiles.png").bitmapData, data.width * TILE_SIZE, data.height * TILE_SIZE, 32, 32);
			
			for (var i:int = 0; i < data.width; i++) 
			{
				for (var j:int = 0; j < data.height; j++) 
				{
					var pixel:uint = data.getPixel(i, j);
					
					switch (pixel) 
					{
						case ROCK:
							tiles.setTile(i, j, 1);
							break;
						default:
					}
				}
			}
			
			var e:Entity = new Entity(0, 0, tiles, tiles.createGrid([1]))
			e.type = "cave";
			
			return e;
		}
		
		public function get minimap():Image
		{
				var bmp:BitmapData = data.clone();
				
				for (var i:int = 0; i < bmp.width; i++) 
				{
						for (var j:int = 0; j < bmp.height; j++) 
						{
								switch (data.getPixel(i, j)) 
								{
										case 0xFF0000:
											bmp.setPixel(i, j, ROCK);
												break;
										default:
												break;
								}
						}
				}
				
				return new Image(bmp);
		}
		
		public function get campfires():Vector.<Campfire>
		{
			var result:Vector.<Campfire> = new Vector.<Campfire>();
			
			for (var i:int = 0; i < data.width; i++) 
			{
				for (var j:int = 0; j < data.height; j++) 
				{
					if (data.getPixel(i, j) == CAMPFIRE)
					{
						result.push(new Campfire(i * TILE_SIZE, j * TILE_SIZE));
					}
				}
			}
			
			return result;
		}
		
		public function get mementos():Vector.<Entity>
		{
			var result:Vector.<Entity> = new Vector.<Entity>();
			var assets:Array = new Array("lipstick", "loveLetter", "photo", "ring", "roses");
			FP.shuffle(assets);
			
			for (var i:int = 0; i < data.width; i++) 
			{
				for (var j:int = 0; j < data.height; j++) 
				{
					if (data.getPixel(i, j) == MEMENTO)
					{
						var m:Memento = new Memento(assets.pop(), i * TILE_SIZE + (TILE_SIZE / 2), j * TILE_SIZE + (TILE_SIZE / 2));
						result.push(m);
					}
				}
			}
			
			return result;
		}
		
		public function get bounds():Vector.<Entity>
		{
			var result:Vector.<Entity> = new Vector.<Entity>();
			var tiles:BitmapData = Library.getImage("graphics.dungeon.tiles.png").bitmapData;
			
			// 		Left
			var lt:Tilemap = new Tilemap(tiles, TILE_SIZE * 20, TILE_SIZE * data.height, TILE_SIZE, TILE_SIZE);
			lt.floodFill(0, 0, 1);
			
			var l:Entity = new Entity( -lt.width, 0, lt);
			l.setHitbox(lt.width, TILE_SIZE, lt.width - TILE_SIZE);
			
			//		Right
			var rt:Tilemap = new Tilemap(tiles, TILE_SIZE * 20, TILE_SIZE * data.height, TILE_SIZE, TILE_SIZE);
			rt.floodFill(0, 0, 1);
			
			var r:Entity = new Entity((data.width * TILE_SIZE), 0, rt);
			r.setHitbox(TILE_SIZE, rt.height);
			
			//		Bottom
			var bt:Tilemap = new Tilemap(tiles , TILE_SIZE * data.width, TILE_SIZE * 20, TILE_SIZE, TILE_SIZE);
			bt.floodFill(0, 0, 1);
			
			var b:Entity = new Entity(0, data.height * TILE_SIZE, bt);
			b.setHitbox(bt.width, TILE_SIZE);
			
			b.type = l.type = r.type = "cave";
			
			result.push(l);
			result.push(r);
			result.push(b);
			
			return result;
		}
    }
}