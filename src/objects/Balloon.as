package objects 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.Math.b2Vec3;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EnterFrameEvent;
	//
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	
	
	
	/**
	 * ...
	 * @author 
	 */
	public class Balloon extends Sprite
	{
		private var NormalBallon:Image;
		private var NormalBallonObject:PhysicsObject;
		private var dimension:Number = 64;
		private var vMax:Number = 0.6;
		private var PosX:Number;
		private var PosY:Number;
		private var ASCEND:Boolean = false;
		private var physics:PhysInjector;

		
		public function Balloon(fisicas:PhysInjector) 
		{
			super();
			physics = fisicas;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			trace("Balloon creado");
			CreateNormalBallon();			
		}
		
		private function CreateNormalBallon():void
		{
			trace("hola");
			NormalBallon = new Image(Assets.getTexture("Globo"));
			NormalBallon.width = dimension;
			NormalBallon.height = dimension;
			this.addChild(NormalBallon);
			
			NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.CIRCLE, new PhysicsProperties( { isDynamic:true } )); //, friction:0, linearDamping:0 } ));
			NormalBallonObject.body.SetFixedRotation(true);
			NormalBallonObject.x = 600 + Math.random() * 100;
			//NormalBallonObject.y = 600 + Math.random() * 100;
			//PosX = 600 + Math.random() * 100;
			PosY = 600 + Math.random() * 100;
			trace(NormalBallonObject.x);
			NormalBallonObject.name = "balloon";
			NormalBallonObject.physicsProperties.isSensor = true;
			NormalBallonObject.physicsProperties.isDraggable = false;
			//addEventListener(EnterFrameEvent.ENTER_FRAME, AscendState);
			addEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
			
		}
		
		/*private function AscendState(e:EnterFrameEvent):void
		{
			if (NormalBallonObject.body.GetLinearVelocity().y > vMax || NormalBallonObject.body.GetLinearVelocity().y < -vMax) 
			{
				NormalBallonObject.body.SetLinearVelocity(new b2Vec2(0, 0));
				ASCEND = !ASCEND;
			}
		}*/
		
		private function FlyState(e:EnterFrameEvent):void 
		{
			var currentDate:Date = new Date();
			NormalBallonObject.y = PosY + (Math.cos(currentDate.getTime() * 0.002) * 15);
			/*if (ASCEND)
			{
				//trace("1");
				NormalBallonObject.body.ApplyForce(new b2Vec2(0, -9.8),NormalBallonObject.body.GetLocalCenter() );
			}
			else
			{
				//trace("2");
				NormalBallonObject.body.ApplyForce(new b2Vec2(0, 9.8),NormalBallonObject.body.GetLocalCenter() );
			}*/
		}
		
		
		
	}
}