package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;

	public class SelectFriendPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var curHero :GamePlayer;
		private var curPlayer:GameUser;
		public function SelectFriendPanel()
		{
			curHero = GameController.instance.currentHero;
			curPlayer = GameController.instance.localPlayer;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.8;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth*0.8;
			backSkin.height = panelheight*0.6;
			backSkin.x = panelwidth*0.1;
			backSkin.y = panelheight*0.2;
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.2;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
		}
		
		private function onTriggerBack(e:Event):void
		{
			dispose();
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
		
	}
}