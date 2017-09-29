package background 
{
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import starling.display.Image;
	import style.Resource;
	/**
	 * ...
	 * @author MattB
	 */
	public class Background_Default extends BaseBackground
	{
		private var _image:Image;
		
		
		public function Background_Default() 
		{
			super();
			
			_image = new Image(Kernel.Instance.assetManager.getTexture(Resource.GFX_GAME_LOGO));
			_image.alignPivot(HorizontalAlign.RIGHT, VerticalAlign.BOTTOM);
			addChild(_image);
			_image.x = Kernel.stageWidth;
			_image.y = Kernel.stageHeight;
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