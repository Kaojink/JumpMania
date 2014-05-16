package screens 
{
	/**
	 * ...
	 * @author 
	 */
	
	import Box2D.Dynamics.Contacts.b2NullContact;
	import events.NavigationEvent;
	import flash.geom.Rectangle;
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
	import com.reyco1.physinjector.contact.ContactManager;
	//
	import starling.text.TextField;
	
	import events.Collision;

	public class InGame extends Sprite
	{
		private var physics:PhysInjector;
		
		private var BG:BgLayer;

		private var char:Character;
		
	//	private var floor:Image;
	//	private var floorObject:PhysicsObject;
		
		private var generate:Boolean=true;
		private var time:Date = new Date;
		private var time2:Date = new Date;
		
		private var gravity:b2Vec2 = new b2Vec2(0, 9.8); //normal earth gravity, 9.8 m/s/s straight down!
		
		private var index:Number = 0;
		private var landing:Boolean= false;
		
		private var Score:Number = 0;
		private var LastHigherPos:Number;
		private var LastThisY:Number;
		private var ScoreText:TextField = new TextField(100, 50, "", "Verdana", 12);
		private var LifeText:TextField = new TextField(100, 50, "", "Verdana", 12);
		
		private var BackObjects:Background;
		
		private var upgrades:Items;
		
		private var Foes:Enemies;
		
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
			
			char = new Character(physics);		
			
			BG = new BgLayer(char); //Declaramos el fondo
			this.addChild(BG);
			
			BackObjects = new Background(physics);
			addChild(BackObjects);
			
			ScoreText.text = "Score: "+Score;
			addChild(ScoreText);
			
			LifeText.text = char.GetLives() + "  X";
			LifeText.x = Starling.current.nativeStage.stageWidth - LifeText.width;
			addChild(LifeText);
		
			addChild(char);	
			
			char.y = char.GetPosY();
			LastHigherPos = char.y;
			
			Foes = new Enemies(physics, char);
			addChild(Foes);
			
			upgrades = new Items();
			upgrades.name = "upgrades";
			addChild(upgrades);
			
			char.EnableContact();
			
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.ENTER_FRAME, RandomGenerate);
			addEventListener(Event.ENTER_FRAME, followChar);
		}
			
		public function initialize():void
		{
			this.visible = true;
		}
		
		private function update(e:EnterFrameEvent):void
		{ 
			physics.update();
		}
		
		private function RandomGenerate(e:EnterFrameEvent):void
		{
			if (generate)
			{
				//trace("1");
				generate = false;
				time = new Date();
				time2 = new Date();
				var globo:Balloon = new Balloon(physics, index, char, false);
				globo.name = "balloon" + index;
				this.addChild(globo);
				swapChildren(char, globo);
				//trace(this.getChildIndex(globo));
				/*if (globo.GetColour() != "black")
				{
					var colision:Collision = new Collision(index, globo, char);
				}*/
				//trace("antes " + index);
				index++;
				//trace("despues " + index);
				
			}
			else 
			{
				time2 = new Date();
				if (time2.getTime() - time.getTime() >= 700)
				{
					generate = true;
				}
			}
		}
		
		private function followChar(e:EnterFrameEvent):void
		{
			char.y = char.GetPosY();
			char.x = char.GetPosX();
			this.y = -char.y+char.GetInitPosY();
			physics.globalOffsetY = -char.y + char.GetInitPosY();
			ScoreText.y = char.y - char.GetInitPosY();
			LifeText.y = ScoreText.y;
			//BG.y = char.y - char.GetInitPosY();
			if (char.GetVelY() > 0 && char.y >= 400) char.animate("JumpLanding");
			if (char.GetVelY() < 0 && char.y < LastHigherPos)
			{
				LastThisY = this.y;
				LastHigherPos = char.y;
				Score++;
				ScoreText.text = "Score: "+Score;
			}

			if (char.y >= LastHigherPos + 500 && LastThisY > 750) 
			{
				/*removeEventListener(Event.ENTER_FRAME, followChar);
				removeEventListener(Event.ENTER_FRAME, RandomGenerate);
				removeEventListener(Event.ENTER_FRAME, update);
				removeChildren();

				parent.removeChild(this);*/
				
				physics.globalOffsetY = 0;
				char.RestartPos();
				this.y = 0;
				char.y = char.GetInitPosY();
				LastHigherPos = char.y;
				LastThisY = char.y;
			}
			
		}
		
		public function getindex():Number
		{
			var index2:Number = index;
			index++;
			//trace("item " + index2);
			return index2;
		}
		
		public function animateCorrectBalloon(nombre:String):void
		{
			(getChildByName(nombre) as Balloon).animateBalloon();
		}
		
		public function getChar():Character
		{
			return char;
		}

	}

}