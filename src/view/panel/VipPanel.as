package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.VipRender;

	public class VipPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var curHero :GamePlayer;
		private var curPlayer:GameUser;
		public function VipPanel()
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
			
			
			configVipPart();
			
			
			var shopBut:Button = new Button();
			shopBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			shopBut.label = LanguageController.getInstance().getString("improvevip");
			shopBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.05, 0x000000);
			shopBut.paddingLeft = shopBut.paddingRight = 20*panelScale;
			shopBut.height = panelheight*0.08;
			addChild(shopBut);
			shopBut.validate();
			shopBut.x = panelwidth*0.5 - shopBut.width/2;
			shopBut.y = panelheight*0.8 - shopBut.height/2 ;
			shopBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.2;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
		}
		private var list:List;
		private function configVipPart():void
		{
			
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = panelwidth*0.15;
			container.y = panelheight*0.25;
			
			const listLayout:HorizontalLayout= new HorizontalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.gap = panelwidth *0.05;
			
			list = new List();
			list.layout = listLayout;
			list.dataProvider = getListCoarr();
			list.itemRendererFactory =function tileListItemRendererFactory():VipRender
			{
				var renderer:VipRender = new VipRender();
				renderer.width = panelwidth *0.3;
				renderer.height = panelheight *0.5;
				return renderer;
			}
			list.width =  panelwidth*0.7;
			list.height =  panelheight *0.5;
			container.addChild(list);
			list.addEventListener(Event.CHANGE,onListChangeHandle);
			
			list.scrollToDisplayIndex(hero.vipLevel);
		}
		
		private function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		private function onTriggerConfirm(e:Event):void
		{
			DialogController.instance.showPanel(new TreasurePanel(),true);
		}
		private function getListCoarr():ListCollection
		{
			return new ListCollection(Configrations.VIPlist);
		}
		private function onListChangeHandle(e:Event):void
		{
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