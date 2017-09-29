package 
{
	import popup.BasePopup;
	import starling.display.Quad;
	import starling.display.Sprite;
	import threedee.Root3D;
	
	/**
	 * ...
	 * @author jrh
	 */
	public class PopupManager extends Sprite 
	{
		private static var instance:PopupManager = null;
		
		private var _popups:Array;
		private var _alertQueue:Array;
		
		
		public function PopupManager() 
		{
			super();
			
			if ( instance != null )
				throw new Error("ERROR: Private constructor. Use Instance instead!");
			
			_popups = [];
			_alertQueue = [];
		}
		
		
		public static function get Instance():PopupManager
		{
			if ( instance == null )
				instance = new PopupManager();
			
			return instance;
		}
		
		
		override public function dispose():void 
		{
			super.dispose();
			
			removeChildren();
			
			// clear popups array properly
			if (_popups != null) {
				while (_popups.length > 0) {
					pop();
				}
				_popups = null;
			}
			
			if (_alertQueue != null) {
				while (_alertQueue.length > 0) {
					_alertQueue.pop();
					// TODO: dispose of the Alert contained within the AlertQueue object
				}
				_alertQueue = null;
			}
		}
		
		
		// add / push popup func
		public function push(popup:BasePopup, closeOthers:Boolean=false, blocksInput:Boolean=false, showBlock:Boolean=false):void
		{
			if (popup == null) return;
			if (_popups == null) return;
			
			if (closeOthers) {
				// remove all popups
				popType(BasePopup);
				
				// TODO: should this clear the alert queue as well? probably not?
			}
			
			if (blocksInput) {
				// Add transparent quad to block input under popup
				// TODO: ensure only one inputBlocker exists and is moved back to it's previous owner where possible?
				var inputBlocker:Quad = new Quad(Kernel.stageWidth, Kernel.stageHeight, 0x000000);
				var popupRef:Sprite = Sprite(popup);
				inputBlocker.x = -(popupRef.x + this.x);
				inputBlocker.y = -(popupRef.y + this.y);
				inputBlocker.alpha = (!showBlock ? 0 : 0.9);
				popupRef.addChildAt(inputBlocker, 0);
			}
			
			_popups.push(popup);
			addChild(popup);
			
			updateRoot3DVisibility();
		}
		
		
		// removes a specific popup, or top most popup if none specified
		public function pop(popup:BasePopup=null):BasePopup
		{
			if (_popups == null || _popups.length <= 0) return null;
			
			var p:BasePopup;
			
			// if no popup passed in, remove the top one
			if (popup == null) {
				p = _popups.pop();
				if (p != null) {
					if(contains(p)) removeChild(p);
					p.dispose();
					updateRoot3DVisibility();
					return p;
				}
				updateRoot3DVisibility();
				return null;
			}
			// else remove the specified popup
			else {
				for each(p in _popups) {
					if (p == popup) {
						
						if (p != null) {
							if(contains(p)) removeChild(p);
							p.dispose();
							_popups.removeAt(_popups.indexOf(p));
							updateRoot3DVisibility();
							return p;
						}
					}
				}
				updateRoot3DVisibility();
				return null;
			}
		}
		
		
		// removes all popups deriving from a specific class
		public function popType(type:Class):void
		{
			if (_popups == null || _popups.length <= 0) {
				updateRoot3DVisibility();
				return;
			}
			
			for (var i:int = 0; i < _popups.length; ++i) {
				var p:BasePopup = _popups[i];
				if (p is type) {
					
					if (p != null) {
						if(contains(p)) removeChild(p);
						p.dispose();
						_popups.removeAt(_popups.indexOf(p));
						p = null;
						--i;
					}
				}
			}
			
			updateRoot3DVisibility();
		}
		
		
		public function containsType(type:Class):Boolean
		{
			for (var i:int = 0; i < _popups.length; ++i) {
				var p:BasePopup = _popups[i];
				if (p is type) {
					
					return true;
				}
			}
			
			return false;
		}
		
		
		private function updateRoot3DVisibility():void
		{
			if (numChildren > 0) {
				
				// hide 3D layer if it is not required by the top most popup, as this is always above the 2D layer
				var topMost:BasePopup = _popups[_popups.length - 1];
				if(topMost && topMost.requires3DEngine) {
					Root3D.Instance.visible = true;
				}
				else {
					Root3D.Instance.visible = false;
				}
			}
			else {
				// show 3D layer when we have no popups on screen
				Root3D.Instance.visible = true;
			}
		}
		
	}

}
