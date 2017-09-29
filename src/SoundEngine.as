package  
{
	import com.greensock.TweenMax;
	import flash.desktop.NativeApplication;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author jrh
	 */
	public class SoundEngine 
	{
		private static var _instance:SoundEngine = null;
		
		private var _isPaused:Boolean;
		private var _prevEnabledBGM:Boolean;
		private var _prevEnabledSFX:Boolean;
		
		private var _resourceBGM:Array;
		private var _resourceSFX:Array;
		
		private var _transformBGM:SoundTransform;
		private var _transformSFX:SoundTransform;
		
		private var _bgmChannel:SoundChannel;
		private var _bgmFile:String;
		private var _bgmMaxVolume:Number;
		
		private var _sfxChannels:Array;
		
		public function SoundEngine() 
		{
			if (_instance != null) {
				trace("Private ctr! Use Instance instead");
				return;
			}
			
			_isPaused = false;
			_prevEnabledBGM = false;
			_prevEnabledSFX = false;
			
			_resourceBGM = new Array();
			_resourceSFX = new Array();
			
			_transformBGM = new SoundTransform();
			_transformSFX = new SoundTransform();
			
			_sfxChannels = new Array();
			
			_bgmMaxVolume = 0.8;
			_transformBGM.volume = _bgmMaxVolume;
		}
		
		
		public static function get Instance():SoundEngine
		{
			if (_instance == null) {
				_instance = new SoundEngine();
			}
			return _instance;
		}
		
		
		public function registerBGM(key:String, file:String):void
		{
			_resourceBGM[key] = new Sound(new URLRequest(file));
		}
		public function registerSFX(key:String, file:String):void
		{
			_resourceSFX[key] = new Sound(new URLRequest(file));
		}
		
		
		public function pauseAllSounds(e:flash.events.Event = null):void
		{
			if (_isPaused) return;
			
			_prevEnabledBGM = enabledBGM;
			_prevEnabledSFX = enabledSFX;
			
			enabledBGM = false;
			enabledSFX = false;
			
			_isPaused = true;
		}
		
		public function continueAllSounds(e:flash.events.Event = null):void
		{
			if (!_isPaused) return;
			
			enabledBGM = _prevEnabledBGM;
			enabledSFX = _prevEnabledSFX;
			
			_isPaused = false;
		}
		
		
		// bgm functions
		public function playBGM(bgm:String, loops:int=int.MAX_VALUE):void
		{
			if (_bgmFile == bgm) {
				// already playing!
				return;
			}
			
			// stop old bgm
			stopBGM();
			
			_bgmFile = bgm;
			_bgmChannel = (_resourceBGM[bgm] as Sound).play(0, loops, _transformBGM);
		}
		public function stopBGM():void 
		{
			_bgmFile = "";
			
			if (_bgmChannel != null) {
				_bgmChannel.stop();
				_bgmChannel = null;
			}
		}
		
		
		public function playSFX(sfx:String, loops:int=0):SoundChannel
		{
			if (!enabledSFX) return null;
			
			var sfxChannel:SoundChannel = (_resourceSFX[sfx] as Sound).play(0, loops, _transformSFX);
			if (sfxChannel != null) {
				_sfxChannels.push(sfxChannel);
				sfxChannel.addEventListener(Event.SOUND_COMPLETE, sfxComplete);
			}
			
			return sfxChannel;
		}
		
		private function sfxComplete(event:Event):void
		{
			var sfxChannel:SoundChannel = event.target as SoundChannel;
			if (sfxChannel) {
				sfxChannel.removeEventListener(Event.SOUND_COMPLETE, sfxComplete);
			}
			
			for (var i:int = 0; i < _sfxChannels.length; ++i) {
				if (_sfxChannels[i] == sfxChannel) {
					_sfxChannels.splice(i, 1);
				}
			}
		}
		
		
		public function set enabledBGM(val:Boolean):void
		{
			if (val) _transformBGM.volume = _bgmMaxVolume;
			else _transformBGM.volume = 0;
			
			if (_bgmChannel != null) {
				_bgmChannel.soundTransform = _transformBGM;
			}
		}
		public function get enabledBGM():Boolean
		{
			if (_transformBGM.volume == _bgmMaxVolume) return true;
			else return false;
		}
		
		public function set enabledSFX(val:Boolean):void
		{
			if (val) _transformSFX.volume = 1;
			else _transformSFX.volume = 0;
			
			// set the sound transform volume
			if(_sfxChannels) {
				for each(var sfxChannel:SoundChannel in _sfxChannels) {
					if (sfxChannel) sfxChannel.soundTransform = _transformSFX;
				}
			}
			
		}
		public function get enabledSFX():Boolean
		{
			if (_transformSFX.volume == 1) return true;
			else return false;
		}
		
		private function fadeBGMVolume(targetVolume:Number):void 
		{
			targetVolume = targetVolume <= 1 ? targetVolume : 1;
			targetVolume = targetVolume >= 0 ? targetVolume : 0;
			
			TweenMax.to(_transformBGM, 1, { volume: targetVolume, onUpdate:function():void {
				if (_bgmChannel != null) {
					_bgmChannel.soundTransform = _transformBGM;
				}
			} });
		}
	}

}