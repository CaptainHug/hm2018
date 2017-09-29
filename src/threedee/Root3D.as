package threedee 
{
	import away3d.containers.View3D;
	import away3d.core.pick.PickingCollisionVO;
	import away3d.core.pick.RaycastPicker;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.AWD2Parser;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import threedee.scene.SceneBase3D;
	/**
	 * ...
	 * @author jrh
	 */
	public class Root3D 
	{
		private static var instance:Root3D = null;
		private var _isInitialised:Boolean;
		
		private var _view:View3D;
		private var _currentScene:SceneBase3D;
		
		private var _raycastPicker:RaycastPicker;
		
		
		public function Root3D() 
		{
			if ( instance != null )
				throw new Error("ERROR: Private constructor. Use Instance instead!");
			
			_isInitialised = false;
			_view = null;
			_currentScene = null;
			
			_raycastPicker = new RaycastPicker(false);
			_raycastPicker.onlyMouseEnabled = false;
		}
		
		
		public static function get Instance():Root3D
		{
			if ( instance == null )
				instance = new Root3D();
			
			return instance;
		}
		
		
		public function init(view:View3D):void
		{
			if (_isInitialised) return;
			
			_view = view;
			
			AssetLibrary.enableParser(AWD2Parser);
			
			// TODO: move this into the preloading phase, as there is currently no guarantee that it has been completed before first use
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			// TODO: AssetLibrary.load(new URLRequest("assets/3d/dart.awd"));
			
			_isInitialised = true;
		}
		
		
		private function onAssetComplete(e:AssetEvent):void
		{
			// TODO: track loading progress
			trace("Root3D: onAssetComplete");
		}
		
		
		private function onResourceComplete(e:LoaderEvent):void
		{
			// TODO: track loading progress
			trace("Root3D: onResourceComplete");
		}
		
		
		
		public function switchScene(scene:SceneBase3D):void
		{
			if (_currentScene != null) {
				if (_view.scene.contains(_currentScene)) {
					_view.scene.removeChild(_currentScene);
				}
				
				_currentScene.dispose();
				_currentScene = null;
			}
			
			if (scene != null) {
				_currentScene = scene;
				_currentScene.init();
				_view.scene.addChild(_currentScene);
			}
		}
		
		
		public function update():void
		{
			if (!_isInitialised) return;
			
			// update current scene
			if (_currentScene != null) {
				_currentScene.update();
			}
			
			// render current scene
			if (_view != null && _view.stage3DProxy != null && _view.visible && _currentScene != null) {
				_view.render();
			}
		}
		
		
		public function get view():View3D
		{
			return _view;
		}
		
		
		public function getWorldFromScreen(x:Number, y:Number, z:Number):Vector3D
		{
			var p:Point = Kernel.Instance.scaleStagePointToScreen(x, y);			
			var worldPos:Vector3D = _view.unproject(p.x, p.y, z);
			
			return worldPos;
		}
		
		public function getIntersectingObject(x:Number, y:Number):Object
		{
			var p:Point = Kernel.Instance.scaleStagePointToScreen(x, y);
			var collisionObj:PickingCollisionVO = _raycastPicker.getViewCollision(p.x, p.y, _view);
			
			var worldPos:Vector3D = _view.unproject(p.x, p.y, 0-_view.camera.z);
			
			return {object:collisionObj, worldPos:worldPos};
		}
		
		
		public function set visible(val:Boolean):void
		{
			if(_view != null) {
				_view.visible = val;
			}
		}
		public function get visible():Boolean
		{
			if (_view != null) {
				return _view.visible;
			}
			else {
				return false;
			}
		}
	}

}
