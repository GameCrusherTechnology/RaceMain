package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.PieceItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.SpecialItemRender;
	
	public class PackagePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var curHero :GamePlayer;
		private var tabBar:TabBar;
		private var itemList:List;
		
		public function PackagePanel()
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
			
			
			tabBar = new TabBar();
			var tabList:ListCollection =new ListCollection(
				[
					{ label: LanguageController.getInstance().getString("all")},
					{ label: LanguageController.getInstance().getString("Item")},
					{ label: LanguageController.getInstance().getString("soldier")},
					{ label: LanguageController.getInstance().getString("skill") }
				]);
			tabBar.dataProvider = tabList;
			tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			tabBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			tabBar.tabFactory = function():Button
			{
				var tab:Button = new Button();
				tab.defaultSelectedSkin =  new Image(Game.assets.getTexture("TabButtonSelectedSkin"));
				tab.defaultSkin =  new Image(Game.assets.getTexture("TabButtonSkin"));
				tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				return tab;
			}
			addChild(this.tabBar);
			tabBar.width = panelwidth*0.8;
			tabBar.height = panelheight*0.08;
			tabBar.x = panelwidth*0.1 ;
			tabBar.y = panelheight*0.1 ;
			
			configList();
			
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
				
				const listLayout:TiledRowsLayout = new TiledRowsLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
				
				itemList.layout = listLayout;
				itemList.dataProvider = listData;
				itemList.itemRendererFactory =function tileListItemRendererFactory():SpecialItemRender
				{
					var renderer:SpecialItemRender = new SpecialItemRender();
					
					renderer.defaultSkin = new Image(Game.assets.getTexture("BPanelSkin"));
					renderer.width = panelwidth *0.2;
					renderer.height = panelheight *0.25;
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
			}else{
				itemList.dataProvider = listData;
				itemList.validate();
			}
		}
		
		private function get listData():ListCollection
		{
			var itemArr:Array = [];
			var soldierArr:Array = [];
			var skillArr:Array = [];
			var list:Array = hero.ownedItemlist;
			var allList:Array = [];
			var item:OwnedItem;
			for each(item in list){
				if(item.itemSpec is PieceItemSpec){
					if(PieceItemSpec(item.itemSpec).type == "skill"){
						skillArr.push(item.item_id);
					}else if(PieceItemSpec(item.itemSpec).type == "soldier"){
						soldierArr.push(item.item_id);
					}else{
						itemArr.push(item.item_id);
					}
				}else{
					itemArr.push(item.item_id);
				}
				allList.push(item.item_id);
			}
			if(currentTabIndex == 3){
				return new ListCollection(skillArr);
			}else if(currentTabIndex == 2){
				return new ListCollection(soldierArr);
			}else if(currentTabIndex == 1){
				return new ListCollection(itemArr);
			}else{
				return new ListCollection(allList);
			}
		}
			
		private var currentTabIndex:int;
		private function tabBar_changeHandler(event:Event):void
		{
			if(tabBar.selectedIndex != currentTabIndex){
				currentTabIndex = tabBar.selectedIndex;
				configList();
			}
		}
		
		public function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
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