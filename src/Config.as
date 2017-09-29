package 
{
	import flash.desktop.NativeApplication;
	/**
	 * ...
	 * @author jrh
	 */
	public class Config 
	{
		
		public function Config() 
		{
			
		}
		
		
		public static function get VERSION_NUMBER():String
		{
			//Get Version Number from Application.xml.
			var applicationDesc:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var nameSpace:Namespace = applicationDesc.namespace();
			return applicationDesc.nameSpace::versionNumber[0];
		}
		
		public static function get APP_ID():String
		{
			return NativeApplication.nativeApplication.applicationID;
		}
	}

}
