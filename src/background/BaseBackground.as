package background 
{
	import starling.display.Sprite;
	/**
	 * ...
	 * @author MattB
	 */
	public class BaseBackground extends Sprite
	{
		public function BaseBackground() 
		{
			super();
		}
		
		
		override public function dispose():void 
		{
			super.dispose();
		}
		
		
		public function pause():void
		{
			// Override if child class needs to process anything on pause
		}
		
		
		public function resume():void
		{
			// Override if child class needs to process anything on resume
		}
	}

}