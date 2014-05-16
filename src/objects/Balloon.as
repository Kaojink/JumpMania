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
		private var NormalBallon:Image;
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
		private var colour:String = "Red";
		
		
		private var ind:Number;

		
		public function Balloon(fisicas:PhysInjector, index:Number, character:Character, boolean:Boolean) 
		{
			super();
			physics = fisicas;
			ind = index;
			char = character;
			isUpgrade = boolean;
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
			if (Math.random() > 0.5) colour = "Black";
			
			if (colour == "Red" || isUpgrade)
			{
				/*NormalBallon = new Animation(Assets.getAtlas());
				NormalBallon.addAnimation("Red_Balloon01", 1, false);
				NormalBallon.addAnimation("Red_Balloon", 18, false);
				NormalBallon.play("Red_Balloon01");
				NormalBallon.addAnimation("Red_BalloonReverse", 18, false);*/
				NormalBallon = new Image(Assets.getTexture("Red_Balloon"));
				NormalBallon.y = +900;
				NormalBallon.width = dimension;
				NormalBallon.height = dimension;
				this.addChild(NormalBallon);
				NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.CIRCLE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } ));
				NormalBallonObject.name = "balloon" + ind;
				NormalBallonObject.physicsProperties.contactGroup = "balloon";

			}
			else 
			{
				NormalBallon = new Image(Assets.getTexture("Black_Balloon"));
				NormalBallon.y = +900;
				NormalBallon.width = dimension;
				NormalBallon.height = dimension;
				this.addChild(NormalBallon);
				NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.CIRCLE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100, contactGroup:"enemy" } ));
				//NormalBallonObject.physicsProperties.contactGroup = "enemy";
				NormalBallonObject.name = "enemy";
				//NormalBallonObject.name = "balloon" + ind;

			}		
			
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
				NormalBallonObject.physicsProperties.active = false;
				this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
				this.parent.removeChild(this);
			}
			
			else 
			{
				if (NormalBallonObject.y > char.GetPosY() + 600 || NormalBallonObject.y < char.GetPosY() - 900) 
				{
					NormalBallonObject.physicsProperties.active = false;
					this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
					this.parent.removeChild(this);
				}
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
		
		
		public function animateBalloon(nombre:String):void
		{
			//trace("animado");
			NormalBallon.play("Red_Balloon");
			//NormalBallon.play(nombre);
			addEventListener(EnterFrameEvent.ENTER_FRAME, ReturnNormalFrame);
		}
		
		/*private function ReturnNormalFrame(e:EnterFrameEvent):void 
		{
			if (NormalBallon.AnimationCompleted("Red_Balloon"))
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, ReturnNormalFrame);
				//NormalBallon.play("Red_BalloonReverse");
			}
		}*/
		//
			
		
		public function GetColour():String
		{
			return colour;
		}
			
		/*private function Rebound(ObjectA:PhysicsObject, ObjectB:PhysicsObject, contact:b2contact):void
		{
			if (ObjectA.y + 64 <= ObjectB.y + 16)
			{
				//trace("entra");
				ObjectA.body.SetLinearVelocity(new b2Vec2(ObjectA.body.GetLinearVelocity().x, 0));
				if (!char.GetOnFloorValue() && char.GetJumpValue())
				{
					currentDate = new Date(); //fecha de cuando choca
					lastMS = char.GetLastDate().getTime(); //tiempo de cuando apreto boton JUMP
					newMS = currentDate.getTime(); // tiempo de choque
					
					if (newMS - lastMS <= 100) 
					{
						ObjectA.body.ApplyImpulse(new b2Vec2( 0, -20), ObjectA.body.GetLocalCenter()); //impulso extra
						char.animate("JumpContact");
						char.Impulsed();
					}
					
					else
					{
						ObjectA.body.ApplyImpulse(new b2Vec2( 0, -15), ObjectA.body.GetLocalCenter()); //impulso normal
						char.animate("JumpContact");
					}
					
				}
				else
				{
					ObjectA.body.ApplyImpulse(new b2Vec2( 0, -15), ObjectA.body.GetLocalCenter()); //impulso normal
					char.animate("JumpContact");
				}	
				//balloon.animateBalloon();
			}
		}*/
	}
}