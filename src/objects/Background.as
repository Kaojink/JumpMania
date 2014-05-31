package objects 
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.TextureAtlas;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	/**
	 * ...
	 * @author 
	 */
	public class Background extends Sprite
	{
		private var Tree:Image;
		private var Mountain:Image;
		private var physics:PhysInjector;
		private var floor:Image;
		private var floorObject:PhysicsObject;
		
		public function Background(fisicas:PhysInjector) 
		{
			physics = fisicas;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void 
		{
			floor = new Image(Assets.getTexture("Ground"));
			floor.width = 900;
			floor.height = 150;
            floor.x = -100;
            floor.y = 650;
            addChild( floor );
			floorObject = physics.injectPhysics(floor, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.8, restitution:0 } ));
			floorObject.name = "floor";
			
			Mountain = new Image(Assets.getTexture("Mountain"));
			Mountain.y = Starling.current.nativeStage.stageHeight- 149 - Mountain.height;
			Mountain.x = -20;
			this.addChild(Mountain);
			
			Tree = new Image(Assets.getTexture("Tree"));
			Tree.y = Starling.current.nativeStage.stageHeight- 149 - Tree.height;
			Tree.x = -20;
			this.addChild(Tree);
		}
	
	}

}