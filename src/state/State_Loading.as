package state 
{
	import flash.filesystem.File;
	import starling.events.Event;
	import style.Theme;
	/**
	 * ...
	 * @author jrh
	 */
	public class State_Loading extends BaseState 
	{
		private var _theme:Theme;
		
		
		public function State_Loading() 
		{
			super();
			
			// Remove any background that may be on screen
			BackgroundManager.Instance.switchBackground(null);
			
			// Load the initial assets for the splash screen
			loadAssets();
		}
		
		
		private function loadAssets():void
		{
			Kernel.Instance.assetManager.enqueue(File.applicationDirectory.resolvePath("assets/gfx/" + Kernel.assetScale + "x/loading"));
			
			// TODO: SoundEngine.Instance.registerBGM("MainMenu", "assets/sfx/music/MainMenu.mp3");
			
			// TODO: SoundEngine.Instance.registerSFX("AchievementLevelUp", "assets/sfx/sfx/AchievementLevelUp.mp3");
			
			// TODO: should be loaded after the splash screen really
			Kernel.Instance.assetManager.enqueue(File.applicationDirectory.resolvePath("assets/font/"));
			Kernel.Instance.assetManager.enqueue(File.applicationDirectory.resolvePath("assets/gfx/" + Kernel.assetScale + "x/common"));
			
			Kernel.Instance.assetManager.loadQueue(onLoadProgress);
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			
			// TODO: Unload sheet that is no longer needed
			// TODO: Kernel.Instance.assetManager.removeTextureAtlas("publisher_sheet_0");
		}
		
		
		private function onLoadProgress(ratio:Number):void
		{
			trace("State_Loading: onLoadProgress - ratio = " + ratio);
			
			if (ratio == 1) 
			{
				// Now all assets are loaded, load the theme
				_theme = new Theme();
				_theme.addEventListener(Event.COMPLETE, onThemeReady);
				_theme.initialize();
			}
		}
		
		
		private function onThemeReady(e:Event):void
		{
			_theme.removeEventListener(Event.COMPLETE, onThemeReady);
			
			StateManager.Instance.switchState(new State_Startup());
		}
		
	}

}
