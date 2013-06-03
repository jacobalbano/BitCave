package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import tilelighting.TileLight;
	import tilelighting.TileLighting;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Campfire extends XMLEntity 
	{
		private var flames:Emitter;
		private var isLit:Boolean;
		private var player:Player;
		private var light:TileLight;
		
		public function Campfire(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
			this.graphic = new Image(Library.getImage("graphics.dungeon.kindling.png").bitmapData);
			(graphic as Image).scale = .5;
			type = "campfire";
			setHitbox(32, 32);
			
			isLit = false;
			
			flames = new Emitter(new BitmapData(4, 4, true, 0xFFFF9900), 4, 4);
			flames.newType("flame", [0]);
			flames.setMotion("flame", 60, 32, 1, 70, 8, .25);
			flames.setAlpha("flame", 1, 0);
			flames.setColor("flame", 0xFFFFFF00, 0xFFFF5500);
			
			addResponse(TileLighting.RECIEVE_LIGHT, onRecieveLight);
		}
		
		private function onRecieveLight(args:Array):void 
		{
			light = args[0] as TileLight;
			if (light != null)
			{
				light.brightness = 2;
				light.falloff = 4;
				light.radius = 10;
			}
		}
		
		override public function added():void 
		{
			super.added();
			
			player = world.getInstance("player");
			world.addGraphic(flames);
		}
		
		override public function update():void 
		{
			super.update();
			
			getLight();
			
			if (FP.distance(x, y, player.x, player.y) <= 128)
			{
				light.enabled = true;
				player.bodyTemperature += 0.001;
				flames.emit("flame", centerX, centerY + 4);
			}
			else
			{
				light.enabled = false;
			}
		}
		
		private function getLight():void 
		{
			if (light == null)
			{
				broadcastMessage(TileLighting.REQUEST_LIGHT, this);
			}
			else
			{
				light.column = Math.floor(x / DungeonGenerator.TILE_SIZE);
				light.row = Math.floor(y / DungeonGenerator.TILE_SIZE);
			}
		}
	}

}