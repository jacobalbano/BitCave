package com.jacobalbano.punkutils 
{
	import flash.utils.Dictionary;
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Jacob Albano
	 */
	public class XMLEntity extends Entity 
	{
		private var responses:Dictionary;
		
		public function XMLEntity() 
		{
			super();
			responses = new Dictionary();
		}
		
		public function load(entity:XML):void
		{
			for each (var attribute:XML in entity.attributes()) 
			{
				//	Explicit conversion to string is necessary here, for some reason.
				var name:String = attribute.name();
					
				try
				{
					this[name] = (entity.@[name] == "True" || entity.@[name] == "False") ? entity.@[name] == "True" : entity.@[name];
				}
				catch (e:ReferenceError)
				{
					//var re:RegExp = /\[.*:[0-9]+\]/;
					//if (!re.test(e.getStackTrace()))
					//{
						//return;
					//}
					//
					//	Couldn't create the property. No big deal; just log it and keep moving
					//var s:String = e.getStackTrace().split("\n")[0];
					//trace(s.substring(s.lastIndexOf(": ") + 2));
					continue;
				}
			}
		}
		
		/**
		 * Override this!
		 * @param	message	The message recieved from the world broadcast
		 * @param	...args	The arguments that go along with the message
		 * BE CAREFUL
		 */
		public final function onMessage(message:String, ...args):void
		{
			(responses[message] || (dummy))(args);
		}
		
		private function dummy(...args):void 
		{
		}
		
		/**
		 * Add a message response
		 * @param	message	The message the response responds to
		 * @param	response	The function to call as the response. Must take an array as a parameter
		 */
		public function addResponse(message:String, response:Function):void
		{
			responses[message] = response;
		}
		
		/**
		 * Remove a message response
		 * @param	message	The message that the response responds to
		 */
		public function removeResponse(message:String):void
		{
			delete responses[message];
		}
		
		public function broadcastMessage(message:String, ...args):void
		{
			var oWorld:OgmoWorld = world as OgmoWorld; 
			if (oWorld == null)
			{
				return;
			}
			
			oWorld.broadcastMessage.apply(oWorld, [message].concat(args));
			
		}
	}

}