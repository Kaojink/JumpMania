package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Yo 
	 */
	public class Assets
	{
		
		[Embed(source = "../assets/fondos/BackgroundInGame.jpg")]
		public static const BackgroundInGame:Class;
		
		/*[Embed(source = "../assets/graphics/welcome_hero.png")]
		public static const WelcomeHero:Class;
		
		[Embed(source = "../assets/graphics/welcome_title.png")]
		public static const WelcomeTitle:Class;
		
		[Embed(source = "../assets/graphics/welcome_playButton.png")]
		public static const WelcomePlayBtn:Class;
		
		[Embed(source = "../assets/graphics/welcome_aboutButton.png")]
		public static const WelcomeAboutBtn:Class;*/
		
		private static var gameTextures:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):starling.textures.Texture
		{
			
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap); //esto la convierte en una textura y se guarda en el diccionario
			}
			return gameTextures[name];
		}
		
	}
}