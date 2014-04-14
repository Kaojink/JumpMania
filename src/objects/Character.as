package objects 
{

	import Box2D.Dynamics.Contacts.b2Contact;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	import Box2D.Dynamics.b2World;
	import Box2D.Common.Math.b2Vec2;
	
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager
	/**
	 * ...
	 * @author 
	 */
	public class Character extends Sprite
	{
		private var character:MovieClip;
		public var dimension:Number = 128;
		private var charobject:PhysicsObject;
		private var LEFT:Boolean;
		private var RIGHT:Boolean;
		private var JUMP:Boolean;
		private var physics:PhysInjector;
		private var floor:PhysicsObject;
		private var vMaxX:Number = 5.7;
		
		public function Character(fisicas:PhysInjector, suelo:PhysicsObject) 
		{
			super();
			physics = fisicas;
			floor =  suelo;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			trace("Carga Personaje");
			
			character= new MovieClip(Assets.getAtlas().getTextures("Idleanimation128_"), 7);
			character.width = dimension/2;
			character.height = dimension;
			character.x = (Starling.current.nativeStage.stageWidth - character.width) / 2;
			Starling.juggler.add(character);
			this.addChild(character);
			
			charobject = physics.injectPhysics(character, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.2, restitution: -0.8,linearDamping:1 } ));
			charobject.physicsProperties.density = 1;
			charobject.body.SetFixedRotation(true);
			charobject.name = "char";
			
			addEventListener(KeyboardEvent.KEY_DOWN, Movement);
			addEventListener(KeyboardEvent.KEY_UP, Stop);
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateMovement);
			ContactManager.onContactBegin(charobject.name, floor.name, Rebound);
		}
			
		private function Movement(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
			  case 39: // derecha
				RIGHT = true;
				break;
			  case 37: //izquierda
				LEFT = true;
				break;
			  case 32: //barra
				
				JUMP = true;
				break;
			}
		}
		
		private function Stop(event:KeyboardEvent):void 
		{
			switch (event.keyCode)
			{
			  case 39: // derecha
				RIGHT = false;
				break;
			  case 37: //izquierda
				LEFT = false;
				break;
			}
		}
		
		private function updateMovement():void
		{
			if (LEFT)
			{
				if (charobject.body.GetLinearVelocity().x > -5.4) charobject.body.ApplyForce(new b2Vec2( -18, 0), charobject.body.GetLocalCenter());
				else (charobject.body.SetLinearVelocity(new b2Vec2(-vMaxX, charobject.body.GetLinearVelocity().y)));
			}
			if (RIGHT) 
			{
				if (charobject.body.GetLinearVelocity().x < 5.4) charobject.body.ApplyForce(new b2Vec2( 18, 0), charobject.body.GetLocalCenter());
				else (charobject.body.SetLinearVelocity(new b2Vec2(vMaxX, charobject.body.GetLinearVelocity().y)));
			}
			if (JUMP) 
			{
				JUMP = false;
				charobject.body.ApplyImpulse(new b2Vec2( 0, -20), charobject.body.GetLocalCenter());
			}
		}
		
		private function Rebound(ObjectA:PhysicsObject, ObjectB:PhysicsObject, contact:b2Contact):void
		{
			if (ObjectB.name=="balloon") charobject.body.ApplyImpulse(new b2Vec2( 0, -25), charobject.body.GetLocalCenter());
		}
	}
}