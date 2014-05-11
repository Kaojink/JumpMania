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
		private var RIGHT:Boolean = false;
		private var PosY:Number;
		private var ASCEND:Boolean = false;
		private var physics:PhysInjector;
		private var Xdirection:Number;
		private var properties:PhysicsProperties = new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } );
		private var BalloonLives:Number = 5;
		private var char:Character;
		
		
		private var ind:Number;

		
		public function Balloon(fisicas:PhysInjector, index:Number, character:Character) 
		{
			super();
			physics = fisicas;
			ind = index;
			char = character;
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
			NormalBallon = new Image(Assets.getTexture("Red_Balloon"));
			NormalBallon.y = +900;
			NormalBallon.width = dimension;
			NormalBallon.height = dimension;
			this.addChild(NormalBallon);
			
			NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.CIRCLE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } ));
			NormalBallonObject.body.SetFixedRotation(true);
			if (Math.random() >= 0.5) RIGHT = true;
			
			NormalBallonObject.name = "balloon" + ind;
			NormalBallonObject.physicsProperties.isSensor = true;
			//NormalBallonObject.physicsProperties.isDraggable = false;
			
			if (RIGHT)
			{
				Xdirection = -2 - Math.random() * 1;
				NormalBallonObject.x =  700 + Math.random() * 100;			}
			else 
			{
				Xdirection = 2 + Math.random() * 1;
				NormalBallonObject.x = - Math.random() * 100;
			}	
			
			PosY = ObtainPosY() - Math.random() * 175;
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
		}
			
		private function FlyState(e:EnterFrameEvent):void
		{
			var currentDate:Date = new Date();
			NormalBallonObject.y = Starling.current.root.y + PosY + (Math.cos(currentDate.getTime() * 0.002) * 15);
			NormalBallonObject.x += Xdirection;
			
			if (NormalBallonObject.x > 800 || NormalBallonObject.x < -100) 
			{
				NormalBallonObject.physicsProperties.active = false;
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
				this.parent.removeChild(this);
			}
			
			if (NormalBallonObject.y > char.GetPosY()+600 || NormalBallonObject.y < char.GetPosY()-900) 
			{
				NormalBallonObject.physicsProperties.active = false;
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
				this.parent.removeChild(this);
			}
			
		}
		
		private function ObtainPosY():Number
		{
			var random:Number = Math.random();
			if (random <= 0.2)  return char.GetPosY() - 70; 
			if (random <= 0.7)	return char.GetPosY() -100;
			if (random <= 0.9) return char.GetPosY() - 150;
			return char.GetPosY() -225;
		}	
	}
}