package popup 
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author jrh
	 */
	public class BasePopup extends Sprite 
	{
		public var requires3DEngine:Boolean;
		
		protected var _bg:Image;
		protected var _closeButton:Button;
		protected var _title:Label;
		
		public function BasePopup() 
		{
			super();
			
			requires3DEngine = false;
		}
		
		
		override public function dispose():void 
		{
			super.dispose();
			
			removeChildren();
			
			if (_bg != null) { _bg.dispose(); _bg = null; }
			if (_closeButton != null) { _closeButton.removeEventListener(Event.TRIGGERED, onClickClose); _closeButton.dispose(); _closeButton = null; }
			if (_title != null) { _title.dispose(); _title = null; }
		}
		
		
		protected function onClickClose():void
		{
			PopupManager.Instance.pop(this);
		}
	}

}