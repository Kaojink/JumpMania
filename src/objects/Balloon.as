package objects 
{
	import Box2D.Common.Math.b2Vec2;
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
		
		private function CreateNormalBallon()
		{
			NormalBallon = new Image(Assets.getTexture("Globo"));
			NormalBallon.width = dimension;
			NormalBallon.height = dimension;
			this.addChild(NormalBallon);
			
			NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:9.8 } ));
			NormalBallonObject.body.SetFixedRotation(true);
			NormalBallonObject.x = 100;
			NormalBallonObject.y = 300;
			NormalBallonObject.name = "balloon";
			//NormalBallonObject.physicsProperties.isSensor = true;
			addEventListener(EnterFrameEvent.ENTER_FRAME, AscendState);
			addEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
			
		}
		
		private function AscendState(e:EnterFrameEvent):void 
		{
			if (NormalBallonObject.body.GetLinearVelocity().y > vMax || NormalBallonObject.body.GetLinearVelocity().y < -vMax) ASCEND = !ASCEND;
		}
		
		private function FlyState(e:EnterFrameEvent):void 
		{

			if (!ASCEND)
			{
			
			}
			else
			{
				
			}
		}
		
	}

}