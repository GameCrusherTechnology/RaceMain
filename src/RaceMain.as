package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	
	import controller.GameController;
	import controller.VoiceController;
	
	import gameconfig.Configrations;
	import gameconfig.Devices;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.formatString;
	
//		[SWF(width="1680", height="1050", frameRate="30", backgroundColor="#000000")]
	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#000000")]
	public class RaceMain extends Sprite
	{
		// Startup image for SD screens
		[Embed(source="/startup.jpg")]
		private static var Background:Class;
		private var background:Bitmap;
		
		private var mStarling:Starling;
		
		private var stageWidth:int  ;
		private var stageHeight:int ;
		public function RaceMain()
		{
			stageWidth  = Devices.getDeviceDetails().width;
			stageHeight = Devices.getDeviceDetails().height;
			setPlatform();
		}
		
		public function init():void
		{
			// This project requires the sources of the "demo" project. Add them either by 
			// referencing the "demo/src" directory as a "source path", or by copying the files.
			// The "media" folder of this project has to be added to its "source paths" as well, 
			// to make sure the icon and startup images are added to the compiled mobile app.
			
			// set general properties
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
			
			//			var viewPort:Rectangle = RectangleUtil.fit(
			//				new Rectangle(0, 0, stageWidth, stageHeight), 
			//				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
			//				ScaleMode.SHOW_ALL, iOS);
			
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stageWidth, stageHeight), 
				ScaleMode.SHOW_ALL, iOS);
			
			
			// create the AssetManager, which handles all required assets for this resolution
			
			//			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			var scaleFactor:int = 1;
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = new AssetManager(scaleFactor);
			
			assets.verbose = Capabilities.isDebugger;
			
			var lanObj:SharedObject ;
			var language:String;
			if(lanObj && lanObj.data && lanObj.data.obj){
				language = lanObj.data.obj;
			}else{
				language = Capabilities.language;
			}
			var fontStr:String = "en";
			if(language == "zh-CN"){
				fontStr  = "zh-CN";
			}else if(language == "zh-TW"){
				fontStr  = "zh-TW";
			}
			else if(language == "de"){
				language = "de";
			}
			else{
				language = "en";
			}
			Configrations.Language  = language;
			//			test
						Configrations.Language= language = "en";
						fontStr = "en";
			
			assets.enqueue(
				appDir.resolvePath(formatString("lan/{0}", language)),
				appDir.resolvePath(formatString("font/{0}",fontStr)),
				appDir.resolvePath("font/number"),
				appDir.resolvePath("xml"),
				appDir.resolvePath("textures/init")
			);
			
			// While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
			// we display a startup image now and remove it below, when Starling is ready to go.
			// This is especially useful on iOS, where "Default.png" (or a variant) is displayed
			// during Startup. You can create an absolute seamless startup that way.
			// 
			// These are the only embedded graphics in this app. We can't load them from disk,
			// because that can only be done asynchronously - i.e. flickering would return.
			// 
			// Note that we cannot embed "Default.png" (or its siblings), because any embedded
			// files will vanish from the application package, and those are picked up by the OS!
			var backgroundClass:Class =  Background ;
			background = new backgroundClass();
			Background = null; // no longer needed!
			
			var s:Number =Math.max( stageWidth /background.width, stageHeight/background.height);
			background.scaleX = background.scaleY = s;
			background.x = stageWidth/2 - background.width/2;
			background.y = stageHeight/2 - background.height/2;
			background.smoothing = true;
			addChild(background);
			
			
			// launch Starling
			
			mStarling = new Starling(Game, stage, viewPort);
			mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
			mStarling.simulateMultitouch  = false;
			mStarling.enableErrorChecking = false;
						mStarling.showStats = true;
			mStarling.simulateMultitouch = true;
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				var bgTexture:Texture = Texture.fromEmbeddedAsset(backgroundClass,
					false, false, scaleFactor);
				if(background){
					if(background.parent){
						removeChild(background);
					}
					background = null;
				}
				
				var game:Game = mStarling.root as Game;
				game.start(bgTexture,assets);
				mStarling.start();
			});
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { 
					mStarling.start(); 
					VoiceController.instance.setMusicVoice(0.2);
				});
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { 
					mStarling.stop(true); 
					VoiceController.instance.setMusicVoice(0);
				});
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		}
		
		protected function setPlatform():void
		{
			Configrations.PLATFORM = "PC";
			init();
		}
		private function onKey(event:KeyboardEvent):void
		{
			if(event.keyCode == 16777238){
				event.preventDefault();
				event.stopImmediatePropagation();
				GameController.instance.onKeyCancel();
			}
		}
	}
}