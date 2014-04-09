package screens 
{
	/**
	 * ...
	 * @author 
	 */
	import events.NavigationEvent;
	import objects.Character;
	import starling.events.EnterFrameEvent;

	import starling.events.Event;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.core.Starling;
	import starling.events.KeyboardEvent;
	
	import Box2D.Common.Math.b2Vec2;

	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	
	
	 public class InGame extends Sprite
	{
		private var bg:Image;
		private var char:Character;
		private var physics:PhysInjector;
		private var box:Sprite;
		
		private var floor:Sprite;
		
		public function InGame() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddetToStage);
		}
		
		private function onAddetToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddetToStage);

			trace("InGame Screen");
			
			PhysInjector.STARLING = true;
			
			bg = new Image(Assets.getTexture("BackgroundInGame"));
			bg.width = 700;
			bg.height = 800;
			this.addChild(bg);
			
			char = new Character();
			char.x = (bg.width-char.width)/2;
			char.y = bg.height-char.height-400;
			this.addChild(char);
			
			floor = new Sprite();
			floor.width = stage.stageWidth;
			floor.height = 100;
            floor.x = 0;
            floor.y = stage.stageHeight-100;
            addChild( floor );
			
			injectPhysics();
			this.addEventListener(KeyboardEvent.KEY_DOWN, Movement);
			addEventListener(Event.ENTER_FRAME, updatePhysics);
		}
		
		private function Movement(event:KeyboardEvent):void 
		{
			trace (event.keyCode);
			//izq 37 der 39 barra 32
		}
		
		public function initialize():void
		{
			this.visible = true;
		}
		
		private function updatePhysics():void
		{
			physics.update();
		}
		
		private function injectPhysics():void
		{
			physics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 60), true);
			var floorObject:PhysicsObject = physics.injectPhysics(floor, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0.5 } ));
			var charobject:PhysicsObject = physics.injectPhysics(char, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:-0.8, restitution:-0.8 } ));
			
		}
		
	}

}