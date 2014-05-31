package objects 
{
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsProperties;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class Enemies extends Sprite
	{
		private var plane:Plane;
		private var kite:Kite;
		private var physics:PhysInjector;
		private var character:Character;
		
		public function Enemies(fisicas:PhysInjector, char:Character) 
		{
			super();
			physics = fisicas;
			character = char;
			this.addEventListener(Event.ADDED_TO_STAGE, CreateEnemies);
		}
		
		private function CreateEnemies():void
		{
			plane = new Plane(physics, character);
			this.addChild(plane);
			
			kite = new Kite(physics, character);
			this.addChild(kite);
		}
		
		public function eraseenemies():void
		{
			plane.removeEventListeners();
			plane.ErasePhysics();
			kite.removeEventListeners();
		//	physics.removePhysics(plane, true);
		//	physics.removePhysics(kite, true);
			removeChild(plane);
			removeChild(kite);
		}
	}
}