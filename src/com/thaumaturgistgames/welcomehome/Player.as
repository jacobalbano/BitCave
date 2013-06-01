package com.thaumaturgistgames.welcomehome 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import com.thaumaturgistgames.flakit.Library;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Player extends XMLEntity 
	{
		private var movement:Point;
		private var gravity:Number;
		private var speed:Number;
		private const MAX_SPEED:Number = 10;
		private var jetpackForce:Number;
		
		private var canMove:Boolean;
		private var canJump:Boolean;
		private var colliders:Vector.<String>;
		private var animToPlay:String;
		
		public function Player(x:Number, y:Number) 
		{
			super();
			
			var img:Spritemap = new Spritemap(Library.getImage("graphics.dude.png").bitmapData, 64, 64);
			img.add("idle", [0]);
			img.add("walk", [0, 1, 2, 3], 8);
			img.add("pickup", [4, 5, 6, 7, 6, 5, 4, 0], 6, false);
			img.add("jetpackOn", [8, 9, 10, 11], 8);
			img.add("jetpackIdle", [12]);
			img.scale = .5;
			
			animToPlay = "idle";
			img.play(animToPlay);
			
			this.graphic = img;
			//this.setHitbox(
			
			this.x = x;
			this.y = y;
			
			movement = new Point();
			speed = 4.0;
			gravity = .85;
			jetpackForce = 1;
			
			canMove = true;
			canJump = false;
			
			colliders = new Vector.<String>();
			colliders.push("temp");
		}
		
		override public function update():void 
		{
			super.update();
			
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
			
			if (Input.check(Key.SPACE))
			{
				movement.y -= jetpackForce;
				animToPlay = "jetpackOn";
			}
			
			movement.y += gravity;
			
			movement.x = FP.clamp(movement.x, -MAX_SPEED, MAX_SPEED);
			movement.y = FP.clamp(movement.y, -MAX_SPEED, MAX_SPEED);
			moveBy(movement.x, movement.y, colliders, true);
			
			if (movement.x < 0)
			{
				(graphic as Image).flipped = true;
			}
			else if (movement.x > 0)
			{
				(graphic as Image).flipped = false;
			}
			
			(graphic as Spritemap).play(animToPlay);
		}
		
		override public function moveCollideY(e:Entity):Boolean 
		{
			canJump = true;
			
			movement.y = 0;
			
			return super.moveCollideY(e);
		}
		
		private function jump():void
		{
			if (canJump)
			{
				canJump = false;
				movement.y = -10;
			}
		}
		
	}

}