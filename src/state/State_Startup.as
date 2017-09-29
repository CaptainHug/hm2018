package state 
{
	import background.Background_Default;
	import starling.display.Image;
	import style.Resource;
	/**
	 * ...
	 * @author jrh
	 */
	public class State_Startup extends BaseState 
	{
		private var _image:Image;
		
		
		public function State_Startup() 
		{
			super();
			
			BackgroundManager.Instance.switchBackground(new Background_Default());
			
			_image = new Image(Kernel.Instance.assetManager.getTexture(Resource.GFX_GAME_LOGO));
			addChild(_image);
		}
		
		
		override public function dispose():void
		{
			if (_image) {
				_image.dispose();
				_image = null;
			}
			
			super.dispose();
		}
	}

}
