package screens 
{
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Oxana
	 */
	public class Animation extends Sprite
	{
			private var _animations:Dictionary;
			private var _atlas:TextureAtlas;
			private var _currentAnimation:String;
			
			
		public function Animation(atlas:TextureAtlas)
		{
			super();
			_animations = new Dictionary();
			_atlas = atlas;
		}
		
		public function addAnimation(name:String, frameRate:int,loop:Boolean):void
		{
            var newMC:MovieClip = new MovieClip(_atlas.getTextures(name), frameRate); //Buscar en atlas la animacion
			newMC.loop = loop;
            _animations[name] = newMC; //Anyade al diccionario
			
		}
		
		
		public function play(name:String):void
		{
			if (_currentAnimation == name && _currentAnimation != "JumpContact") {
				return;
			}
			if (!_animations[name])
			{
				throw new Error ("no animation called" +name);
			}
			if (_currentAnimation)
			{
				(_animations[_currentAnimation] as MovieClip).stop();
				removeChild(_animations[_currentAnimation]);
				Starling.juggler.remove(_animations[_currentAnimation]);
			}
			
			(_animations[name] as MovieClip).play();
			addChild(_animations[name]);
			Starling.juggler.add(_animations[name]);
			_currentAnimation = name;
		}
		
		public function AnimationCompleted(name:String):Boolean
		{
			return (_animations[name] as MovieClip).isPlaying;
		}
		
		public function stop():void
		{
			(_animations[_currentAnimation] as MovieClip).pause();
		}
		
		public function resume():void
		{
			(_animations[_currentAnimation] as MovieClip).play();
		}
		
	}

}