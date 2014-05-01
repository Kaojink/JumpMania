package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Yo 
	 */
	public class Assets
	{
		
		[Embed(source = "../assets/fondos/BackgroundGround.png")]
		public static const BG_ground:Class;
		
		[Embed(source = "../assets/fondos/ground-900x100.png")]
		public static const Ground:Class;
		
		[Embed(source = "../assets/personajes/globo.png")]
		public static const Globo:Class;
		
		/*[Embed(source = "../assets/graphics/welcome_hero.png")]
		public static const WelcomeHero:Class;
		
		[Embed(source = "../assets/graphics/welcome_title.png")]
		public static const WelcomeTitle:Class;
		
		[Embed(source = "../assets/graphics/welcome_playButton.png")]
		public static const WelcomePlayBtn:Class;
		
		[Embed(source = "../assets/graphics/welcome_aboutButton.png")]
		public static const WelcomeAboutBtn:Class;*/
		
		private static var gameTextures:Dictionary = new Dictionary();
		
		private static var gameTextureAtlas:TextureAtlas;
		
		[Embed(source = "../assets/personajes/atlas.png")]
		public static const Atlas_textureGame:Class;
		
		[Embed(source = "../assets/personajes/atlas.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGame:Class;
		
		public static function getAtlas():TextureAtlas
		{ 
			if (gameTextureAtlas == null)
			{
				var texture:Texture = getTexture("Atlas_textureGame");
				var xml:XML = XML( new AtlasXmlGame());
				gameTextureAtlas = new TextureAtlas(texture, xml);
				
			}
			return gameTextureAtlas;
		}
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