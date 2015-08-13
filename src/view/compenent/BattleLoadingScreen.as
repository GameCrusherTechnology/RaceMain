package view.compenent
{
	import controller.FieldController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class BattleLoadingScreen extends Sprite
	{
		private var loadingTip:Image;
		private var loadingMC:MovieClip;
		private var loadingtext:TextField;
		public function BattleLoadingScreen()
		{
			var blackBack:Image = new Image(Game.assets.getTexture("BlackSkin"));
			blackBack.width = Configrations.ViewPortWidth;
			blackBack.height = Configrations.ViewPortHeight;
			addChild(blackBack);
			
			loadingTip = new Image(Game.assets.getTexture("ResultPanelSkin"));
			loadingTip.width = Configrations.ViewPortWidth *0.8;
			loadingTip.scaleY = loadingTip.scaleX;
			addChild(loadingTip);
			loadingTip.x = Configrations.ViewPortWidth *0.1;
			loadingTip.y = Configrations.ViewPortHeight *0.4 - loadingTip.height/2;
			
			var text:TextField = FieldController.createSingleLineDynamicField(loadingTip.width,loadingTip.height,LanguageController.getInstance().getString("BattlePrepare"),0xffffff,40);
			addChild(text);
			text.x = loadingTip.x;
			text.y = loadingTip.y;
			
			loadingMC = new MovieClip(Game.assets.getTextures("effect_loading"));
			addChild(loadingMC);
			loadingMC.height = loadingTip.height/5;
			loadingMC.scaleX = loadingMC.scaleY;
			loadingMC.x = Configrations.ViewPortWidth *0.5 - loadingMC.width/2;
			loadingMC.y = loadingTip.y + loadingTip.height*2/3;
			
			loadingtext = FieldController.createSingleLineDynamicField(200,loadingMC.height," 0 %",0x00ff33,30);
			loadingtext.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(loadingtext);
			loadingtext.x = loadingMC.x +loadingMC.width + 20 *Configrations.ViewScale;
			loadingtext.y = loadingMC.y;
		}
		
		public function start():void
		{
			Starling.juggler.add(loadingMC);
			loadingtext.text = " 0 %";
			
		}
		public function validateLoading(progress:Number):void
		{
			var c:int = Math.round(progress*10000)/100;
			loadingtext.text = c + " %";
		}
		
		override public function dispose():void
		{
			Starling.juggler.remove(loadingMC);
			removeFromParent();
		}
	}
}