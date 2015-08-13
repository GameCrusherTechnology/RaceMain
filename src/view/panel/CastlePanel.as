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
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.PieceItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	
	import service.command.hero.SetArmyCommand;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.CastleMemberRender;
	
	public class CastlePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var lastArmyArr:Array;
		public function CastlePanel()
		{
			lastArmyArr=hero.soldierList.concat();
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
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
			
			titleText = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("castleSoldiers"),0xffffff,35);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			configArmyList();
			configSoldierList();
			
			var list:Array = hero.ownedItemlist;
			var item:OwnedItem;
			for each(item in list){
				if(item.itemSpec is PieceItemSpec){
					if(PieceItemSpec(item.itemSpec).type == "soldier"){
						var needSold:int = hero.pieceUpdateSoldierCount(PieceItemSpec(item.itemSpec));
						if(needSold <= item.count && needSold >0){
							configUpdateBut();
							break;
						}
					}
				}
			}
			
			shopBut = new Button();
			shopBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			shopBut.label = LanguageController.getInstance().getString("ShopScene");
			shopBut.addEventListener(Event.TRIGGERED,onTriggeredShop);
			shopBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			shopBut.paddingLeft =shopBut.paddingRight =  20;
			shopBut.paddingTop =shopBut.paddingBottom =  10;
			addChild(shopBut);
			shopBut.validate();
			shopBut.x = panelwidth*0.5- shopBut.width/2;
			shopBut.y = ownlistText.y + panelheight*0.3 ;
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
		}
		
		private var armyList:List;
		private var armylistText:TextField;
		private function configArmyList():void
		{
			if(!armyList){
				armyList = new List();
				const listLayout:HorizontalLayout = new HorizontalLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
				listLayout.paddingTop = 30*panelScale;
				listLayout.gap = 10*panelScale;
				var listSkin:Scale9Image =  new Scale9Image(new Scale9Textures( Game.assets.getTexture("PanelRenderSkin"),new Rectangle(12,12,40,40)));
				armyList.backgroundSkin =listSkin;
	
				
				armyList.layout = listLayout;
				armyList.dataProvider = getArmyList();
				armyList.itemRendererFactory =function tileListItemRendererFactory():CastleMemberRender
				{
					var renderer:CastleMemberRender = new CastleMemberRender();
					renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
					renderer.width = panelwidth *0.2;
					renderer.height = panelheight *0.25;
					return renderer;
				}
				armyList.width =  panelwidth*0.7;
				armyList.height =  panelheight *0.3;
				armyList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				armyList.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
				addChild(armyList);
				armyList.x = panelwidth*0.15;
				armyList.y = panelheight*0.2;
				armyList.selectedIndex = -1;
				armyList.addEventListener(Event.CHANGE,onarmyListChange);
				
				armylistText = FieldController.createSingleLineDynamicField(panelwidth *0.7,30*panelScale,LanguageController.getInstance().getString("curused"),0x000000,25);
				addChild(armylistText);
				armylistText.x = panelwidth*0.15;
				armylistText.y =  panelheight*0.2;
			}else{
				armyList.dataProvider = getArmyList();
				armyList.validate();
			}
			
			if(armyList.dataProvider.length<=0){
				armylistText.height = panelheight*0.3;
				armylistText.text = LanguageController.getInstance().getString("curnoused");
			}else{
				armylistText.height = 30*panelScale;
				armylistText.text = LanguageController.getInstance().getString("curused");
			}
		}
		
		private var soldierList:List;
		private var ownlistText:TextField;
		private var shopBut:Button;
		private function configSoldierList():void
		{
			if(!soldierList){
				soldierList = new List();
				const listLayout:HorizontalLayout = new HorizontalLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
				listLayout.paddingTop = 30*panelScale;
				listLayout.gap = 10*panelScale;
				
				
				var listSkin:Scale9Image =  new Scale9Image(new Scale9Textures( Game.assets.getTexture("PanelBackSkin"),new Rectangle(12,12,40,40)));
				soldierList.backgroundSkin =listSkin;
				
				soldierList.layout = listLayout;
				soldierList.dataProvider = getSoldierList();
				soldierList.itemRendererFactory =function tileListItemRendererFactory():CastleMemberRender
				{
					var renderer:CastleMemberRender = new CastleMemberRender();
					
					renderer.defaultSkin = new Image(Game.assets.getTexture("PanelSkin"));
					renderer.width = panelheight *0.2;
					renderer.height = panelheight *0.2;
					return renderer;
				}
				soldierList.width =  panelwidth*0.7;
				soldierList.height =  panelheight *0.25;
				soldierList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				soldierList.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
				addChild(soldierList);
				soldierList.x = panelwidth*0.15;
				soldierList.y = panelheight*0.52;
				soldierList.selectedIndex = -1;
				soldierList.addEventListener(Event.CHANGE,onsoldierListChange);
				
				ownlistText = FieldController.createSingleLineDynamicField(panelwidth *0.7,30*panelScale,LanguageController.getInstance().getString("owned"),0x000000,25);
				addChild(ownlistText);
				ownlistText.x = panelwidth*0.15;
				ownlistText.y =  panelheight*0.52;
				
				
			}else{
				soldierList.dataProvider = getSoldierList();
				soldierList.validate();
			}
			if(soldierList.dataProvider.length<=0){
				ownlistText.height = panelheight*0.3;
				ownlistText.text = LanguageController.getInstance().getString("OwnedNothing");
					
				
			}else{
				ownlistText.height = 30*panelScale;
				ownlistText.text = LanguageController.getInstance().getString("owned");
				
			}
		}
		private function configUpdateBut():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			
			var updateButton:Button = new Button();
			updateButton.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			updateButton.label = LanguageController.getInstance().getString("toUpdate");
			updateButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			updateButton.addEventListener(Event.TRIGGERED, onUpdateClickHandler);
			updateButton.paddingLeft =updateButton.paddingRight =  20;
			updateButton.paddingTop =updateButton.paddingBottom =  5;
			container.addChild(updateButton);
			var icon:Image = new Image(Game.assets.getTexture("markIcon"));
			container.addChild(icon);
			updateButton.validate();
			icon.width = icon.height = updateButton.height;
			updateButton.x = icon.x + icon.width ;
			container.x = panelwidth*0.8 - container.width/2;
			container.y = panelheight*0.82;
			
			var tween:Tween = new Tween(icon, 1);
			tween.scaleTo(icon.scaleX*2); 
			tween.moveTo(-icon.width/2,-icon.height/2);
			tween.repeatCount = 10;
			Starling.juggler.add(tween);
		}
		private function onUpdateClickHandler(e:Event):void
		{
			DialogController.instance.showPanel(new ComposePanel());
			dispose();
		}
		private function onTriggeredShop(e:Event):void
		{
			DialogController.instance.showPanel(new ShopPanel(),true);
		}
		private function onarmyListChange(e:Event):void
		{
			var itemid:String = String(armyList.selectedItem);
			if(int(itemid) >0){
				lastArmyArr.splice(lastArmyArr.indexOf(itemid),1);
				configArmyList();
				configSoldierList();
			}
		}
		private function onsoldierListChange(e:Event):void
		{
			var itemid:String = String(soldierList.selectedItem);
			if(int(itemid) > 0){
				lastArmyArr.push(itemid);
				configArmyList();
				configSoldierList();
			}
		}
		private function getArmyList():ListCollection
		{
			lastArmyArr.sort();
			return new ListCollection(lastArmyArr);
		}
		private function getSoldierList():ListCollection
		{
			var arr:Array = [];
			var army:Array = lastArmyArr;
			for each(var item:OwnedItem in hero.ownedSoldierlist){
				if(item.count > 0){
					var index:int = army.indexOf(item.item_id);
					if(index<0){
						arr.push(item.item_id);
					}
				}
			}
			arr.sort();
			return new ListCollection(arr);
		}
		
		private function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		
		private function onTriggerBack(e:Event):void
		{
			lastArmyArr.sort();
			var newstr:String = lastArmyArr.join(":");
			var oldstr:String = hero.soldierList.join(":");
			if(newstr != oldstr){
				new SetArmyCommand(lastArmyArr,onChanged);
			}
			
			dispose();
		}
		private function onChanged():void
		{
		}
		
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
	}
}


