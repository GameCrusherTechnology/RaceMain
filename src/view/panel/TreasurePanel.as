package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.item.TreasureItem;
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.TreasureItemRender;
	
	public class TreasurePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var titleText:TextField;
		private var panelScale:Number;
		private var backBut:Button;
		private var itemList:List;
		public function TreasurePanel()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		protected function initializeHandler(event:Event):void
		{
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			
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
			
			titleText = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("TreasureStore"),0xffffff,35);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			itemList = new List();
			
			const listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.verticalGap = panelheight *0.05;
			listLayout.horizontalGap = panelwidth*0.01;
			
			itemList.layout = listLayout;
			itemList.dataProvider = listData;
			itemList.itemRendererFactory =function tileListItemRendererFactory():TreasureItemRender
			{
				var renderer:TreasureItemRender = new TreasureItemRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
				renderer.width = panelwidth *0.2;
				renderer.height = panelheight *0.3;
				return renderer;
			}
			itemList.width =  panelwidth*0.7;
			itemList.height =  panelheight *0.8;
			itemList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			itemList.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
			addChild(itemList);
			itemList.x = panelwidth*0.15;
			itemList.y = panelheight*0.15;
			itemList.selectedIndex = -1;
			itemList.addEventListener(Event.CHANGE,onitemListChange);
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
		}
		private var isCommanding:Boolean ;
		private var curTreasureItem:TreasureItem;
		private function onitemListChange(event:Event):void
		{
			if(!isCommanding){
				var item:TreasureItem = itemList.selectedItem as TreasureItem;
				if(item){
					curTreasureItem = item;
					var name :String = curTreasureItem.name;
					PlatForm.FormBuyItems(name);
				}
			}
			itemList.selectedIndex = -1;
		}
		
		private function get listData():ListCollection
		{
			var arr:Array = [];
			for each(var object:TreasureItem in Configrations.treasures){
				arr.push(object);
			}
			arr.sortOn("index",Array.NUMERIC);
			return new ListCollection(arr);
		}
		private function onTriggerBack(e:Event):void
		{
			dispose();
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		private function get user():GameUser
		{
			return GameController.instance.localPlayer;
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
	}
}

