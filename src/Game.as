package  
{
	/**
	 * ...
	 * @author 
	 */
	
	import events.NavigationEvent;
	import screens.InGame;
	import screens.Welcome;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var ScreenWelcome:Welcome;
		private var ScreenInGame:InGame;
		
		public function Game() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			trace("Juego inicializado");
			
			this.addEventListener(NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			
			//ScreenInGame = new InGame();
			//ScreenInGame.visible = false;
			//this.addChild(ScreenInGame); //esto es para dejar en espera la pantalla ingame*/
			
			ScreenWelcome = new Welcome(); //esto es para pasar a la pantalla de welcome
			this.addChild(ScreenWelcome);
			ScreenWelcome.initialize();
			
			//inicializo directamente ingame para ir directamente a la pantalla de juego, para hacerlo bien seria lo de abajo
			//StartGame();
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "play":
					ScreenWelcome.visible = false;  //asi seria para que cambiara de la pantalla de welcome a ingame
					ScreenInGame = new InGame();
					ScreenInGame.initialize();
					this.addChild(ScreenInGame);
					swapChildren(ScreenWelcome, ScreenInGame);
					break;
			}
			
		}
		
		/*private function StartGame():void
		{
			ScreenInGame = new InGame();
			this.addChild(ScreenInGame);
			ScreenInGame.initialize();
		}*/
		
		
		
	}

}