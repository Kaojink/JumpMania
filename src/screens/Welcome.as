package screens 
{
	/**
	 * ...
	 * @author 
	 */
	import events.NavigationEvent;
	import starling.events.Event;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.core.Starling;

	 
	public class Welcome extends Sprite
	{
		private var bg:Image;
		private var title:Image;	
		private var playBtn:Button;
		private var aboutBtn:Button;
		
		public function Welcome() 
		{
			super();
			//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Welcome screen!");
			
			/*bg = new Image(Assets.getTexture("BgWelcome"));
			bg.width = 600;
			bg.height = 800;
			this.addChild(bg);
			
			title = new Image(Assets.getAtlas().getTexture("welcome_title"));
			title.x = bg.width-200-title.width/2;
			title.y = 20;
			this.addChild(title);
			
			playBtn = new Button(Assets.getAtlas().getTexture("welcome_playButton"));
			playBtn.x = 450-playBtn.width/2;		
			this.addChild(playBtn);*/
			
			
			//la carga de imagenes se podria hacer asi o directamente
			
			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
			
		}
		
		private function onMainMenuClick(event:Event):void
		{
			var buttonClicked:Button = event.target as Button;
			if ((event.target as Button == playBtn))
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.CHANGE_SCREEN, { id: "play" }, true));
			}
		}
		
		public function initialize():void
		{
			this.visible = true;
						
		}
	}

}