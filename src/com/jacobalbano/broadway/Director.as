package com.jacobalbano.broadway 
{
	import com.jacobalbano.punkutils.XMLEntity;
	import com.jacobalbano.slang.Scope;
	import com.jacobalbano.slang.SlangFunction;
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Director extends XMLEntity 
	{
		public var script:String;
		public var autostart:Boolean;
		
		private var cues:Dictionary;
		private var actors:Array;
		private var actorsFinished:Array;
		private var scope:Scope;
		private var openRoles:Array;
		private var isDirecting:Boolean;
		
		
		public function Director() 
		{
			actors = [];
			actorsFinished = [];
			openRoles = [];
			
			isDirecting = false;
			
			scope = new Scope(Game.instance.console.slang);
			scope.addFunction(new SlangFunction("fillRole", fillRole).paramCount(2).self(this));
		}
		
		override public function added():void 
		{
			super.added();
			
			if (autostart)
			{
				start();
			}
		}
		
		/**
		 * Instruct an actor to load a script for this role
		 * @param	actor		The actor's name
		 * @param	scriptName	The name of the script file
		 */
		public function fillRole(actor:String, scriptName:String):void
		{	
			for each (var item:Actor in actors) 
			{
				if (item.name == actor)
				{
					item.loadRole(scriptName);
					return;
				}
			}
			
			openRoles.push([actor, scriptName])
		}
		
		/**
		 * Find whether a cue has been given
		 * @param	name	The name or identifier of the cue
		 * @return	whether a cue has been given
		 */
		public function hasCue(name:String):Boolean
		{
			return cues[name] != undefined;
		}
		
		/**
		 * Alert other actors of a cue
		 * @param	name	The name or identifier of the cue
		 */
		public function giveCue(name:String):void
		{
			cues[name] = true;
		}
		
		/**
		 * Adds an actor the active list
		 * @param	actor	The actor to add
		 */
		public function addActor(actor:Actor):void 
		{
			actors.push(actor);
			checkRoles(actor);
		}
		
		private function checkRoles(actor:Actor):void 
		{
			if (openRoles.length > 0)
			{
				for (var i:int = 0; i < openRoles.length; ++i) 
				{
					var item:Array = openRoles[i];
					
					if (item[0] == actor.actorName)
					{
						actor.loadRole(item[1]);
						openRoles.splice(i, 1);
						return;
					}
				}
			}
		}
		
		public function start():void 
		{
			if (isDirecting)
			{
				return;
			}
			
			actorsFinished = [];
			cues = new Dictionary();
			scope.compile(Library.getXML("scripts." + script + ".xml").text()).execute();
			
			for each (var actor:Actor in actors) 
			{
				checkRoles(actor);
			}
			
			isDirecting = true;
		}
		
		public function onActorFinished(actor:Actor):void 
		{
			if (actorsFinished.indexOf(actor) < 0)
			{
				actorsFinished.push(actor);
				
				if (actorsFinished.length == actors.length)
				{
					isDirecting = false;
				}
			}
		}
	}

}