package util 
{
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author jrh
	 */
	public class DeviceUtil 
	{
		public static const PLATFORM_IOS:String = "platform_iOS";
		public static const PLATFORM_ANDROID:String = "platform_Android";
		public static const PLATFORM_DESKTOP:String = "platform_Desktop";
		private var _platform:String;
		
		private static var instance:DeviceUtil = null;
		private var _isInitialised:Boolean;
		
		
		public function DeviceUtil() 
		{
			if (instance != null) {
				throw new Error("ERROR: Private constructor. Use Instance instead!");
				return;
			}
			
			_isInitialised = false;
		}
		
		
		public static function get Instance():DeviceUtil
		{
			if ( instance == null )
				instance = new DeviceUtil();
			
			return instance;
		}
		
		
		public function init():void
		{
			if (_isInitialised) return;
			
			// calculate platform
			_platform = PLATFORM_DESKTOP;
			if (Capabilities.version.toLowerCase().indexOf("ios") > -1) {
				_platform = PLATFORM_IOS;
			}
            else if (Capabilities.version.toLowerCase().indexOf("and") > -1) {
				_platform = PLATFORM_ANDROID;
			}
			
			
			_isInitialised = true;
		}
		
		
		public function get platform():String
		{
			return _platform;
		}
		
	}

}
