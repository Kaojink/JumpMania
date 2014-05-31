package objects 
{
	import events.Collision;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import screens.InGame;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import screens.Animation;
	//
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Common.Math.b2Vec2;
	//
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	
	
	
	
	/**
	 * ...
	 * @author 
	 */
	public class Character extends Sprite
	{
		private var character_animation:Animation;
		public var dimension:Number = 128;
		private var charobject:PhysicsObject;
		private var LEFT:Boolean;
		private var RIGHT:Boolean;
		private var JUMP:Boolean;
		private var physics:PhysInjector;
		private var floor:PhysicsObject;
		private var vMaxX:Number = 5.7;
		private var lastDate:Date= new Date();
		private var currentDate:Date = new Date();
		private var lastMS:Number=0;
		private var newMS:Number = 101;
		private var OnFloor:Boolean = true;
		private var SkillNameEnabled:String = "";
		private var SkillActived:Boolean = false;
		private var Lives:Number = 5; 
		private var count_jump:Number = 0;
		private var CharHit:Boolean = false;
		private var timer:Timer = new Timer(0);
		
		
		public function Character(fisicas:PhysInjector) 
		{
			super();
			physics = fisicas;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			trace("Carga Personaje");
			
			character_animation = new Animation(Assets.getAtlas());
			
			character_animation.addAnimation("Idleanimation128_", 5, true);
			character_animation.addAnimation("JumpContact", 7, false);//Fase de contacto
			character_animation.addAnimation("JumpAir", 5, false);// Fase de caida
			character_animation.addAnimation("JumpLanding",5,false)//Fase de aterrizaje
			animate("Idleanimation128_");
			
			addChild(character_animation);
			
		/*	character = new MovieClip(Assets.getAtlas().getTextures("Idleanimation128_"), 7);
			character.width = dimension/2;
			character.height = dimension;
			character.x = (Starling.current.nativeStage.stageWidth - character.width) / 2;
			character.y = (Starling.current.nativeStage.stageHeight - character.height - 100);
			Starling.juggler.add(character);
			this.addChild(character);*/
			
			//charobject = physics.injectPhysics(character, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.2, restitution: 0,linearDamping:1 } ));
			
			charobject = physics.injectPhysics(character_animation, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.2, restitution: 0, linearDamping:1 } ));
			charobject.y = 585.4750000000001;
			charobject.x = Starling.current.nativeStage.stageWidth / 2;
			charobject.physicsProperties.contactGroup = "char";
			charobject.physicsProperties.density = 1;
			charobject.body.SetFixedRotation(true);
			//charobject.physicsProperties.isDraggable = false;
			charobject.name = "char";
			
			addEventListener(KeyboardEvent.KEY_DOWN, Movement);
			addEventListener(KeyboardEvent.KEY_UP, Stop);
			addEventListener(EnterFrameEvent.ENTER_FRAME, updateMovement);
			ContactManager.onContactBegin("char", "floor", OnTheFloor);
			ContactManager.onContactEnd("char", "floor", OverTheFloor);
			
			addEventListener(Event.CHANGE, pausegame);
		}
		
		private function pausegame(e:Event):void 
		{
			
		}
		
		private function TouchEnemy(ObjectA:PhysicsObject, ObjectB:PhysicsObject, contact:b2Contact):void
		{
			trace(ObjectB.name);
			if (!CharHit)// && Lives>=1)
			{
				trace("pegado");
				TakeLife();
				trace(ObjectB.displayObject);
				physics.removePhysics(ObjectB.displayObject, true);
				
				if (Lives > 0)
				{
					CharHit = true;
					this.alpha = 0.6;
					//charobject.physicsProperties.isSensor = true;
					//character_animation.alpha = 0.6;
					timer = new Timer(1500);
					timer.addEventListener(TimerEvent.TIMER, ActiveInvincibility)
					timer.start();
					
				}
			}
		}
			
		private function Movement(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
			  case 39: //derecha
				RIGHT = true;
				break;
			  case 37: //izquierda
				LEFT = true;
				break;
			  case 32: //barra
				if (!JUMP)
				{
					lastDate = new Date(); //fecha de cuando apreto
					JUMP = true;
				}
				break;
			  case 90:
				if (SkillNameEnabled != "" && !SkillActived)
				{
					SkillActived = true;
				}
			  break;
			}
		}
		
		
		
		private function Stop(event:KeyboardEvent):void 
		{
			//trace(event.keyCode);
			switch (event.keyCode)
			{
			  case 39: //derecha
				RIGHT = false;
				break;
			  case 37: //izquierda
				LEFT = false;
				break;
			  case 32: //barra
				SkillActived = false;
				JUMP = false;
				break;
			  case 90: //barra
				SkillActived = false;
			  break;
			}
		}
		
		private function updateMovement():void
		{
			if ((parent.parent as InGame).isPauseActivated())
			{
				trace("pausa activado");
				character_animation.stop();
				removeEventListener(KeyboardEvent.KEY_DOWN, Movement);
				removeEventListener(KeyboardEvent.KEY_UP, Stop);
				timer.stop();
				//removeEventListener(EnterFrameEvent.ENTER_FRAME, updateMovement);	
				
			}
			else 
			{
				character_animation.y = charobject.y;
				
				if (charobject.x < 0) charobject.x = Starling.current.nativeStage.stageWidth;
				else if (charobject.x > Starling.current.nativeStage.stageWidth) charobject.x=0;

				if (LEFT)
				{
					character_animation.scaleX = -1;
					if (charobject.body.GetLinearVelocity().x > -5.4) charobject.body.ApplyForce(new b2Vec2( -18, 0), charobject.body.GetLocalCenter());
					else (charobject.body.SetLinearVelocity(new b2Vec2(-vMaxX, charobject.body.GetLinearVelocity().y)));
				}
				if (RIGHT) 
				{
					character_animation.scaleX = 1;
					if (charobject.body.GetLinearVelocity().x < 5.4) charobject.body.ApplyForce(new b2Vec2( 18, 0), charobject.body.GetLocalCenter());
					else (charobject.body.SetLinearVelocity(new b2Vec2(vMaxX, charobject.body.GetLinearVelocity().y)));
				}

				if (OnFloor && JUMP)
				{
					animate("JumpContact");	
					
					OnFloor = false;
					charobject.body.ApplyImpulse(new b2Vec2( 0, -20), charobject.body.GetLocalCenter()); //impulso normal	
				}
				if (charobject.body.GetLinearVelocity().y > 0 && charobject.y < 200) 
				{
					animate("JumpAir");
				}
				if (SkillActived)
				{
					SkillActived = false; 
					UseSkill(SkillNameEnabled);
				}
			}
			
		}
		
		private function OnTheFloor(ObjectA:PhysicsObject, ObjectB:PhysicsObject, contact:b2Contact):void
		{
			animate("Idleanimation128_");
			OnFloor = true;
		}
		
		private function OverTheFloor(ObjectA:PhysicsObject, ObjectB:PhysicsObject, contact:b2Contact):void
		{
			OnFloor = false;
		}
		
		public function GetPosY():Number
		{
			return charobject.y;
		}
		
		public function GetPosX():Number
		{
			return charobject.x;
		}
		
		public function GetInitPosY():Number
		{
			return 585.4750000000001;
		}
		
		public function animate(nombre:String):void
		{
			if (nombre == "ActivateAnimation" && !(parent.parent as InGame).isPauseActivated())
			{
				character_animation.resume();
				addEventListener(KeyboardEvent.KEY_DOWN, Movement);
				addEventListener(KeyboardEvent.KEY_UP, Stop);
				timer.start();
				//addEventListener(EnterFrameEvent.ENTER_FRAME, updateMovement);
				
			}
			else
			{
				if (nombre == "JumpLanding" && character_animation.AnimationCompleted("JumpAir")) character_animation.play(nombre);
				else character_animation.play(nombre);
			}
			
		}
		
		public function GetVelY():Number
		{
			return charobject.body.GetLinearVelocity().y;
		}
		
		public function EnableContact():void
		{
			ContactManager.onContactBegin("char", "enemy", TouchEnemy, true);
			ContactManager.onContactBegin("char", "balloon", Rebound, true);		
		}
		public function RestartPos():void
		{
			character_animation.visible = false;
			charobject.body.SetLinearVelocity(new b2Vec2(0, 0));
			charobject.x = Starling.current.nativeStage.stageWidth / 2;
			charobject.y = GetInitPosY();
			animate("Idleanimation128_");
			character_animation.visible = true;
			Lives = 5;
			(parent.parent as InGame).UpdateLives();
		}
		
		public function SetSkill(name:String):void
		{
			SkillNameEnabled = name;
		}
		
		private function UseSkill(IdSkill:String):void
		{
			switch (IdSkill) 
			{
				case "Extra Balloon":
					var index:Number = (parent.parent as InGame).getindex();
					var balloon:Balloon = new Balloon(physics, index, this, true);
					(parent.parent as InGame).getLayer("Balloons").addChild(balloon);
					SkillNameEnabled = "";
					break;
				case "Cape":
					if (!timer.running)
					{
						CharHit = true;
						this.alpha = 0.6;
						//charobject.physicsProperties.isSensor = true;
						timer = new Timer(10000);
						timer.addEventListener(TimerEvent.TIMER, ActiveInvincibility)
						timer.start();
						SkillNameEnabled = "";
					}
					break;
				case "Bomb Drawing":
					{
						trace("bomba usada");
						((parent.parent as InGame).getLayer("Enemies").getChildByName("foes") as Enemies).eraseenemies();
						SkillNameEnabled = "";
					}
					break;
					
			}
			
			
			
		}
		
		private function ActiveInvincibility(event:TimerEvent):void
		{
		//	trace("hola");
			CharHit = false;
			this.alpha = 1;
			//charobject.physicsProperties.isSensor = true;
			timer.reset();
			timer.removeEventListener(TimerEvent.TIMER, ActiveInvincibility);
		}
		
		public function GetLives():Number
		{
			return Lives;
		}
		
		public function TakeLife():void
		{
			Lives--;
			(parent.parent as InGame).UpdateLives();
		}
		
		
		
		private function Rebound(ObjectA:PhysicsObject, ObjectB:PhysicsObject, contact:b2Contact):void
		{
			//var ch:Balloon = ObjectB.displayObject as Balloon; permite acceder a las funciones publicas del objeto directamente
			if (ObjectA.y + 64 <= ObjectB.y + 16)
			{
				if (ObjectB.name.substr(0, 5) == "Black")
				{
					
					if (!CharHit && Lives>=1)
					{						
						TakeLife();
						if (Lives > 0)
						{
							ObjectA.body.SetLinearVelocity(new b2Vec2(ObjectA.body.GetLinearVelocity().x, 0));
							CharHit = true;
							this.alpha = 0.6;
							//charobject.physicsProperties.isSensor = true;
							timer = new Timer(1500);
							timer.addEventListener(TimerEvent.TIMER, ActiveInvincibility)
							timer.start();
							(parent.parent as InGame).DoToCorrectBalloon(ObjectB.name, "Erase");
						}
						
						
					}			
				}
				
				else 
				{
					
					ObjectA.body.SetLinearVelocity(new b2Vec2(ObjectA.body.GetLinearVelocity().x, 0));
					if (!OnFloor && JUMP)
					{
						currentDate = new Date(); //fecha de cuando choca
						lastMS = lastDate.getTime(); //tiempo de cuando apreto boton JUMP
						newMS = currentDate.getTime(); // tiempo de choque
						
						
						if (newMS - lastMS <= 100) 
						{
							ObjectA.body.ApplyImpulse(new b2Vec2( 0, -21), ObjectA.body.GetLocalCenter()); //impulso extra
							animate("JumpContact");
							JUMP = false;
							count_jump++;
							if (count_jump >= 2)
							{
								count_jump = 0;
								(parent.parent as InGame).generateItem();							
							}
						}
						
						
						else
						{
							ObjectA.body.ApplyImpulse(new b2Vec2( 0, -15), ObjectA.body.GetLocalCenter()); //impulso normal
							animate("JumpContact");
							
						}
						
					}
					else
					{
						ObjectA.body.ApplyImpulse(new b2Vec2( 0, -15), ObjectA.body.GetLocalCenter()); //impulso normal
						animate("JumpContact");
					}	
					(parent.parent as InGame).DoToCorrectBalloon(ObjectB.name, "Animate");
					(parent.parent as InGame).DoToCorrectBalloon(ObjectB.name, "TakeBalloonLife");
				}
				
			}
		}
		

		
	}
}