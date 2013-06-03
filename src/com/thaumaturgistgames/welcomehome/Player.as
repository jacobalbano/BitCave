package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.ParticleType;
	import net.flashpunk.graphics.Spritemap;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import tilelighting.TileLight;
	import tilelighting.TileLighting;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Player extends XMLEntity 
	{
		private const MAX_SPEED:Number = 8;
		private const WATER_SPEED:Number = 3;
		static private const MAX_WET_TIMER:Number = 15;
		private const REG_GRAVITY:Number = .85;
		private const WATER_GRAVITY:Number = .5;
		
		private var movement:Point;
		private var gravity:Number;
		private var speed:Number;
		private var maxSpeed:Number;
		private var jetpackForce:Number;
		
		private var canMove:Boolean;
		private var colliders:Vector.<String>;
		private var animToPlay:String;
		
		private var inventory:Inventory;
		private var canJetpack:Boolean;
		
		private var jetpackSfx:Sfx;
		private var emitter:Emitter;
		private var animation:Spritemap;
		private var wet:Number;
		private var light:TileLight;
		private var hasHud:Boolean;
		
		private var thermometer:Thermometer;
		private var bodyTemp:Number;
		private const REG_TEMP_DEC:Number = 0.000275;
		private const WET_TEMP_DEC:Number = 0.0010;
		private var ambiance:Sfx;
		private var lastPosition:Point;
		
		public function Player(x:Number, y:Number, hasHud:Boolean) 
		{
			super();
			name = "player";
			type = "player";
			wet = 0;
			
			lastPosition = new Point();
			
			animation = new Spritemap(Library.getImage("graphics.dude.png").bitmapData, 64, 64);
			animation.add("idle", [0]);
			animation.add("walk", [0, 1, 2, 3], 8);
			animation.add("pickup", [7]);
			animation.add("jetpackOn", [8, 9, 10, 11], 8);
			animation.add("jetpackIdle", [12]);
			animation.scale = .5;
			
			animToPlay = "idle";
			animation.play(animToPlay);
			
			emitter = new Emitter(new BitmapData(2, 2, false, 0x0080FF));
			emitter.relative = false;
			
			emitter.newType("drip");
			emitter.setGravity("drip", 1);
			emitter.setMotion("drip", 0, 25, 0.5, 360, 0, 0, Ease.quintOut);
			emitter.setAlpha("drip", 1, 0);
			emitter.setColor("drip", 0x0080FF, 0x93C9FFF);
			
			emitter.setSource(new BitmapData(4, 4, false, 0x0080FF));
			emitter.newType("splash");
			emitter.setGravity("splash", 1);
			//	set motion later
			emitter.setAlpha("splash", 1, 0);
			emitter.setColor("splash", 0x0080FF, 0x93C9FFF);
			
			addGraphic(emitter);
			addGraphic(animation);
			
			animation.centerOO();
			this.setHitbox(12, 30);
			centerOrigin();
			
			this.x = x;
			this.y = y;
			
			movement = new Point();
			speed = 4.0;
			gravity = REG_GRAVITY;
			jetpackForce = 1;
			maxSpeed = MAX_SPEED;
			
			canMove = true;
			
			colliders = new Vector.<String>();
			colliders.push("cave", "ground", "houseInterior");
			
			jetpackSfx = new Sfx(Library.getSound("audio.jetpack.mp3"));
			
			addResponse(TileLighting.RECIEVE_LIGHT, onRecieveLight);
			this.hasHud = hasHud;
			
			bodyTemp = 1;
		}
		
		private function getLight():void 
		{
			broadcastMessage(TileLighting.REQUEST_LIGHT, this);
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
			
			if (hasHud)
			{
				world.add(inventory = new Inventory());
				world.add(thermometer = new Thermometer(200, 200));
				ambiance = new Sfx(Library.getSound("audio.ambiance.mp3"));
				ambiance.loop(1);
			}
			
		}
		
		override public function removed():void 
		{
			if (inventory && inventory.world)
			{
				world.remove(inventory);
			}
			
			jetpackSfx.stop();
			ambiance.stop();
			super.removed();
		}
		
		override public function update():void 
		{
			if (thermometer)
			{
				bodyTemperature -= REG_TEMP_DEC;
				
				if (bodyTemperature <= 0)
				{
					Game.instance.onReload();
				}
			}
			
			super.update();
			
			FP.camera.x = x - FP.halfWidth;
			FP.camera.y = y - FP.halfHeight;
			
			movement.x = 0;
			
			if (canMove)
			{
				if (Input.check(Key.D))
				{
					movement.x += speed;
				}
				
				if (Input.check(Key.A))
				{
					movement.x += -speed;
				}
			}
			
			animToPlay = movement.x == 0 ? "idle" : "walk";
			
			if (Input.pressed(Key.SPACE))
			{
				if (collideTypes(["cave", "ground", "houseInterior"], x, y + 1))
				{
					jump();
				}
				else
				{
					canJetpack = true;
				}
			}
			
			if (Input.check(Key.SPACE))
			{
				if (canJetpack)
				{
					movement.y -= jetpackForce;
					animToPlay = "jetpackOn";
					//maxSpeed = MAX_SPEED;
				}
			}
			
			if (Input.pressed(Key.SPACE))
			{
				if (canJetpack)
				{
					jetpackSfx.loop(0.5);
					
					if (collide("water", x, y))
					{
						maxSpeed = WATER_SPEED;
					}
				}
			}
			
			if (Input.released(Key.SPACE))
			{
				jetpackSfx.stop();
			}
			
			movement.y += gravity;
			
			updateWater();
			
			lastPosition.x = x;
			lastPosition.y = y;
			
			movement.x = FP.clamp(movement.x, -maxSpeed, maxSpeed);
			movement.y = FP.clamp(movement.y, -maxSpeed, maxSpeed);	
			
			moveBy(movement.x, movement.y, colliders, true);
			
			if (light == null)
			{
				getLight();
			}
			else
			{
				light.column = Math.floor(x / DungeonGenerator.TILE_SIZE);
				light.row = Math.floor(y / DungeonGenerator.TILE_SIZE);
			}
			
			if (movement.x < 0)
			{
				animation.flipped = true;
			}
			else if (movement.x > 0)
			{
				animation.flipped = false;
			}
			
			var m:Memento = collide("memento", x, y) as Memento;
			if (m)
			{
				if (Input.check(Key.E))
				{
					animToPlay = "pickup";
				}
				
				if (Input.released(Key.E))
				{
					inventory.addItem(m.filename, m.name);
					world.remove(m);
					new Sfx(Library.getSound("audio.pickup.mp3")).play(0.25);
				}
			}
			
			animation.play(animToPlay);
		}
		
		override public function moveCollideY(e:Entity):Boolean 
		{
			if (collideWith(e, x, y + 10))
			{
				canJetpack = false;
				jetpackSfx.stop();
			}
			
			maxSpeed = MAX_SPEED;
			
			movement.y = 0;
			
			return super.moveCollideY(e);
		}
		
		private function jump():void
		{
			movement.y = -(maxSpeed + 4);
			maxSpeed = movement.y;
		}
		
		public function get bodyTemperature():Number
		{
			return bodyTemp;
		}
		public function set bodyTemperature(val:Number):void
		{
			bodyTemp = FP.clamp(val, 0, 1);
			thermometer.setTemp(bodyTemp);
		}
		
		private function updateWater():void
		{
			function splash():void
			{
				emitter.setMotion("splash", FP.angle(x, y, lastPosition.x, lastPosition.y) - 90, 20, 0.5, 180);
				
				if (wet < MAX_WET_TIMER)
				{
					for (var i:int = 0; i < 20; i++) 
					{
						emitter.emit("splash", x, y);
					}
				}
			}
			
			if (collide("water", x, y))
			{
				bodyTemperature -= WET_TEMP_DEC;
				
				if (wet != MAX_WET_TIMER)
				{
					new Sfx(Library.getSound("audio.enterWater.mp3")).play(0.1);
					maxSpeed = WATER_SPEED;
				}
				
				splash();
				
				wet = MAX_WET_TIMER;
			}
			else
			{
				if (wet >= MAX_WET_TIMER)
				{
					new Sfx(Library.getSound("audio.leaveWater.mp3")).play(0.1);
					maxSpeed = MAX_SPEED;
					
					splash();
				}
				
				if (wet --> 0)
				{
					emitter.emit("drip", x, y);
				}
			}
		}
		
		public function get mementosCollected():Array
		{
			return inventory.mementosCollected;
		}
	}

}