package 
{
	import starling.display.Sprite;
	import state.BaseState;
	
	/**
	 * ...
	 * @author jrh
	 */
	public class StateManager extends Sprite 
	{
		private static var instance:StateManager = null;
		
		private var _state:BaseState;
		
		
		public function StateManager() 
		{
			super();
			
			if ( instance != null )
				throw new Error("ERROR: Private constructor. Use Instance instead!");
		}
		
		
		public static function get Instance():StateManager
		{
			if ( instance == null )
				instance = new StateManager();
			
			return instance;
		}
		
		
		override public function dispose():void 
		{
			super.dispose();
			
			removeChildren();
			
			// disposes of the active state
			switchState(null);
		}
		
		
		public function switchState(state:BaseState):void
		{
			if (_state != null) {
				if (contains(_state)) {
					removeChild(_state);
				}
				
				_state.dispose();
				_state = null;
			}
			
			if(state != null) {
				_state = state;
				addChild(_state);
			}
		}
		
		
		public function get currentState():BaseState
		{
			return _state;
		}
	}

}
