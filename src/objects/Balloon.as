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
		private var RIGHT:Boolean = false;
		private var PosY:Number;
		private var ASCEND:Boolean = false;
		private var physics:PhysInjector;
		private var Xdirection:Number;
		private var properties:PhysicsProperties = new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } );
		//public var BalloonLives:Number = 3;
		
		private var ind:Number;

		
		public function Balloon(fisicas:PhysInjector, index:Number) 
		{
			super();
			physics = fisicas;
			ind = index;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			//trace("Balloon creado");
			CreateNormalBallon();			
		}
		
		private function CreateNormalBallon():void
		{
			//trace("hola");
			NormalBallon = new Image(Assets.getTexture("Globo"));
			NormalBallon.y = +900;
			NormalBallon.width = dimension;
			NormalBallon.height = dimension;
			this.addChild(NormalBallon);
			
			NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.CIRCLE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } ));
			NormalBallonObject.body.SetFixedRotation(true);
			//NormalBallonObject.x =  Math.random() * 700;
			//NormalBallonObject.y = 600 + Math.random() * 100;
			if (Math.random() >= 0.5) RIGHT = true;
			//PosY = 600 + Math.random() * 100;
			
			NormalBallonObject.name = "balloon" + ind;
			NormalBallonObject.physicsProperties.isSensor = true;
			//NormalBallonObject.physicsProperties.isDraggable = false;
			
			if (RIGHT)
			{
				Xdirection = -1 - Math.random() * 2;;
				NormalBallonObject.x =  700 + Math.random() * 100;			}
			else 
			{
				Xdirection = 1 + Math.random() * 2;
				NormalBallonObject.x = - Math.random() * 100;
			}	
			//trace(PosY);
			PosY = parent.y - 100 + Math.random() * 600;
			//trace(PosY);

		//	PosY = Starling.current.nativeStage.stageHeight - 200 - Math.random() * 700;
			addEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
		}
			
		private function FlyState(e:EnterFrameEvent):void
		{
			var currentDate:Date = new Date();
			NormalBallonObject.y = Starling.current.root.y + PosY + (Math.cos(currentDate.getTime() * 0.002) * 15);
			NormalBallonObject.x += Xdirection;
			
			if (NormalBallonObject.x > 800 || NormalBallonObject.x < -100) 
			{
				//trace("borrado");
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
				this.parent.removeChild(this);
			}
			
		}
				
	}
}