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
		private var background_Ground:Image;
		private var background_Sky:Image;
		private var background_Space:Image;
		private var Tree:Image;

		
		public function BgLayer() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void 
		{
			
			background_Ground = new Image(Assets.getTexture("BG_ground"));
			this.addChild(background_Ground);
			
			Tree = new Image(Assets.getTexture("Tree"));
			Tree.y = 150;
			Tree.x = -20;
			this.addChild(Tree);
		}
	
	}

}