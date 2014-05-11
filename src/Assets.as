package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import screens.Animation
	/**
	 * ...
	 * @author Yo 
	 */
	public class Assets
	{
		
		[Embed(source = "../assets/fondos/background-Ground.png")]
		public static const BG_ground:Class;
		
		[Embed(source = "../assets/fondos/DegGroundToSky.png")]
		public static const GroundToSky:Class;
		
		[Embed(source = "../assets/fondos/background2.png")]
		public static const BG_sky:Class;
		
		[Embed(source = "../assets/fondos/DegSkyToSpace.png")]
		public static const SkyToSpace:Class;
		
		[Embed(source = "../assets/fondos/background3.png")]
		public static const BG_space:Class;
		
		[Embed(source = "../assets/fondos/ground-900x150.png")]
		public static const Ground:Class;
		
		[Embed(source = "../assets/fondos/Tree-400x500.png")]
		public static const Tree:Class;
		
		[Embed(source = "../assets/fondos/Mountain-800-172.png")]
		public static const Mountain:Class;
		
		[Embed(source = "../assets/personajes/Plane.png")]
		public static const Plane:Class;
		
		
		[Embed(source = "../assets/personajes/Red_Balloon.png")]
		public static const Red_Balloon:Class;
		
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