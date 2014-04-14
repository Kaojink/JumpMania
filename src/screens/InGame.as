package screens 
{
	/**
	 * ...
	 * @author 
	 */
	
	import Box2D.Dynamics.Contacts.b2NullContact;
	import events.NavigationEvent;
	import objects.Character;
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
	//import starling.events.EventDispatcher;
	//
	//
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	import com.reyco1.physinjector.contact.ContactManager;
	//
	
	 public class InGame extends Sprite
	{
		private var physics:PhysInjector;
		
		private var bg:Image;
		private var currentDate:Date;
		
		private var char:Character;
		private var charobject:PhysicsObject;
		
		private var floor:Image;
		private var floorObject:PhysicsObject;
		
		private var balloon1:Balloon;
		
		private var gravity:b2Vec2 = new b2Vec2(0, 9.8); //normal earth gravity, 9.8 m/s/s straight down!

		
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
			
			
			bg = new Image(Assets.getTexture("BackgroundInGame"));
			bg.width = 700;
			bg.height = 800;
			this.addChild(bg);
			
			
			floor = new Image(Assets.getTexture("Ground"));
			floor.width = 700;
			floor.height = 100;
            floor.x = 0;
            floor.y = stage.stageHeight-100;
            addChild( floor );
			
			char = new Character(physics, floorObject);
			addChild(char);
			
			balloon1 = new Balloon(physics);
			addChild(balloon1);
			
			injectPhysics();
			addEventListener(Event.ENTER_FRAME, update);
		}
			
		public function initialize():void
		{
			this.visible = true;
		}
		
		private function update():void
		{
			ContactManager.onContactBegin(char.name, balloon1.name, Rebound);
		//	currentDate = new Date;
		//	balloon1Object.y = 300 + (Math.cos(currentDate.getTime() * 0.002) * 15);
			physics.update();
		}
		
		private function injectPhysics():void
		{
			floorObject = physics.injectPhysics(floor, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
		}
		
		private function Rebound(ObjectA:PhysicsObject, ObjectB:PhysicsObject, contact:b2Contact):void
		{
			trace("hola");
		}
	}

}