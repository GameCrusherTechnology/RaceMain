package gameconfig
{
	import flash.desktop.NativeApplication;
	import flash.geom.Rectangle;
	import flash.html.script.Package;
	import flash.system.Capabilities;

	public class Devices
	{
		public function Devices()
		{
			
		}
		//first check to see if we're on the device or in the debugger//
		public static const isDebugger:Boolean = Capabilities.isDebugger;
		//set a few variables that'll help us deal with the debugger//
		public static const isLandscape:Boolean = true;// most of my games are in landscape
		public static var debuggerDevice:String = "others";//iPhone3 = iPhone4,4s, etc.iPad2 others
		
		private static var _deviceDetails:Object;
		public static function getDeviceDetails():Object {
			if(_deviceDetails) return _deviceDetails;
			var retObj:Object = {};
			var devStr:String = Capabilities.os;
			var applicationXml:XML =   NativeApplication.nativeApplication.applicationDescriptor;
			setApplicationXML(applicationXml);
			var devStrArr:Array = devStr.split(" ");
			devStr = devStrArr.pop();
			devStr = (devStr.indexOf(",") > -1)?devStr.split(",").shift():debuggerDevice;
			
			
			retObj.width = Capabilities.screenResolutionX>Capabilities.screenResolutionY?Capabilities.screenResolutionX:Capabilities.screenResolutionY;
			retObj.height = Capabilities.screenResolutionX<Capabilities.screenResolutionY?Capabilities.screenResolutionX:Capabilities.screenResolutionY;
			if(Configrations.PLATFORM == "PC"){
				retObj.width = 1024;
				retObj.height = 768;
////				//低配
//				retObj.width = 480;
//				retObj.height = 320;
//				//高配
//				retObj.width = 1680;
//				retObj.height = 1050;
			}
			retObj.x = Capabilities.screenResolutionX/2;
			retObj.y = Capabilities.screenResolutionY/2;
			retObj.device = devStr;
			retObj.scale =1;
			retObj.frameRate = "60";
			return _deviceDetails = retObj;
		}
		
		private static function setApplicationXML(xml:XML):void
		{
			var xmlList:Namespace = xml.namespaceDeclarations()[0]; 
			var version:String = xml.xmlList::versionNumber;
			Configrations.VERSION = version;
		}
		
	}

}