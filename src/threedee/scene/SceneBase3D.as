package threedee.scene 
{
	import away3d.containers.ObjectContainer3D;
	
	/**
	 * ...
	 * @author jrh
	 */
	public class SceneBase3D extends ObjectContainer3D 
	{
		protected var _ticks:int;
		protected var _paused:Boolean;
		
		
		public function SceneBase3D() 
		{
			super();
			
			_ticks = 0;
			_paused	= false;
		}
		
		
		public function init():void
		{
			
		}
		
		
		public function update():void
		{
			if (_paused) return;
			
			_ticks++;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		
		public function pause():void
		{
			if (_paused) return;
			
			_paused = true;
		}
		
		
		public function resume():void
		{
			if (!_paused) return;
			
			_paused = false;
		}
	}

}
