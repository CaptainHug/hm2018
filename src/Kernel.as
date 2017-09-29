package 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import state.State_Loading;
	
	/**
	 * ...
	 * @author jrh
	 */
	public class Kernel extends Sprite 
	{
		private static var _instance:Kernel = null;
		
		private static var _stageWidth:Number;
		public static function get stageWidth():Number{
			return _stageWidth;
		}
		private static var _stageHeight:Number;
		public static function get stageHeight():Number{
			return _stageHeight;
		}
		
		public static var scaleFactor:int = 1;
		public static var assetScale:int = 1;
		public static var asf:Number = 1;
		
		private var _assets:AssetManager;
		
		public function Kernel() 
		{
			super();
			
			_instance = this;
		}
		
		
		public static function get Instance():Kernel
		{
			return _instance;
		}
		
		
		public function init(pScaleFactor:int, pAsf:Number):void
		{
			scaleFactor = pScaleFactor;
			asf = pAsf;
			
			// HACK: scaleFactor 3 means iPad 1/2 or equivalent Android resolution - which is actually a 2x set but using potentially different Tablet assets
			assetScale = scaleFactor;
			if (scaleFactor == 3) assetScale = 2;
			
			// Store stage width and height
			_stageWidth = stage.stageWidth;
			_stageHeight = stage.stageHeight;
			
			_assets = new AssetManager(asf, false);
			_assets.verbose = CONFIG::debug;
			
			// engine components
			addChild(BackgroundManager.Instance);
			
			addChild(StateManager.Instance);
			
			addChild(PopupManager.Instance);
			
			// start loading
			StateManager.Instance.switchState(new State_Loading());
		}
		
		
		public function get assetManager():AssetManager
		{
			return _assets;
		}
		
		
		public function scaleStagePointToScreen(x:Number, y:Number):Point
		{
			return new Point(Math.round(x * asf), Math.round(y * asf));
		}
		
		public function scaleScreenPointToStage(x:Number, y:Number):Point
		{
			return new Point(Math.round(x / asf), Math.round(y / asf));
		}
	}

}
