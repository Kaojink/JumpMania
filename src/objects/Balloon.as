package objects 
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
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
			NormalBallon = new Image(Assets.getTexture("Globo"));
			NormalBallon.width = dimension;
			NormalBallon.height = dimension;
			
			this.addChild(NormalBallon);
			
			NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, linearDamping:9.8 } ));
			NormalBallonObject.body.SetFixedRotation(true);
			NormalBallonObject.x = 100;
			NormalBallonObject.y = 300;
			
			//CreateNormalBallon();
		}
		
		/*private function CreateNormalBallon()
		{
			NormalBallon = new Image(Assets.getTexture("Globo"));
			NormalBallon.width = NormalBallon.height = dimension;
			NormalBallon.x = 100;
			NormalBallon.y = 300;
			NormalBallonObject = physics.injectPhysics(NormalBallon, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:1000, linearDamping:9.8 } ));
			NormalBallonObject.body.SetFixedRotation(true);
			this.addChild(NormalBallon);
		}*/
		
	}

}