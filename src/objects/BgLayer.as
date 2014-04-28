package objects 
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.TextureAtlas;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author 
	 */
	public class BgLayer extends Sprite
	{
		private var background_ground:Image;
		
		
		public function BgLayer() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void 
		{
			background_ground = new Image(Assets.getTexture("BG_ground01"));
			background_ground.width = 700;
			background_ground.height = 800;
			this.addChild(background_ground);
		}
	
	}

}