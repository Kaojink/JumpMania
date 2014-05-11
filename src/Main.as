package  
{
	/**
	 * ...
	 * @author 
	 */
	import flash.display.Sprite;
	import flash.events.Event
	import starling.core.Starling;
	
	public class Main extends Sprite
	{
		private var starling:Starling;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			starling = new Starling(Game, stage);
			starling.start();
			
		}
	}

}