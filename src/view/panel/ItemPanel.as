package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.SpecialItemRender;

	public class ItemPanel extends PanelScreen
	{
		public static const ENERGY:String = "energy";
		public static const INVITE:String = "invite";
		public static const QUICKPASS:String = "quickpass";
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var itemType:String;
		private var itemList:List;
		
		public function ItemPanel(type:String)
		{
			itemType = type;
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
			backSkin.width = panelwidth*0.5;
			backSkin.height = panelheight*0.5;
			backSkin.x = panelwidth*0.25;
			backSkin.y = panelheight*0.25;
			
			var titleSkin:Scale9Image = new Scale9Image(Configrations.PanelTitleSkinTexture);
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.5;
			titleSkin.height = panelheight*0.08;
			titleSkin.x = panelwidth*0.25;
			titleSkin.y = panelheight*0.25;
			
			titleText = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString(itemType),0xffffff,35,true);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			const listLayout1: HorizontalLayout= new HorizontalLayout();
			listLayout1.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout1.gap = panelwidth *0.02;
			
			itemList = new List();
			itemList.layout = listLayout1;
			itemList.dataProvider = getListData();
			itemList.itemRendererFactory =function tileListItemRendererFactory():SpecialItemRender
			{
				var renderer:SpecialItemRender = new SpecialItemRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("BPanelSkin"));
				renderer.width = renderer.height = Math.min(panelwidth *0.2,panelheight *0.3);
				return renderer;
			}
			itemList.width =  panelwidth*0.5;
			itemList.height =  panelheight *0.3;
			addChild(itemList);
			itemList.x = panelwidth*0.25;
			itemList.y = panelheight*0.4;
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.25 - panelheight*0.05;
			backBut.y = panelheight*0.23;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
		}
		
		private function getListData():ListCollection
		{
			var arr:Array = [];
			if(itemType == ENERGY){
				arr = ["80000","80001"];
			}else if(itemType == INVITE){
				arr = ["80002"];
			}else if(itemType == QUICKPASS){
				arr = ["80003"];
			}
			return new ListCollection(arr);
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