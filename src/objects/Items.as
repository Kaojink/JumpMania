package objects 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
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
	public class Items extends Sprite
	{
		private var ItemImage:Image;
		private var lastDate:Date = new Date();
		private var lastNumber:Number = -1;
		private var currentNumber:Number = -2;
		private var type:String = "null";	
		private var timer:Timer;
		
		public function Items() 
		{
			super()
			addEventListener(Event.ADDED_TO_STAGE, CreateItems);
		}
		
		private function CreateItems(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, CreateItems);
			ItemImage = new Image(Assets.getAtlas().getTexture("Cape"));
			type = "Cape";
			ItemImage.y = (parent.parent as InGame).getChar().y - Starling.current.nativeStage.stageHeight;
			ItemImage.x = randomRange(0, Starling.current.nativeStage.stageWidth - ItemImage.width);
			ItemImage.width = 32;
			ItemImage.height = 32;
			addChild(ItemImage);
			
			timer = new Timer(250);
			timer.addEventListener(TimerEvent.TIMER, Update);
			timer.start();
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, Movement);
		}
		
		private function Movement(event:EnterFrameEvent):void
		{
			ItemImage.y += 4;
			if (getBounds(ItemImage).intersects(getBounds((parent.parent as InGame).getChar()))) trace("un mojon pa mi");
		}
		
		
		private function Update(event:TimerEvent):void
		{
			//cada 0'25 segundos
			ChangeItem(randomRange(0, 10));
		}
		
		private function ChangeItem(prob:Number):void
		{
			trace(prob);
			switch (prob) 
			{
				case 0:
					ItemImage.texture = Assets.getAtlas().getTexture("Extra_Balloon");
					type = "Extra Balloon";
					break;
					
				case 1:
					ItemImage.texture = Assets.getAtlas().getTexture("Bomb_drawing");
					type = "Bomb Drawing";
					
					break;
					
				case 5:
					ItemImage.texture = Assets.getAtlas().getTexture("Cape");
					type = "Cape";
					break;
				break;
			}
		}
		
		private function randomRange(minNum:Number, maxNum:Number):Number 
		{
			return Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum;
			
		}
		
		public function UpgradeType():String
		{
			return type;
		}
	}

}