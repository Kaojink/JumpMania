package objects 
{
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsProperties;
	import screens.Animation;
	import screens.InGame;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class Meteorite extends Sprite
	{
		private var MeteoriteImage:Animation;
		private var MeteoriteObject:PhysicsObject;
		private var physics:PhysInjector;
		private var character:Character;
		private var PausedFrame:Boolean = false;
		
		public function Meteorite(fisicas:PhysInjector, char:Character) 
		{
			super();
			physics = fisicas;
			character = char;
			this.addEventListener(Event.ADDED_TO_STAGE, CreateMeteorite);
		}
		
		
		private function CreateMeteorite():void
		{
			MeteoriteImage = new Animation(Assets.getAtlas());
			//MeteoriteImage.width = 32;
			//MeteoriteImage.height = 64;
			MeteoriteImage.pivotX = MeteoriteImage.width / 2;
			MeteoriteImage.pivotY = MeteoriteImage.height / 2;
			MeteoriteImage.addAnimation("cloud",7,true);
			MeteoriteImage.play("cloud");
			
			trace(MeteoriteImage.height);
			addChild(MeteoriteImage);
			
			
			MeteoriteObject = physics.injectPhysics(MeteoriteImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:3 } ));
			MeteoriteObject.body.SetFixedRotation(true);
			MeteoriteObject.physicsProperties.contactGroup = "enemy";
			MeteoriteObject.name = "Meteorite";
			MeteoriteObject.y = character.GetPosY() - 800;
			MeteoriteObject.x = Math.floor(Math.random() * (650 - 50 + 1)) + 50;	
			trace("ASDFA");

			addEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
			
		}
		
		/*private function GenerateKite():void
		{
			var RIGHT:Boolean = true; //RIGHT es que viene de la derecha
			KiteObject.y = character.GetPosY() - 200 -  Math.random() * 300 ;
			PosY = KiteObject.y;
			if (Math.random() >= 0.5) RIGHT = false;
			
			if (RIGHT)
			{
				KiteImage.scaleX = -0.3;
				KiteObject.x = Starling.current.nativeStage.stageWidth + KiteImage.width/2;
				Xdirection = -3 - Math.random() * 2;
			}
			else
			{
				KiteImage.scaleX = 0.3;
				KiteObject.x = -KiteImage.width/2;
				Xdirection = 3 + Math.random() * 2;
			}
			addEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
		}*/
		
		
		private function FlyState(e:EnterFrameEvent):void
		{
			//if (KiteObject != null && KiteObject.displayObject!=null)
			if (MeteoriteObject.displayObject!=null)
			{				
				if	((parent.parent.parent as InGame).isPauseActivated() == false)		
				{
					if (PausedFrame)
					{
						PausedFrame = false;
						MeteoriteImage.resume();
						
					}
					if (MeteoriteObject.x > 1000 || MeteoriteObject.x < -200) 
					{
						this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
						physics.removePhysics(MeteoriteImage, true);
						//MeteoriteObject.y = Math.random() * 400 + character.GetPosY();
						//GenerateMeteorite();
					}
					
					if (MeteoriteObject.y > character.GetPosY()+600 || MeteoriteObject.y < character.GetPosY()-1500) 
					{
						this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
						physics.removePhysics(MeteoriteImage, true);
						//MeteoriteObject.x = 100;
						//GenerateMeteorite();
					}
				}
				else
				{
					PausedFrame = true;
					MeteoriteImage.stop();
				}
			}
			
			else
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
				//CreateMeteorite();
			}
		}
		
		public function ErasePhysics():void
		{
			physics.removePhysics(MeteoriteImage, true);
			
		}
	}
}