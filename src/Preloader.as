package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	
	/**
	 * ...
	 * @author Jacob Albano
	 */
	
	[SWF(width = "800", height = "400")]
	public class Preloader extends MovieClip 
	{
		// Change these values
		private static const mainClassName:String = "Game";
		
		private static const BG_COLOR:uint = 0x0;
		private static const FG_COLOR:uint = 0x111111;
		// Ignore everything else
		private var progressBar:Shape;
		
		private var px:int;
		private var py:int;
		private var w:int;
		private var h:int;
		private var sw:int;
		private var sh:int;
		
		public function Preloader()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			w = stage.stageWidth * 0.8;
			h = 20;
			
			px = (sw - w) * 0.5;
			py = (sh - h) * 0.5;
			
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(0, 0, sw, sh);
			graphics.endFill();
			
			graphics.beginFill(FG_COLOR);
			graphics.drawRect(px - 2, py - 2, w + 4, h + 4);
			graphics.endFill();
			
			progressBar = new Shape();
			
			addChild(progressBar);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function onEnterFrame (e:Event):void
		{
			if (hasLoaded())
			{
					graphics.clear();
					graphics.beginFill(BG_COLOR);
					graphics.drawRect(0, 0, sw, sh);
					graphics.endFill();
					
					stage.addEventListener(MouseEvent.CLICK, startup);
					var tf:TextField = new TextField();
					tf.defaultTextFormat = new TextFormat(null, 30, 0xFFFFFF, true);
					tf.width = 1000;	//	dumb stupid
					tf.text = "Click to start";
					
					tf.x = stage.stageWidth / 2 - tf.textWidth / 2;
					tf.y = stage.stageHeight / 2 - tf.textHeight / 2;
					tf.mouseEnabled = false;
					addChild(tf);
					
					stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
					{
						removeChild(tf);
					});
					
			} else {
					var p:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
					
					progressBar.graphics.clear();
					progressBar.graphics.beginFill(BG_COLOR);
					progressBar.graphics.drawRect(px, py, p * w, h);
					progressBar.graphics.endFill();
			}
				
		}
		
		private function hasLoaded():Boolean
		{
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		private function startup(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK, startup);
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = getDefinitionByName(mainClassName) as Class;
			parent.addChild(new mainClass as DisplayObject);
			
			parent.removeChild(this);
		}
		
	}
	
}