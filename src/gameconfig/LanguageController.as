package gameconfig
{
	import flash.net.URLLoader;
	
	import starling.textures.Texture;
	
	
	public class LanguageController
	{
		public static const NUMBERFONT_WHITE:String = "Number_BigWhite";
		public static const NUMBERFONT_DARKBLUE:String = "Number_DarkBlueBold";
		public static const NUMBERFONT_GREEN:String = "Number_Green";
		public static const NUMBERFONT_ORANGE:String = "Number_OrangeBold";
		public static const NUMBERFONT_DARKGREEN:String = "Number_DarkGreenBold";
		
		private static var _instance:LanguageController;
		public static function getInstance():LanguageController{
			if(!_instance){
				_instance = new LanguageController;
			}
			return _instance;
		}
		public function LanguageController(){
			
		}
		private var resourcesLoader:URLLoader;
		
		private var dictLanguage:Object = {};
		public function set languageXML(xml:XML):void
		{
			var xmlList:XMLList =  xml.children();
			for each(var subXML1:XML in xmlList)
			{
				var key:String = String(subXML1.@key);
				var value:String = String(subXML1.@value);
				dictLanguage[key]=value;
			}
		}
		
		public function getString(key:String):String
		{
			if(!dictLanguage[key]){
				trace("no language : " + key);
				return key;
			}
			return dictLanguage[key];
		}
		
		public function getNumberTexture(num:int,fontName:String):Texture
		{
			num = num%10;
			return Game.assets.getTexture(fontName+String(num));
		}
	}
}