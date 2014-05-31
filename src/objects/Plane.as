package objects 
{
	import Box2D.Common.Math.b2Vec2;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsProperties;
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
	public class Plane extends Sprite
	{
		private var PlaneImage:Image;
		private var PlaneObject:PhysicsObject;
		private var physics:PhysInjector;
		private var character:Character;
		private var Xdirection:Number;
		private var PlanePosY:Number; 
		private var Box1Activated:Boolean;
		private var Box2Activated:Boolean;
		private var Box3Activated:Boolean;
		private var BoxImage1:Image;
		private var BoxObject1:PhysicsObject;
		private var BoxImage2:Image;
		private var BoxObject2:PhysicsObject;
		private var BoxImage3:Image;
		private var BoxObject3:PhysicsObject;
		
		public function Plane(fisicas:PhysInjector, char:Character) 
		{
			super();
			physics = fisicas;
			character = char;
			this.addEventListener(Event.ADDED_TO_STAGE, CreatePlane);
		}
		
		
		private function CreatePlane():void
		{
			PlaneImage = new Image(Assets.getTexture("Plane"));
			addChild(PlaneImage);
			
			PlaneObject = physics.injectPhysics(PlaneImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:100 } ));
			//PlaneObject.body.SetBullet(true);
			PlaneObject.body.SetFixedRotation(true);
			PlaneObject.physicsProperties.contactGroup = "enemy";
			PlaneObject.name = "plane";
			PlaneObject.physicsProperties.isSensor = true;
			//character.EnableContact();
			//addChild(BoxImage1);
			//addChild(BoxImage2);
			//addChild(BoxImage3);
			GeneratePlane();
			
		}
		
		private function GeneratePlane():void
		{
			//RIGHT es que viene de la derecha
			Box1Activated = false;
			Box2Activated = false;
			Box3Activated = false;
			
			PlanePosY = character.GetPosY() - 450 -  Math.random() * 100 ;
			var RIGHT:Boolean = true; 
			if (Math.random() >= 0.5) RIGHT = false;
			
			if (RIGHT)
			{
				PlaneImage.scaleX = 1;
				PlaneObject.x = Starling.current.nativeStage.stageWidth + PlaneImage.width/2;
				Xdirection = -7 - Math.random() * 4;
			}
			else
			{
				PlaneImage.scaleX = -1;
				PlaneObject.x = -PlaneImage.width/2;
				Xdirection = 7 + Math.random() * 4;
			}
			//PlaneObject.body.SetLinearVelocity(new b2Vec2(Xdirection, 0));
			addEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
			addEventListener(EnterFrameEvent.ENTER_FRAME, BoxFall);
			//PlaneObject.physicsProperties.density = 2;
		}
		

		
		
		private function FlyState(e:EnterFrameEvent):void
		{
			//trace(character.GetPosY());
			if (PlaneObject != null && PlaneObject.displayObject != null)
			{
				PlaneObject.y = PlanePosY;
				PlaneObject.x += Xdirection;
				if (Xdirection<0)
				{
					if (!Box1Activated)
					{
					
						if (PlaneObject.x < (515 + ((Math.random() - 0.5) * 230)))
						{
							if (BoxObject1 != null && BoxObject1.displayObject !=null) 
							{
								physics.removePhysics(BoxImage1, true);
							}
							Box1Activated = true;
							BoxImage1 = new Image(Assets.getAtlas().getTexture("box_plane"));
							BoxImage1.y = 1000;
							addChild(BoxImage1);
							BoxObject1 = physics.injectPhysics(BoxImage1, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:3 } ));
							BoxObject1.body.ApplyTorque(0.8);
							//BoxObject1.body.SetFixedRotation(true);
							BoxObject1.x = PlaneObject.x;
							BoxObject1.y = PlaneObject.y + 15;
							BoxObject1.physicsProperties.contactGroup = "enemy";
							
						}
					}
					if (!Box2Activated)
					{
						if (PlaneObject.x < (320 + ((Math.random() - 0.5) * 230)))
						{
							if (BoxObject2 != null && BoxObject2.displayObject !=null) 
							{
								physics.removePhysics(BoxImage2, true);
							}
							Box2Activated = true;
							BoxImage2 = new Image(Assets.getAtlas().getTexture("box_plane"));
							BoxImage2.y = 1000;
							addChild(BoxImage2);
							BoxObject2 = physics.injectPhysics(BoxImage2, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:3 } ));
							BoxObject2.body.ApplyTorque(0.8);
							//BoxObject2.body.SetFixedRotation(true);
							BoxObject2.x = PlaneObject.x;
							BoxObject2.y = PlaneObject.y + 15;
							BoxObject2.physicsProperties.contactGroup = "enemy";
							
						}
					}
					if (!Box3Activated)
					{
						if (PlaneObject.x < (115 + ((Math.random() - 0.5) * 230)))
						{
							if (BoxObject3 != null && BoxObject3.displayObject !=null) 
							{
								physics.removePhysics(BoxImage3, true);
							}
							Box3Activated = true;
							BoxImage3 = new Image(Assets.getAtlas().getTexture("box_plane"));
							BoxImage3.y = 1000;
							addChild(BoxImage3);
							BoxObject3 = physics.injectPhysics(BoxImage3, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:3 } ));
							BoxObject3.body.ApplyTorque(0.8);
							//BoxObject3.body.SetFixedRotation(true);
							BoxObject3.x = PlaneObject.x;
							BoxObject3.y = PlaneObject.y + 15;
							BoxObject3.physicsProperties.contactGroup = "enemy";
							
						}
					}
				}
				else
				{
					if (!Box1Activated)
					{
						if (PlaneObject.x > ((175 + ((Math.random() - 0.5) * 230))))
						{
							if (BoxObject1 != null && BoxObject1.displayObject !=null) 
							{
								physics.removePhysics(BoxImage1, true);
							}
							Box1Activated = true;
							BoxImage1 = new Image(Assets.getAtlas().getTexture("box_plane"));
							BoxImage1.y = 1000;
							addChild(BoxImage1);
							BoxObject1 = physics.injectPhysics(BoxImage1, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:3 } ));
							BoxObject1.body.ApplyTorque(0.8);
							//BoxObject1.body.SetFixedRotation(true);
							BoxObject1.x = PlaneObject.x;
							BoxObject1.y = PlaneObject.y + 15;
							BoxObject1.physicsProperties.contactGroup = "enemy";
							
						}
					}
					else
					{
						if (!Box2Activated)
						{
							if (PlaneObject.x > ((410 + ((Math.random() - 0.5) * 230))))
							{
								if (BoxObject2 != null && BoxObject2.displayObject !=null) 
								{
									physics.removePhysics(BoxImage2, true);
								}
								Box2Activated = true;
								BoxImage2 = new Image(Assets.getAtlas().getTexture("box_plane"));
								BoxImage2.y = 1000;
								addChild(BoxImage2);
								BoxObject2 = physics.injectPhysics(BoxImage2, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:3 } ));
								BoxObject2.body.ApplyTorque(0.8);
								//BoxObject2.body.SetFixedRotation(true);
								BoxObject2.x = PlaneObject.x;
								BoxObject2.y = PlaneObject.y + 15;
								BoxObject2.physicsProperties.contactGroup = "enemy";
							}
						}
						else
						{
							if (!Box3Activated)
							{
								if (PlaneObject.x > (635 + ((Math.random() - 0.5) * 230)))
								{
									if (BoxObject3 != null && BoxObject3.displayObject !=null) 
									{
										physics.removePhysics(BoxImage3, true);
									}
									Box3Activated = true;
									BoxImage3 = new Image(Assets.getAtlas().getTexture("box_plane"));
									BoxImage3.y = 1000;
									addChild(BoxImage3);
									BoxObject3 = physics.injectPhysics(BoxImage3, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0, linearDamping:3 } ));
									BoxObject3.body.ApplyTorque(0.8);
									//BoxObject3.body.SetFixedRotation(true);
									BoxObject3.x = PlaneObject.x;
									BoxObject3.y = PlaneObject.y + 15;
									BoxObject3.physicsProperties.contactGroup = "enemy";
									
								}
							}
						}
					}
				}
				if (PlaneObject.x > 1000 || PlaneObject.x < -200) 
				{
					this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
					physics.removePhysics(PlaneImage, true);
					//PlaneObject.y = Math.random() * 400 + character.GetPosY();
					//GeneratePlane();
				}
				
				else
				{
					if (PlaneObject.y > character.GetPosY()+600 || PlaneObject.y < character.GetPosY()-600) 
					{
						this.removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
						physics.removePhysics(PlaneImage, true);
						//PlaneObject.x = 100;
						//GeneratePlane();
					}
				}
				

			}
		/*	else
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, FlyState);
				CreatePlane();
			}*/	

		}
		
		private function BoxFall(e:EnterFrameEvent):void 
		{
			if (Box1Activated && BoxObject1.y > character.GetPosY() + 600)
			{
				physics.removePhysics(BoxImage1, true);
				removeEventListener(EnterFrameEvent.ENTER_FRAME, BoxFall);
			}
			if (Box2Activated && BoxObject2.y > character.GetPosY() + 600)
			{
				physics.removePhysics(BoxImage2, true);
			}
			if (Box3Activated && BoxObject3.y > character.GetPosY() + 600)
			{
				physics.removePhysics(BoxImage3, true);
				removeEventListener(EnterFrameEvent.ENTER_FRAME, BoxFall);
			}
		}
		
		
		public function ErasePhysics():void
		{
			if (PlaneObject != null && PlaneObject.displayObject != null)
			{
				physics.removePhysics(PlaneImage, true)
			}
			
			if (BoxObject1 != null && BoxObject1.displayObject !=null) 
			{
				physics.removePhysics(BoxImage1, true);
			}
			
			if (BoxObject2 != null && BoxObject2.displayObject !=null) 
			{
				physics.removePhysics(BoxImage2, true);
			}
			if (BoxObject3 != null && BoxObject3.displayObject != null)
			{
				physics.removePhysics(BoxImage3, true);
			}
		}
	}
}