package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Player extends XMLEntity 
	{
		private const MAX_SPEED:Number = 7;
		static private const MAX_WET_TIMER:Number = 15;
		
		private var movement:Point;
		private var gravity:Number;
		private var speed:Number;
		private var maxSpeed:Number;
		private var jetpackForce:Number;
		private var waterForce:Number;
		
		private var canMove:Boolean;
		private var colliders:Vector.<String>;
		private var animToPlay:String;
		
		private var inventory:Inventory;
		private var canJetpack:Boolean;
		
		private var jetpackSfx:Sfx;
		private var emitter:Emitter;
		private var animation:Spritemap;
		private var wet:Number;
		
		public function Player(x:Number, y:Number) 
		{
			super();
			name = "player";
			type = "player";
			wet = 0;
			
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
			emitter.setMotion("splash", 0, 20, 0.5, 180);
			emitter.setAlpha("splash", 1, 0);
			
			addGraphic(emitter);
			addGraphic(animation);
			
			animation.centerOO();
			this.setHitbox(12, 30);
			centerOrigin();
			
			this.x = x;
			this.y = y;
			
			movement = new Point();
			speed = 4.0;
			gravity = .85;
			waterForce = .6;
			jetpackForce = 1;
			maxSpeed = MAX_SPEED;
			
			canMove = true;
			
			colliders = new Vector.<String>();
			colliders.push("cave");
			
			jetpackSfx = new Sfx(Library.getSound("audio.jetpack.mp3"));
		}
		
		override public function added():void 
		{
			super.added();
			
			 world.add(inventory = new Inventory());
		}
		
		override public function update():void 
		{
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
				if (collide("cave", x, y + 1))
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
					maxSpeed = MAX_SPEED;
				}
			}
			
			if (Input.pressed(Key.SPACE))
			{
				if (canJetpack)
				{
					jetpackSfx.loop(0.5);
				}
			}
			
			if (Input.released(Key.SPACE))
			{
				jetpackSfx.stop();
			}
			
			movement.y += gravity;
			
			if (collide("water", x, y))
			{
				if (wet < MAX_WET_TIMER)
				{
					for (var i:int = 0; i < 20; i++) 
					{
						emitter.emit("splash", x, y);
					}
				}
				
				wet = MAX_WET_TIMER;
			}
			else
			{
				if (wet --> 0)
				{
					emitter.emit("drip", x, y);
				}
			}
			
			movement.x = FP.clamp(movement.x, -maxSpeed, maxSpeed);
			movement.y = FP.clamp(movement.y, -maxSpeed, maxSpeed);	
			
			moveBy(movement.x, movement.y, colliders, true);
			
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
					inventory.addItem(m.filename);
					world.remove(m);
				}
			}
			
			animation.play(animToPlay);
		}
		
		override public function moveCollideY(e:Entity):Boolean 
		{
			if (collideWith(e, x, y + 10))
			{
				canJetpack = false;
			}
			
			maxSpeed = MAX_SPEED;
			
			movement.y = 0;
			
			return super.moveCollideY(e);
		}
		
		private function jump():void
		{
			movement.y = -12;
			maxSpeed = 100;
		}
		
	}

}