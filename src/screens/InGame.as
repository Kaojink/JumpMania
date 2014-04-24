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
	import flash.media.Camera;
	
	 public class InGame extends Sprite
	{
		private var physics:PhysInjector;
		
		private var BG:BgLayer;
		
	//	private var bg:Image;
	//	private var currentDate:Date;
		
		private var char:Character;
		private var charobject:PhysicsObject;
		
		private var floor:Image;
		private var floorObject:PhysicsObject;
		
		private var balloon1:Balloon;
		
		private var generate:Boolean=true;
		private var time:Date = new Date;
		private var time2:Date = new Date;
		
		private var gravity:b2Vec2 = new b2Vec2(0, 9.8); //normal earth gravity, 9.8 m/s/s straight down!
		private var camera:Camera = new Camera();
		
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

			/*bg = new Image(Assets.getTexture("BackgroundInGame"));
			bg.width = 700;
			bg.height = 800;
			this.addChild(bg);*/
			
			floor = new Image(Assets.getTexture("Ground"));
			floor.width = 900;
			floor.height = 100;
            floor.x = -100;
            floor.y = stage.stageHeight-100;
            addChild( floor );
			floorObject = physics.injectPhysics(floor, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
			floorObject.name = "floor";
			
			balloon1 = new Balloon(physics);
			addChild(balloon1);
			
			char = new Character(physics);
			addChild(char);
			
			//injectPhysics();
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
		//	currentDate = new Date;
		//	balloon1Object.y = 300 + (Math.cos(currentDate.getTime() * 0.002) * 15);
			physics.update();
		}
		
		/*private function injectPhysics():void
		{
			floorObject = physics.injectPhysics(floor, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
			floorObject.name = "floor";
		}*/
		
		private function RandomGenerate(e:EnterFrameEvent):void
		{
			if (generate)
			{
				//trace("1");
				generate = false;
				time = new Date();
				time2 = new Date();
				
				var globo:objects.Balloon = new Balloon(physics);
				this.addChild(globo);
			}
			else 
			{
				//trace(time);
				//trace(time2);
				time2 = new Date();
				if (time2.getSeconds() < time.getSeconds())
				{
					if ( 60 + time2.getSeconds() - time.getSeconds() >= 1) generate = true;
				}
				else if (time2.getSeconds() - time.getSeconds() >= 1)
				{
					trace("3");
					generate = true;
				}
			}
		}
		
		private function followChar(e:EnterFrameEvent):void
		{
			
			//Starling.current.stage.root.y = char.y - 800 -164;
			//var scrollRect:Rectangle =  new Rectangle(char.x - Starling.current.nativeStage.stageWidth / 2, char.y - Starling.current.nativeStage.stageHeight / 2, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight); 
		}
	}

}