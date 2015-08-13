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
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	import model.gameSpec.PieceItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import service.command.item.ComposeCommand;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.ComposeItemRender;

	public class ComposePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var player :GameUser;
		private var pieceitemspec:PieceItemSpec;
		private var itemList:List;
		private var needCoin:int;
		private var needPiece:int;
		public function ComposePanel(itemspec:PieceItemSpec=null,ownedCount:int=0)
		{
			pieceitemspec = itemspec;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			player = GameController.instance.localPlayer;
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
			
			var titleSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20)));
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.8;
			titleSkin.height = panelheight*0.08;
			titleSkin.x = panelwidth*0.1;
			titleSkin.y = panelheight*0.1;
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("compose"),0xffffff,35,true);
			addChild(titleText);
			titleText.y =  panelheight*0.1;
			
			configList();
			configComposeContainer();
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
		}
		
		private function configList():void
		{
			if(!itemList){
				itemList = new List();
				
				const listLayout:HorizontalLayout = new HorizontalLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
				
				
				var listSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelBackSkin"),new Rectangle(12,12,40,40)));
				listSkin.width = panelwidth*0.7;
				listSkin.height =  panelheight *0.22;
				
				itemList.backgroundSkin = listSkin;
				
				itemList.layout = listLayout;
				itemList.dataProvider = listData;
				itemList.itemRendererFactory =function tileListItemRendererFactory():ComposeItemRender
				{
					var renderer:ComposeItemRender = new ComposeItemRender();
					
					renderer.defaultSkin = new Image(Game.assets.getTexture("BPanelSkin"));
					renderer.defaultSelectedSkin = new Image(Game.assets.getTexture("RPanelSkin"));
					renderer.width = panelwidth *0.15;
					renderer.height = panelheight *0.2;
					return renderer;
				}
				itemList.width =  panelwidth*0.7;
				itemList.height =  panelheight *0.22;
				itemList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				itemList.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
				addChild(itemList);
				itemList.x = panelwidth*0.15;
				itemList.y = panelheight*0.2;
				itemList.addEventListener(Event.CHANGE,onitemListChange);
				if(pieceitemspec){
					var ownedI:OwnedItem = hero.getItem(pieceitemspec.item_id);
					var index:int = listData.getItemIndex(ownedI);
					itemList.selectedIndex = index;
				}else{
					itemList.selectedIndex = 0;
				}
			}else{
				itemList.dataProvider = listData;
				itemList.validate();
				itemList.selectedIndex = 0;
			}
			
		}
		
		private function get listData():ListCollection
		{
			var itemArr:Array = Configrations.getComposeArr(hero);
			return new ListCollection(itemArr);
		}
		
		private var composeItemSpec:ItemSpec;
		private var composeContainer:Sprite;
		private function configComposeContainer():void
		{
			needCoin = 0;
			needPiece = 0;
			if(composeContainer){
				composeContainer.removeFromParent(true);
			}
			composeContainer = new Sprite();
			addChild(composeContainer);
			var containerSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(12,12,40,40)));
			containerSkin.width = panelwidth*0.7;
			containerSkin.height =  panelheight *0.45;
			composeContainer.addChild(containerSkin);
			
			composeContainer.x = panelwidth*0.15;
			composeContainer.y = panelheight*0.42;
			if(pieceitemspec){
				composeItemSpec = SpecController.instance.getItemSpec(pieceitemspec.boundItem);
				
				var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.7,panelheight*0.1,composeItemSpec.cname,0x000000,panelheight*0.08,true);
				composeContainer.addChild(nameText);
				var curLevel:int;
				var piececount:int = hero.getItem(pieceitemspec.item_id).count;
				if(pieceitemspec.type == "skill"){
					curLevel = hero.getSkillItem(composeItemSpec.item_id).count;
					needPiece = hero.pieceUpdateSkillCount(pieceitemspec);
					needCoin = Configrations.UpdateSkillCoin[curLevel];
				}else if(pieceitemspec.type == "soldier"){
					curLevel = hero.getSoldierItem(composeItemSpec.item_id).count;
					needPiece = hero.pieceUpdateSoldierCount(pieceitemspec);
					needCoin = Configrations.UpdateSoldierCoin[curLevel];
				}
				
				
				var arrowIcon:Image = new Image(Game.assets.getTexture("rightArrowIcon"));
				arrowIcon.width = arrowIcon.height = panelheight*0.08;
				composeContainer.addChild(arrowIcon);
				arrowIcon.x = panelwidth*0.35 - arrowIcon.width/2;
				arrowIcon.y = panelheight*0.11;
				
				var levelupText:TextField = FieldController.createSingleLineDynamicField(300,panelheight*0.1,String(curLevel) ,0x000000,panelheight*0.05);
				levelupText.autoSize = TextFieldAutoSize.HORIZONTAL;
				composeContainer.addChild(levelupText);
				levelupText.x = arrowIcon.x - 5 - levelupText.width;
				levelupText.y = panelheight*0.1;
					
				var levelupText1:TextField = FieldController.createSingleLineDynamicField(300,panelheight*0.1,String(curLevel+1),0x000000,panelheight*0.05);
				levelupText1.autoSize = TextFieldAutoSize.HORIZONTAL;
				composeContainer.addChild(levelupText1);
				levelupText1.x = arrowIcon.x + arrowIcon.width + 5;
				levelupText1.y = panelheight*0.1;
				
				var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
				expIcon.width = expIcon.height = panelheight*0.1;
				composeContainer.addChild(expIcon);
				expIcon.x = levelupText.x - expIcon.width - 5;
				expIcon.y = levelupText.y;
					
				var compose1:Sprite = new Sprite;
				composeContainer.addChild(compose1);
				compose1.x =panelwidth*0.1;
				compose1.y = panelheight*0.22;
				
				var composeSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"),new Rectangle(10,10,30,30)));
				composeSkin.width = panelwidth*0.2;
				composeSkin.height =  panelheight *0.1;
				compose1.addChild(composeSkin);
				
				var pieceIcon:Image = new Image(pieceitemspec.iconTexture);
				pieceIcon.height = panelheight*0.08;
				pieceIcon.scaleX = pieceIcon.scaleY;
				compose1.addChild(pieceIcon);
				pieceIcon.x = 20*panelScale;
				pieceIcon.y = panelheight *0.01;
				
				var pIcon:Image = new Image(Game.assets.getTexture("RankIcon"));
				pIcon.width = pieceIcon.width/2;
				pIcon.scaleY = pIcon.scaleX;
				compose1.addChild(pIcon);
				pIcon.x = pieceIcon.x ;
				pIcon.y = pieceIcon.y ;
				
				var pieceText:TextField = FieldController.createSingleLineDynamicField(200,panelheight*0.1,"×"+needPiece,0x000000,25,true);
				pieceText.autoSize = TextFieldAutoSize.HORIZONTAL;
				compose1.addChild(pieceText);
				pieceText.x = pieceIcon.x + pieceIcon.width ;
				
				var okIcon:Image;
				if(needPiece <= piececount){
					okIcon = new Image(Game.assets.getTexture("okIcon"));
				}else{
					okIcon = new Image(Game.assets.getTexture("WarningIcon"));
				}
				okIcon.height = panelheight*0.08;
				okIcon.scaleX = okIcon.scaleY;
				compose1.addChild(okIcon);
				okIcon.x = panelwidth*0.2 - okIcon.width/2;
				okIcon.y = panelheight *0.01;
				
				
				var compose2:Sprite = new Sprite;
				composeContainer.addChild(compose2);
				compose2.x =panelwidth*0.4;
				compose2.y = panelheight*0.22;
				
				var composeSkin2:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("simplePanelSkin"),new Rectangle(10,10,30,30)));
				composeSkin2.width = panelwidth*0.2;
				composeSkin2.height =  panelheight *0.1;
				compose2.addChild(composeSkin2);
				
				var coinIcon:Image = new Image(Game.assets.getTexture("CoinIcon"));
				coinIcon.height = panelheight*0.08;
				coinIcon.scaleX = coinIcon.scaleY;
				compose2.addChild(coinIcon);
				coinIcon.x = 20*panelScale;
				coinIcon.y = panelheight *0.01;
				
				
				var coinText:TextField = FieldController.createSingleLineDynamicField(200,panelheight*0.1,"×"+needCoin,0x000000,25,true);
				coinText.autoSize = TextFieldAutoSize.HORIZONTAL;
				compose2.addChild(coinText);
				coinText.x = coinIcon.x + coinIcon.width ;
				
				var okIcon1:Image;
				if(needCoin <= player.coin){
					okIcon1 = new Image(Game.assets.getTexture("okIcon"));
				}else{
					okIcon1 = new Image(Game.assets.getTexture("WarningIcon"));
				}
				okIcon1.height = panelheight*0.08;
				okIcon1.scaleX = okIcon1.scaleY;
				compose2.addChild(okIcon1);
				okIcon1.x = panelwidth*0.2 - okIcon.width/2;
				okIcon1.y = panelheight *0.01;
				
				if(needPiece <= piececount){
					var composeBut:Button = new Button();
					if(needCoin > player.coin){
						composeBut.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
						composeBut.label = LanguageController.getInstance().getString("buyCoin");
						composeBut.addEventListener(Event.TRIGGERED,onTriggeredBuyCoin);
						composeBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 45, 0xffffff);
					}else{
						composeBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
						composeBut.label = LanguageController.getInstance().getString("compose");
						composeBut.addEventListener(Event.TRIGGERED,onTriggeredCompose);
						composeBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 45, 0x000000);
					}
					
					composeBut.paddingLeft =composeBut.paddingRight =  20*panelScale;
					composeBut.paddingTop =composeBut.paddingBottom =  10*panelScale;
					composeContainer.addChild(composeBut);
					composeBut.validate();
					composeBut.x = panelwidth*0.35- composeBut.width/2;
					composeBut.y = panelheight*0.45 - composeBut.height - 10*panelScale;
					
				}
			}else{
				var text1:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.7,panelheight*0.4,LanguageController.getInstance().getString("nocomposetip"),0x000000,50);
				composeContainer.addChild(text1);
				
				var shopBut:Button = new Button();
				shopBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
				shopBut.label = LanguageController.getInstance().getString("ShopScene");
				shopBut.addEventListener(Event.TRIGGERED,onTriggeredShop);
				shopBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				shopBut.paddingLeft =shopBut.paddingRight =  20;
				shopBut.paddingTop =shopBut.paddingBottom =  10;
				composeContainer.addChild(shopBut);
				shopBut.validate();
				shopBut.x = panelwidth*0.35- shopBut.width/2;
				shopBut.y = panelheight*0.45 - shopBut.height - 10*panelScale;
			}
		}
		private function onTriggeredShop(e:Event):void
		{
			DialogController.instance.showPanel(new ShopPanel(),true);
		}
		private function onTriggeredBuyCoin(event:Event):void
		{
			DialogController.instance.showPanel(new TreasurePanel(),true);
		}
		
		private var isCommanding:Boolean;
		private function onTriggeredCompose(event:Event):void
		{
			if(!isCommanding){
				new ComposeCommand(pieceitemspec.item_id,composeItemSpec.item_id,needPiece,needCoin,onComposed);
				isCommanding = true;
			}
		}
		private function onComposed():void{
			isCommanding = false;
			pieceitemspec = null;
			composeItemSpec = null;
			configList();
			configComposeContainer();
		}
		private function onitemListChange(event:Event):void
		{
			var item:OwnedItem = itemList.selectedItem as OwnedItem;
			if(item){
				if(pieceitemspec != item.itemSpec){
					pieceitemspec = item.itemSpec as PieceItemSpec;
					configComposeContainer();
				}
			}
		}
		
		private function onTriggerBack(e:Event):void
		{
			dispose();
		}
		private function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
	}
}