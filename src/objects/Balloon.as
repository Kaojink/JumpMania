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
	import screens.Animation;
	/**
	 * ...
	 * @author 
	 */
	public class Balloon extends Sprite
	{
		private var NormalBallon:Animation;
		private var NormalBallonObject:PhysicsObject;
		private var dimension:Number = 64;
		private var vMax:Number = 0.6;
		private var RIGHT:Boolean = false;
		private var PosY:Number;
		private var ASCEND:Boolean = false;
		private var physics:PhysInjector;
		private var Xdirection:Number=0;
		private var properties:PhysicsProperties = new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } );
		private var BalloonLives:Number = 5;
		private var isUpgrade:Boolean = false;
		private var char:Character;
		private var colour:String;
		
		
		private var ind:Number;

		
		public function Balloon(fisicas:PhysInjector, index:Number, character:Character, boolean:Boolean) 
		{
			super();
			physics = fisicas;
			ind = index;
			char = character;
			isUpgrade = boolean;
			//name = "balloon" + index;
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
			
			if (isUpgrade) colour = "Golden";
			else {
				switch (Math.floor(Math.random() * (7 )) + 1)
				{
					case 1: colour = "Red"; break;
					
					case 2: colour = "Blue"; break;
					
					case 3: colour = "DarkBlue"; break;
					
					case 4: colour = "Pink"; break;
					
					case 5: colour = "Violet"; break;
					
					case 6: colour = "Green"; break;
					
					case 7: colour = "Black"; break;
				}
			}
			
			NormalBallon = new Animation(Assets.getAtlas());
			NormalBallon.addAnimation(colour + "_Balloon01", 1, false);
			NormalBallon.addAnimation(colour + "_Balloon", 18, false);
			NormalBallon.play(colour + "_Balloon01");
			NormalBallon.addAnimation(colour + "_BalloonReverse", 18, false);
			NormalBallon.y = +900;
			NormalBallon.width = dimension;
			NormalBallon.height = dimension;
			this.addChild(NormalBallon);
			NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.CIRCLE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } ));
			NormalBallonObject.physicsProperties.contactGroup = "balloon";
			//NormalBallonObject.name = "balloon" + ind;
			
			if (colour != "Black")
			{				
				//NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.CIRCLE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } ));
				NormalBallonObject.name = "balloon" + ind;
				//NormalBallonObject.physicsProperties.contactGroup = "balloon";

			}
			else 
			{
				//NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.CIRCLE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100, contactGroup:"balloon" } ));
				//NormalBallonObject.id = "Black";
				//NormalBallonObject.physicsProperties.contactGroup = "enemy";
				//NormalBallonObject.name = "enemy";
				NormalBallonObject.name = "Black" + ind;
			}		
			
			this.name = NormalBallonObject.name;
			
			NormalBallonObject.body.SetFixedRotation(true);
			if (Math.random() >= 0.5) RIGHT = true;
			
			NormalBallonObject.physicsProperties.isSensor = true;
			//NormalBallonObject.physicsProperties.isDraggable = false;
			
			if (!isUpgrade) 
			{
				if (RIGHT)
				{
					Xdirection = -2 - Math.random() * 1;
					NormalBallonObject.x =  700 + Math.random() * 100;	
				}
				else 
				{
					Xdirection = 2 + Math.random() * 1;
					NormalBallonObject.x = - Math.random() * 100;
				}	
				PosY = ObtainPosY() - Math.random() * 175;
			}
			else
			{
				this.visible = false;
				NormalBallon.x = char.GetPosX();
				NormalBallonObject.x = NormalBallon.x;
				PosY = char.GetPosY() + 200;
				this.visible = true;
			}

			addEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
		}
			
		private function FlyState(e:EnterFrameEvent):void
		{
			var currentDate:Date = new Date();
			NormalBallonObject.y = Starling.current.root.y + PosY + (Math.cos(currentDate.getTime() * 0.002) * 15);
			NormalBallonObject.x += Xdirection;
			
			if (NormalBallonObject.x > 800 || NormalBallonObject.x < -100) 
			{
				EraseBalloon();
			}
			
			else 
			{
				if (NormalBallonObject.y > char.GetPosY() + 600 || NormalBallonObject.y < char.GetPosY() - 900) 
				{
					EraseBalloon();
				}
			}
		}
		
		public function EraseBalloon():void
		{
			NormalBallonObject.physicsProperties.active = false;
			removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
			parent.removeChild(this);
		}
		
		private function ObtainPosY():Number
		{
			var random:Number = Math.random();
			if (random <= 0.2)  return char.GetPosY() - 70; 
			if (random <= 0.7)	return char.GetPosY() -100;
			if (random <= 0.9) return char.GetPosY() - 150;
			return char.GetPosY() -225;
			
		}	
		
		
		public function animateBalloon():void
		{
			//trace("animado");
			NormalBallon.play(colour + "_Balloon");
			addEventListener(EnterFrameEvent.ENTER_FRAME, ReturnNormalFrame);
		}
		
		private function ReturnNormalFrame(e:EnterFrameEvent):void 
		{
			if (NormalBallon.AnimationCompleted(colour + "_Balloon"))
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, ReturnNormalFrame);
				NormalBallon.play(colour + "_BalloonReverse");
			}
		}
	}
}