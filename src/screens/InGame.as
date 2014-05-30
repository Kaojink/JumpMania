package screens 
{
	/**
	 * ...
	 * @author 
	 */
	
	import Box2D.Dynamics.Contacts.b2NullContact;
	import events.NavigationEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import objects.Background;
	import objects.Character;
	import objects.BgLayer;
	import objects.Balloon;
	import objects.Enemies;
	import objects.Items;
	import starling.events.EnterFrameEvent;
	//
	import starling.events.Event;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.core.Starling;
	import starling.events.KeyboardEvent;
	//
	import Box2D.Dynamics.b2World;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	//
	//
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	//
	import starling.text.TextField;
	
	import events.Collision;

	public class InGame extends Sprite
	{
		private var physics:PhysInjector;
		
		private var BG:BgLayer;

		private var char:Character;
		
		private var gravity:b2Vec2 = new b2Vec2(0, 9.8); //normal earth gravity, 9.8 m/s/s straight down!
		
		private var index:Number = 0;
		
		private var Score:Number = 0;
		private var LastHigherPos:Number;
		private var LastThisY:Number;

		private var ScoreText:TextField = new TextField(200, 100, "", Assets.getFont().name, 24,0xEAFF5E);
		private var LifeText:TextField = new TextField(50, 50, "",Assets.getFont().name, 20,0xEAFF5E);
		private var LifeIcon:Image;
		private var NBalloons:Number = 0;
		private var BackObjects:Background;
		
		private var Foes:Enemies;
		
		private var timer:Timer;
		
		private var LayerBalloons:Sprite;
		private var LayerEnemies:Sprite;
		private var LayerChar:Sprite;
		
		private var Pause:Boolean = false;
		
		public function InGame() 
		{
			super();
			PhysInjector.STARLING = true;
			physics = new PhysInjector(Starling.current.nativeStage, gravity, true);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddetToStage);
		}
		
		private function onAddetToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddetToStage);
			
			trace("InGame Screen");
			
			LayerBalloons = new Sprite();
			LayerEnemies = new Sprite();
			LayerChar = new Sprite();
				
			char = new Character(physics);		
			
			BG = new BgLayer(char); //Declaramos el fondo
			this.addChild(BG);
					
			BackObjects = new Background(physics);
			addChild(BackObjects);
			
			addChild(LayerBalloons);
			addChild(LayerEnemies);
			addChild(LayerChar);
			
			ScoreText.text = "Score: " + Score;
			ScoreText.hAlign = "left";
			ScoreText.x = 25;
			addChild(ScoreText);
			
			LifeText.text = "X  " + char.GetLives() ;
			LifeText.hAlign = "left";
			LifeText.x = Starling.current.nativeStage.stageWidth - LifeText.width/0.75;
			addChild(LifeText);
			
			LifeIcon = new Image(Assets.getAtlas().getTexture("character_life"));
			LifeIcon.scaleX = 0.75;
			LifeIcon.scaleY = 0.75;
			LifeIcon.x= Starling.current.nativeStage.stageWidth - LifeText.width-LifeIcon.width*1.5;
			this.addChild(LifeIcon);
		
			LayerChar.addChild(char);	
			
			char.y = char.GetPosY();
			LastHigherPos = char.y;
			
			Foes = new Enemies(physics, char);
			Foes.name = "foes";
			LayerEnemies.addChild(Foes);
			
			char.EnableContact();
			
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.ENTER_FRAME, followChar);
			addEventListener(KeyboardEvent.KEY_DOWN, PauseGame);
			
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, RandomGenerate);
			timer.start();
		}
		
		public function generateItem ():void
		{
			var upgrades:Items = new Items();
			LayerChar.addChild(upgrades);
		}
		
		public function initialize():void
		{
			this.visible = true;
		}
		
		private function update(e:EnterFrameEvent):void
		{ 
			if(!Pause)
				physics.update();
		}
		
		private function RandomGenerate(e:TimerEvent):void
		{
			if (NBalloons < 30 && !Pause)
			{
				var globo:Balloon = new Balloon(physics, index, char, false);			
				LayerBalloons.addChild(globo);
				NBalloons++;
				index++;
			}
		}
		
		public function UpdateLives():void 
		{
			LifeText.text =  "X  " + char.GetLives();
		}
		
		private function followChar(e:EnterFrameEvent):void
		{
			char.y = char.GetPosY();
			char.x = char.GetPosX();
			this.y = -char.y+char.GetInitPosY();
			physics.globalOffsetY = -char.y + char.GetInitPosY();
			ScoreText.y = char.y - char.GetInitPosY();
			LifeText.y = ScoreText.y;
			LifeIcon.y = LifeText.y;

			//BG.y = char.y - char.GetInitPosY();
			if (char.GetVelY() > 0 && char.y >= 400) char.animate("JumpLanding");
			if (char.GetVelY() < 0 && char.y < LastHigherPos)
			{
				LastThisY = this.y;
				LastHigherPos = char.y;
				Score++;
				ScoreText.text = "Score: "+Score;
			}

			if ((char.y >= LastHigherPos + 500 && LastThisY > 750) || char.GetLives()<=0) 
			{
				char.alpha = 1;
				Restart();
				/*removeEventListener(Event.ENTER_FRAME, followChar);
				removeEventListener(Event.ENTER_FRAME, RandomGenerate);
				removeEventListener(Event.ENTER_FRAME, update);
				removeChildren();

				parent.removeChild(this);*/
				
				
			}
			
		}
		
		public function getindex():Number
		{
			var index2:Number = index;
			index++;
			return index2;
		}
		
		public function DoToCorrectBalloon(nombre:String, action:String):void
		{
			if (action == "TakeBalloonLife")
			{
				(LayerBalloons.getChildByName(nombre) as Balloon).TakeBalloonLife();
			}
			if (action == "Animate")	
			{
				(LayerBalloons.getChildByName(nombre) as Balloon).animateBalloon();
			}
			if (action == "Erase") 
			{
				(LayerBalloons.getChildByName(nombre) as Balloon).EraseBalloon();
			}
		}
		
		public function getChar():Character
		{
			return char;
		}
		
		public function getLayer(LayerName:String):Sprite
		{
			switch (LayerName) 
			{
				case "Balloons":
					return LayerBalloons;
					break;
				case "Char":
					return LayerChar;
					break;
				case "Enemies":
					return LayerEnemies;
					break;
			}
			return null;
			
		}
		
		public function DecreaseNBalloons():void
		{
			NBalloons--;
		}
		
		private function PauseGame(event:KeyboardEvent):void // control de la tecla pausa
		{
			switch (event.keyCode)
			{
			  case 80: //letra P
				if (Pause)
				{
					Pause = false;
					char.animate("ActivateAnimation");
					//Starling.current.nativeStage.frameRate = 30;
					
				}
				else 
				{
					Pause = true;
					//Starling.current.nativeStage.frameRate = 0;
				}
				break;
			}
		}
		
		public function isPauseActivated():Boolean
		{
			return Pause;
		}
		
		public function Restart():void
		{
			physics.globalOffsetY = 0;
			char.RestartPos();
			this.y = 0;
			Score = 0;
			ScoreText.text = "Score: "+Score;
			char.y = char.GetInitPosY();
			LastHigherPos = char.y;
			LastThisY = char.y;
		}
		
		

	}

}