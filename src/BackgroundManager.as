package 
{
	import background.Background_Default;
	import background.BaseBackground;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author MattB
	 */
	public class BackgroundManager extends Sprite
	{
		private static var instance:BackgroundManager = null;
		
		private var _background:BaseBackground;
		
		
		public function BackgroundManager() 
		{
			super();
			
			if ( instance != null )
				throw new Error("ERROR: Private constructor. Use Instance instead!");
				
			switchBackground(new Background_Default());
		}
		
		
		public static function get Instance():BackgroundManager
		{
			if ( instance == null )
				instance = new BackgroundManager();
			
			return instance;
		}
		
		
		override public function dispose():void 
		{
			super.dispose();
			
			removeChildren();
			
			// disposes of the active background
			switchBackground(null);
		}
		
		
		public function switchBackground(background:BaseBackground):void
		{
			if (_background != null) {
				if (contains(_background)) {
					removeChild(_background);
				}
				
				_background.dispose();
				_background = null;
			}
			
			if(background != null) {
				_background = background;
				addChild(_background);
			}
		}
		
		
		public function pause():void
		{
			if (_background != null)
			{
				_background.pause();
			}
		}
		
		
		public function resume():void
		{
			if (_background != null)
			{
				_background.resume();
			}
		}
	}

}