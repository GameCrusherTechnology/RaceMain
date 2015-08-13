package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	import model.item.RandomShopItem;
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import service.command.item.BuyItemCommand;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.RandomShopItemRender;
	
	public class ShopPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var buyTreasure:Button;
		private var curHero :GamePlayer;
		private var itemList:List;
		
		public function ShopPanel()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			curHero = GameController.instance.currentHero;
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.5;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth*0.8;
			backSkin.height = panelheight*0.8;
			backSkin.x = panelwidth*0.1;
			backSkin.y = panelheight*0.1;
			
			var titleSkin:Scale9Image = new Scale9Image(Configrations.PanelTitleSkinTexture);
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.8;
			titleSkin.height = panelheight*0.08;
			titleSkin.x = panelwidth*0.1;
			titleSkin.y = panelheight*0.1;
			
			titleText = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("PieceStore"),0xffffff,35);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			configList();
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			buyTreasure = new Button();
			buyTreasure.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			buyTreasure.label = LanguageController.getInstance().getString("gotoTreasureShop");
			buyTreasure.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			buyTreasure.paddingLeft = buyTreasure.paddingRight = 20*panelScale;
			buyTreasure.paddingBottom = buyTreasure.paddingTop = 10*panelScale;
			addChild(buyTreasure);
			buyTreasure.validate();
			buyTreasure.addEventListener(Event.TRIGGERED,onTriggerBuyTreasure);
			buyTreasure.x = panelwidth/2 - buyTreasure.width/2;
			buyTreasure.y = panelheight*0.81;
			
		}
		
		private function configList():void
		{
			if(!itemList){
				itemList = new List();
				
				const listLayout:TiledRowsLayout = new TiledRowsLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
				
				
				itemList.layout = listLayout;
				itemList.dataProvider = listData;
				itemList.itemRendererFactory =function tileListItemRendererFactory():RandomShopItemRender
				{
					var renderer:RandomShopItemRender = new RandomShopItemRender();
					renderer.defaultSkin = new Image(Game.assets.getTexture("BPanelSkin"));
					renderer.width = panelwidth *0.15;
					renderer.height = panelheight *0.2;
					return renderer;
				}
				itemList.width =  panelwidth*0.7;
				itemList.height =  panelheight *0.6;
				itemList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				itemList.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
				addChild(itemList);
				itemList.x = panelwidth*0.15;
				itemList.y = panelheight*0.2;
				itemList.selectedIndex = -1;
				itemList.addEventListener(Event.CHANGE,onitemListChange);
			}
		}
		
		private function get listData():ListCollection
		{
			var arr:Array = [];
			var group:Array = SpecController.instance.getGroupArr("Piece");
			while(group.length>=1)
			{
				var item :ItemSpec = group[0];
				group.splice(0,1);
				arr.push(new RandomShopItem({'item_id':item.item_id,'count':10,'beBought':false,'useGem':true}));
			}
			return new ListCollection(arr);
		}
		
		
		private var curRandomShopItem:RandomShopItem;
		private function onitemListChange(event:Event):void
		{
			if(!isCommanding){
				var item:RandomShopItem = itemList.selectedItem as RandomShopItem;
				if(item){
					if(!item.beBought){
						if(checkMoney(item.cost,item.useGem)){
							curRandomShopItem = item;
							var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("BuyItemTip") +" "+ item.itemSpec.cname + "×" + item.count + "?",true)
							DialogController.instance.showPanel(panel);
							panel.addEventListener(PanelConfirmEvent.CLOSE,onConfirmHandler);
						}
					}
				}
			}
			itemList.selectedIndex = -1;
		}
		
		private var isCommanding:Boolean ;
		private function onConfirmHandler(e:PanelConfirmEvent):void
		{
			if(e.BeConfirm){
				isCommanding = true;
				new BuyItemCommand(curRandomShopItem.item_id,curRandomShopItem.count,curRandomShopItem.useGem,onBuyed);
			}
		}
		private function onTriggerBuyTreasure(e:Event):void
		{
			DialogController.instance.showPanel(new TreasurePanel());
			dispose();
		}
		private function onBuyed(isSuccess:Boolean=true):void
		{
			if(isSuccess){
				curRandomShopItem.beBought = true;
				hero.addItem(curRandomShopItem.item_id,curRandomShopItem.count);
				if(curRandomShopItem.useGem){
					user.changeGem(-curRandomShopItem.cost);
				}else{
					user.changeCoin(-curRandomShopItem.cost);
				}
				curRandomShopItem.beBought= true;
				dispose();
				DialogController.instance.showPanel(new ShopPanel());
			}
			isCommanding = false;
		}
		
		private function checkMoney(cost:int,isGem:Boolean):Boolean
		{
			if(isGem){
				if(cost > user.gem){
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningGemTip")));
					return false;
				}else{
					return true;
				}
			}else{
				if(cost > user.coin){
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningCoinTip")));
					return false;
				}else{
					return true;
				}
			}
		}
		public function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		public function get user():GameUser
		{
			return GameController.instance.localPlayer;
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

