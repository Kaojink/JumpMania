package objects 
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.TextureAtlas;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author 
	 */
	public class BgLayer extends Sprite
	{
		private var backgroundTop:Image;
		private var backgroundMid:Image;
		private var backgroundBot:Image;
		//private var background_Sky:Image; //esto en un principio no haria falta, porque se puede cambiar la imagen directamente
		//private var background_Space:Image;
		private var character:Character;
		private var Reload:Boolean = false;
		private var State:String = "ground";
		private var StepChangeImage:Number = 0;
		private var CurrentTexture:Texture = Assets.getTexture("BG_ground");
		private var ChangeTexture:Texture = Assets.getTexture("GroundToSky");

		
		public function BgLayer(char:Character) 
		{
			character = char;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event):void 
		{
			
			InitPos();
						
			addEventListener(EnterFrameEvent.ENTER_FRAME, Parallax);
		}
		
		private function Parallax(e:EnterFrameEvent):void 
		{	
			//trace(character.y);
			if (!Reload && character.y < 0 ) Reload = true;
			if (Reload && character.y > 0) 
			{
				//trace("Reinicio Fondo");
				Reload = false;
				CurrentTexture = Assets.getTexture("BG_ground");
				backgroundMid.texture = CurrentTexture;
				backgroundTop.texture = CurrentTexture;
				backgroundBot.texture = CurrentTexture;
				backgroundMid.y = 0;
				backgroundTop.y = backgroundMid.y -800;
				backgroundBot.y = backgroundMid.y + 800;
				StepChangeImage = 0;
				State = "ground";
				ChangeTexture = Assets.getTexture("GroundToSky");
			}
			
			if (State=="ground" && character.y < -600) //-600 es el ejemplo para que se vea pronto, falta pantalla de degradado/cambio de fondo
			{
				State = "sky";
				StepChangeImage = 4; //se le sumaria 1 para el degradado
				CurrentTexture = Assets.getTexture("BG_sky"); //hacer fondo 
			}
			
			if (State=="sky" && character.y < -2600) //-1600 es el ejemplo para que se vea pronto, falta pantalla de degradado/cambio de fondo
			{
				State = "space";
				StepChangeImage = 4;
				CurrentTexture = Assets.getTexture("BG_space"); //cambiar a un fondo que sea el del espacio
				ChangeTexture = Assets.getTexture("SkyToSpace");
			}
		
			if (character.y < backgroundMid.y)
			{
				var aux:Image = backgroundMid;
				backgroundBot.y = backgroundTop.y - 800;
				if (StepChangeImage > 0)
				{
					if (StepChangeImage == 4) //esta seria para la imagen de degradado. Esta primera imagen aparece 1000 pixeles despues del  cambio de State, en este caso apareceria en la posicion -1600
					{
						backgroundBot.texture = ChangeTexture;
					}
					else
					{
						backgroundBot.texture = CurrentTexture;

					}
					StepChangeImage--;
				}
				backgroundMid = backgroundTop;
				backgroundTop = backgroundBot;
				backgroundBot = aux;
							
			}					
		}
		
		
		private function InitPos():void
		{
			var backgroundInit:Image = new Image(Assets.getTexture("BG_ground"));//evitar parpadeo, preguntar
			backgroundInit.y = 0;
			this.addChild(backgroundInit)
			
			backgroundMid = new Image(Assets.getTexture("BG_ground"));
			backgroundMid.y = 0;
			this.addChild(backgroundMid);
			
			backgroundTop = new Image(Assets.getTexture("BG_ground"));
			backgroundTop.y = backgroundMid.y - Starling.current.nativeStage.stageWidth;
			this.addChild(backgroundTop);	
			
			backgroundBot = new Image(Assets.getTexture("BG_ground"));
			backgroundBot.y = backgroundMid.y - Starling.current.nativeStage.stageWidth;
			this.addChild(backgroundBot);
		}
		

	}

}