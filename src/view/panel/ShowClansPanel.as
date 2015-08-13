package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.LocalData;
	
	import model.clan.ClanData;
	
	import service.command.clan.GetClanCommand;
	import service.command.clan.GetClanListCommand;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import view.render.ClanListRender;

	public class ShowClansPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var dataList:List;
		private var titleText:TextField;
		private var backBut:Button;
		private var creatBut:Button;
		private var inputText:TextInput;
		private var searchBut:Button;
		
		public function ShowClansPanel()
		{
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
			
			titleText = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("clan"),0xffffff,titleSkin.height*0.5,true);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			searchBut = new Button();
			searchBut.defaultSkin = new Image(Game.assets.getTexture("SearchIcon"));
			searchBut.width = searchBut.height = panelheight*0.08;
			addChild(searchBut);
			searchBut.x = panelwidth*0.9 - searchBut.width - 10*panelScale;
			searchBut.y = panelheight*0.1;
			searchBut.addEventListener(Event.TRIGGERED,onTriggerSearch);
			
			inputText = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("WhiteSkin"), new Rectangle(20, 20, 20, 20));
			var skinImage:Scale9Image = new Scale9Image(_inputSkinTextures);
			skinImage.alpha = 0.5;
			inputText.backgroundSkin = skinImage;
			inputText.paddingLeft = 10;
			inputText.width = panelwidth*0.15;
			inputText.height = panelheight*0.06;
			Configrations.InputTextFactory(inputText,{color:0x000000,fontSize:30,maxChars:10,text:"1001",displayAsPassword:false});
			addChild(inputText);
			inputText.x = searchBut.x - inputText.width ;
			inputText.y = titleSkin.y + panelheight*0.01 ;
			
			if(Configrations.ClansData){
				configList();
			}else{
				new GetClanListCommand(onGetList);
			}
			
			
			
			creatBut = new Button();
			creatBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			creatBut.label = LanguageController.getInstance().getString("creat")+" "+LanguageController.getInstance().getString("clan");
			creatBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			creatBut.paddingLeft = creatBut.paddingRight = 20*panelScale;
			creatBut.height = panelheight*0.08;
			addChild(creatBut);
			creatBut.validate();
			creatBut.x = panelwidth*0.5 - creatBut.width/2;
			creatBut.y = panelheight*0.75;
			creatBut.addEventListener(Event.TRIGGERED,onTriggerCreat);
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
		}
		
		private function onGetList():void
		{
			configList();
		}
		private var listText:TextField;
		private function configList():void
		{
			const listLayout:VerticalLayout = new VerticalLayout();
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
			listLayout.paddingTop = listLayout.paddingBottom = 20*panelScale;
			listLayout.gap = 10*panelScale;
			
			if(dataList){
				dataList.removeEventListener(Event.CHANGE,onlistHandle);
				dataList.dispose();
				dataList = null;
			}
			dataList = new List();
			
			var listSkin:Scale9Image =  new Scale9Image(new Scale9Textures( Game.assets.getTexture("WhiteSkin"),new Rectangle(2,2,60,60)));
			listSkin.alpha = 0.5;
			dataList.backgroundSkin =listSkin;
			
			dataList.layout = listLayout;
			dataList.dataProvider = getListData();
			dataList.itemRendererFactory =function tileListItemRendererFactory():ClanListRender
			{
				var renderer:ClanListRender = new ClanListRender();
				
				renderer.defaultSkin = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListRenderSkin"),new Rectangle(50,15,200,30)));
				renderer.width = panelwidth *0.65;
				renderer.height = panelheight *0.1;
				return renderer;
			}
//			dataList.selectedIndex = 0;
			dataList.width =  panelwidth*0.7;
			dataList.height =  panelheight *0.5;
			dataList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			dataList.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			addChild(dataList);
			dataList.x = panelwidth*0.15;
			dataList.y = panelheight*0.2;
			dataList.addEventListener(Event.CHANGE,onlistHandle);
			
			if(!listText){
				listText = FieldController.createSingleLineDynamicField(panelwidth*0.7, panelheight *0.4,LanguageController.getInstance().getString("EmptyClanListTip"),0x000000,40,true);
			}
			if(dataList.dataProvider.length<1){
				addChild(listText);
				listText.x = panelwidth*0.15;
				listText.y = panelheight*0.2;
			}else{
				listText.removeFromParent();
			}
		}
		private function onlistHandle(e:Event):void
		{
			if(dataList.selectedItem){
				DialogController.instance.showPanel(new SimpleClanInfoPanel(dataList.selectedItem as ClanData));
				dataList.selectedIndex = -1;
			}
		}
		private function getListData():ListCollection
		{
			return new ListCollection(Configrations.ClansData);
		}
		private function onTriggerCreat(e:Event):void
		{
			DialogController.instance.showPanel(new CreatClanPanel());
		}
		private function onTriggerBack(e:Event):void
		{
			removeFromParent(true);
		}
		private function onTriggerSearch(e:Event):void
		{
			if(int(inputText.text) >= 1000){
				new GetClanCommand([int(inputText.text)],onGetBack);
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningNoClanTip") + String(inputText.text)));
			}
		}
		private function onGetBack(clanDatas:Array = null):void
		{
			if(clanDatas && clanDatas.length>0){
				DialogController.instance.showPanel(new SimpleClanInfoPanel(new ClanData(clanDatas[0])));
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningNoClanTip")+ String(inputText.text)));
			}
		}
	}
}