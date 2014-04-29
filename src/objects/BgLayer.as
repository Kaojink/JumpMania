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
		private var background_ground1:Image;
		private var background_ground2:Image;
		private var background_ground3:Image;
		
		public function BgLayer() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void 
		{
			background_ground1 = new Image(Assets.getTexture("BG_ground01"));
			background_ground1.width = 700;
			background_ground1.height = 1600;
			background_ground1.y = 800 - background_ground1.height;
			this.addChild(background_ground1);
			
			background_ground2 = new Image(Assets.getTexture("BG_ground02"));
			background_ground2.width = 700;
			background_ground2.height = 1600;
			background_ground2.y = 800 - background_ground2.height - background_ground1.height +1;
			this.addChild(background_ground2);
			

		}
	
	}

}