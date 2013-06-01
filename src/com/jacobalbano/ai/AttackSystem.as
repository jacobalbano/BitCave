package com.jacobalbano.ai 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class AttackSystem 
	{
		private var _canAttack:Boolean;
		
		public var fireRate:Number;
		
		public function AttackSystem() 
		{
			_canAttack = true;
		}
		
		public function get canAttack():Boolean
		{
			return _canAttack;
		}
		
		final public function attack():void
		{
			if (!canAttack)
			{
				return;
			}
			
			onAttack();
			
			var shootTimer:Timer = new Timer(fireRate, 1);
			shootTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCanShoot);
			shootTimer.start();
			_canAttack = false;
		}
		
		/**
		 * Override this!
		 */
		public function onAttack():void
		{
		}
		
		private function onCanShoot(e:TimerEvent):void 
		{
			_canAttack = true;
		}
		
	}

}