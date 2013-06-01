package com.thaumaturgistgames.welcomehome
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
    import flash.geom.Matrix;
    import flash.events.MouseEvent;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.display.Sprite;
	import flash.text.TextField;
	import flash.ui.Keyboard;
    
    //CLICK TO GENERATE A NEW MAZE!
    public class DungeonGenerator extends Sprite
    {
		private var keys:Array;
		private var tf:TextField;
        //Dungeon settings
        public const MAZE_WIDTH:int = 15;
        public const MAZE_HEIGHT:int = 15;
        public const DUNGEON_EXPAND:int = 3;
        public const PASS_1:int = 0;
        public const PASS_2:int = 1;
		public const PASS_3:int = 1;
        public const DUNGEON_SCALE:int = 4;
        
        //Directional constants
        public const RIGHT:uint = 0;
        public const LEFT:uint = 1;
        public const DOWN:uint = 2;
        public const UP:uint = 3;
		static private const ROCK:Number = 0x5F5F5F;
		static private const WATER:Number = 0x0080FF;
        
        public var data:BitmapData;
        public var bitmap:Bitmap = new Bitmap();
        
        public function DungeonGenerator()
        {
            bitmap.scaleX = bitmap.scaleY = DUNGEON_SCALE;
            addChild(bitmap);
			
			keys = [];
			keys.length = 300;
            
			tf = new TextField();
			addChild(tf);
			tf.mouseEnabled = false;
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, _frame);
			addEventListener(Event.ADDED, _added);
            generate();
        }
		
		//{ region events
		private function _added(e:Event):void 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, _down);
			stage.addEventListener(KeyboardEvent.KEY_UP, _up);
		}
		
		private function _frame(e:Event):void 
		{
			if (keys[Keyboard.A])
			{
				x += 10;
			}
			
			if (keys[Keyboard.D])
			{
				x -= 10;
			}
			
			if (keys[Keyboard.W])
			{
				y += 10;
			}
			
			if (keys[Keyboard.S])
			{
				y -= 10;
			}
			
			tf.text = ["\n\n", Math.floor((mouseX) / DUNGEON_SCALE), Math.floor((mouseY) / DUNGEON_SCALE)].join(" ");
			
			tf.x = mouseX;
			tf.y = mouseY;
		}
		
		private function _down(e:KeyboardEvent):void 
		{
			keys[e.keyCode] = true;
		}
		
		private function _up(e:KeyboardEvent):void 
		{
			keys[e.keyCode] = false;
		}
		
        public function onClick(e:MouseEvent):void
        {
            generate();
        }
		//} endregion
			
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
					
					if (data.getPixel(i, j) == 0x000000)
					{
						bottom = j;
					}
				}
			}
			
			for (j = 0; j < data.height; j++)
			{
				for (i = 0; i < data.width; i++)
				{
					if (j + 1 < data.height
						&& j - 1 >= 0
						&& data.getPixel(i, j) == ROCK
						&& data.getPixel(i, j + 1) == 0x000000
						&& data.getPixel(i, j - 1) == 0x000000)
					{
						data.setPixel(i, j, 0xFF0000);
						trace("found weak rock", i, j);
					}
					
					if (data.getPixel(i, j) == 0x000000 && j >= bottom - 15)
					{
						data.setPixel(i, j, WATER);
					}
				}
			}
			
			var done:Boolean = false;
			
			for (j = 0; j < data.height; j++)
			{
				if (done)
					break;
				
				for (i = 0; i < data.width; i++)
				{
					if (j + 1 > data.height || j - 1 < 0)
					{
						continue;
					}
					
					if (data.getPixel(i, j) == ROCK && data.getPixel(i, j + 1) == 0x000000)
					{
						startWaterfall(i, j + 1);
						done = true;
						break;
					}
				}
			}
			
            bitmap.bitmapData = data;
        }
		
		private function startWaterfall(i:int, j:int):void 
		{
			while (true)
			{
				if (data.getPixel(i, j) == ROCK)
				{
					if (i > 0 && 
				}
				else
				{
					data.setPixel(i, j, WATER);
					++j;
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
            var fill:Array = new Array();
            
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
                        
                        if (fill[int(Math.random() * fill.length)])
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
            var x:int = 1 + int(Math.random() * (width / 2)) * 2;
            var y:int = 1 + int(Math.random() * (height / 2)) * 2;
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
                    var side:int = sides[int(Math.random() * sides.length)];
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
            return data.getPixel(x, y) > 0x000000;
        }
        
        public function setTile(data:BitmapData, x:int, y:int, solid:Boolean):void
        {
            data.setPixel(x, y, solid ? 0xFFFFFF : 0x000000);
        }
    }
}