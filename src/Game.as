package
{
    
    import controller.GameController;
    
    import feathers.controls.ProgressBar;
    import feathers.layout.AnchorLayoutData;
    
    import gameconfig.Configrations;
    import gameconfig.Devices;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
    
    import view.compenent.GreenProgressBar;
    
    
    public class Game extends Sprite
    {
		private var mLoadingProgress:GreenProgressBar;
		
		public static var assets:AssetManager;
        public function Game()
        {
            this.alpha = 0.999;
        }
		public function start(background:Texture,_asset:AssetManager):void
		{
			Starling.current.stage.stageWidth  = Configrations.ViewPortWidth = Devices.getDeviceDetails().width;
			Starling.current.stage.stageHeight = Configrations.ViewPortHeight= Devices.getDeviceDetails().height;
			Configrations.ViewScale = Math.min(Configrations.ViewPortWidth/1024,Configrations.ViewPortHeight/768);
			assets = _asset;
			
			var back:Image = new Image(background);
			var s:Number =Math.max( Configrations.ViewPortWidth /back.width, Configrations.ViewPortHeight/back.height);
			back.scaleX = back.scaleY = s;
			addChild(back);
			back.x = Configrations.ViewPortWidth/2 - back.width/2;
			back.y = Configrations.ViewPortHeight/2 - back.height/2;
			
			mLoadingProgress = new GreenProgressBar(Configrations.ViewPortWidth*0.2,Configrations.ViewPortHeight*0.05,2,0x000000,0x8B2323);
			mLoadingProgress.x = Configrations.ViewPortWidth*0.9  - mLoadingProgress.width;
			mLoadingProgress.y = Configrations.ViewPortHeight * 0.8;
			addChild(mLoadingProgress);
			
			
			GameController.instance.show(this);
			assets.loadQueue(onLoadQueue);
		}
		private function onLoadQueue(ratio:Number):void
		{
			mLoadingProgress.progress = ratio;
			mLoadingProgress.comment = Math.floor(ratio*100) +"%";
			// a progress bar should always show the 100% for a while,
			// so we show the main menu only after a short delay. 
			
			if (ratio == 1){
				Starling.juggler.delayCall(function():void
				{
					mLoadingProgress.removeFromParent(true);
					mLoadingProgress = null;
					GameController.instance.start();
				}, 0.15);
			}
			addEventListener(EnterFrameEvent.ENTER_FRAME,onEnterFrame);
		}
		private function onEnterFrame(e:EnterFrameEvent):void
		{
		}
        
        
    }
}