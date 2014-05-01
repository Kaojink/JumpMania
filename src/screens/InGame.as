package screens 
{
	/**
	 * ...
	 * @author 
	 */
	
	import Box2D.Dynamics.Contacts.b2NullContact;
	import events.NavigationEvent;
	import flash.geom.Rectangle;
	import objects.Character;
	import objects.BgLayer;
	import objects.Balloon;
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
	
	import events.Collision;

	public class InGame extends Sprite
	{
		private var physics:PhysInjector;
		
		private var BG:BgLayer;

		private var char:Character;
		private var charobject:PhysicsObject;
		
		private var floor:Image;
		private var floorObject:PhysicsObject;
		
		private var generate:Boolean=true;
		private var time:Date = new Date;
		private var time2:Date = new Date;
		
		private var gravity:b2Vec2 = new b2Vec2(0, 9.8); //normal earth gravity, 9.8 m/s/s straight down!
		
		private var index:Number = 0;
		private var landing:Boolean= false;
		
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
			
			
			BG = new BgLayer(); //Declaramos el fondo
			this.addChild(BG);
			
			floor = new Image(Assets.getTexture("Ground"));
			floor.width = 900;
			floor.height = 150;
            floor.x = -100;
            floor.y = 650;
            addChild( floor );
			floorObject = physics.injectPhysics(floor, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.8, restitution:0 } ));
			floorObject.name = "floor";

			char = new Character(physics);
			addChild(char);
			
			char.y = char.GetPosY();

			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.ENTER_FRAME, RandomGenerate);
			addEventListener(Event.ENTER_FRAME, followChar);
		}
			
		public function initialize():void
		{
			this.visible = true;
		}
		
		private function update():void
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
				
				var globo:Balloon = new Balloon(physics, index, char);
				//trace(index);
				this.addChild(globo);
				var colision:Collision = new Collision(index, char);
				index++;
				char.updateChild();
				
			}
			else 
			{
				time2 = new Date();
				if (time2.getSeconds() < time.getSeconds())
				{
					if ( 60 + time2.getSeconds() - time.getSeconds() >= 0.4) generate = true;
				}
				else if (time2.getSeconds() - time.getSeconds() >= 0.4)
				{
					generate = true;
				}
			}
		}
		
		private function followChar(e:EnterFrameEvent):void
		{
			char.y = char.GetPosY();
			this.y = -char.y+char.GetInitPosY();
			physics.globalOffsetY = -char.y + char.GetInitPosY();
			
			if (char.GetVelY() > 0 && char.y >= floor.y - char.height  -500) {

				char.animate("JumpLanding");
			}
		}

	}

}