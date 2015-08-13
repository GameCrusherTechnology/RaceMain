package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class WarnnigTipPanel extends PanelScreen
	{
		private var mes:String;
		public function WarnnigTipPanel(str:String)
		{
			mes = str;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			touchable = false;
		}
		protected function initializeHandler(event:Event):void
		{
			var texture:Scale9Textures = new Scale9Textures(Game.assets.getTexture("BlackPanelSkin"),new Rectangle(15,20,100,40));
			var skin:Scale9Image = new Scale9Image(texture);
			addChild(skin);
			skin.alpha = 0.8;
			var mesText:TextField = FieldController.createSingleLineDynamicField(Configrations.ViewPortWidth*0.8,Configrations.ViewPortHeight*0.3,
				mes,0xff0000,50,true);
			mesText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(mesText);
			mesText.touchable = false;
			skin.width = mesText.width + 100*Configrations.ViewScale;
			skin.height = mesText.height + 50*Configrations.ViewScale;
			skin.x = Configrations.ViewPortWidth /2 - skin.width/2;
			skin.y = 100*Configrations.ViewScale;
			mesText.x = skin.x + 50*Configrations.ViewScale;
			mesText.y = skin.y + 25*Configrations.ViewScale;
			var tween:Tween = new Tween(this,5);
			tween.animate("alpha",0);
			tween.moveTo(x,y-skin.height);
			tween.onComplete = destroy;
			Starling.juggler.add(tween);
		}
		
		private function destroy():void
		{
			removeFromParent(true);
		}
		
	}
}