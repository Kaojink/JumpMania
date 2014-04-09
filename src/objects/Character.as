package objects 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class Character extends Sprite
	{
		private var character:Image;
		public var dimension:Number= 128;
		
		public function Character() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//createHeroArt();
			trace("Carga Personaje");
			
			character = new Image(Assets.getTexture("BackgroundInGame"));
			character.width = dimension;
			character.height = dimension;
			this.addChild(character);
		}
	}
}