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
	public class Kite extends Sprite
	{
		private var KiteImage:Animation;
		private var KiteObject:PhysicsObject;
		private var physics:PhysInjector;
		private var character:Character;
		private var Xdirection:Number;
		private var PosY:Number;
		private var PausedFrame:Boolean = false;
		
		public function Kite(fisicas:PhysInjector, char:Character) 
		{
			super();
			physics = fisicas;
			character = char;
			this.addEventListener(Event.ADDED_TO_STAGE, CreateKite);
		}
		
		
		private function CreateKite():void
		{
			KiteImage = new Animation(Assets.getAtlas());
			KiteImage.width = 64;
			KiteImage.height = 32;
			KiteImage.addAnimation("Kite",7,true);
			KiteImage.play("Kite");
			KiteImage.scaleY = 0.3;
			KiteImage.scaleX = 0.3;
			addChild(KiteImage);
			
			
			KiteObject = physics.injectPhysics(KiteImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } ));
			KiteObject.body.SetFixedRotation(true);
			KiteObject.physicsProperties.contactGroup = "enemy";
			KiteObject.name = "Kite";
			KiteObject.physicsProperties.isSensor = true;
			character.EnableContact();
			GenerateKite();
			
		}
		
		private function GenerateKite():void
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
		}
		
		
		private function FlyState(e:EnterFrameEvent):void
		{
			if (KiteObject != null && KiteObject.displayObject!=null)
			{
				var currentDate:Date = new Date();
				KiteObject.y = Starling.current.root.y + PosY + (Math.cos(currentDate.getTime() * 0.001) * 100);
				
				if	((parent.parent.parent as InGame).isPauseActivated() == false)		
				{
					if (PausedFrame)
					{
						PausedFrame = false;
						KiteImage.resume();
						
					}
					KiteObject.x += Xdirection;
					if (KiteObject.x > 1000 || KiteObject.x < -200) 
					{
						this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
						KiteObject.y = Math.random() * 400 + character.GetPosY();
						GenerateKite();
					}
					
					if (KiteObject.y > character.GetPosY()+500 || KiteObject.y < character.GetPosY()-900) 
					{
						this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
						KiteObject.x = 100;
						GenerateKite();
					}
				}
				else
				{
					PausedFrame = true;
					KiteImage.stop();
				}
			}
			
			else
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
				CreateKite();
			}
		}
	}
}