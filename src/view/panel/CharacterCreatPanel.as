package view.panel
{
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.CharacterItemSpec;
	import model.player.GameUser;
	
	import service.command.user.CreatCharacterCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.CharacterSelectRender;

	public class CharacterCreatPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var textinput:TextInput;
		private var creatButton:Button;
		private var list:List;
		public function CharacterCreatPanel()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		private var costCoin:int;
		private var costGem:int;
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			scale = Configrations.ViewScale;
			var heroCount:int = player.user_characters.length;
			var costObj:Object = Configrations.HeroCost[heroCount];
			costCoin = costObj["coin"];
			costGem  = costObj["gem"];
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
			
			var titleSkin:Image = new Image(Game.assets.getTexture("PanelTitle"));
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.8;
			titleSkin.height = panelheight*0.1;
			titleSkin.x = panelwidth*0.1;
			titleSkin.y = panelheight*0.1;
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.8,panelheight*0.1,LanguageController.getInstance().getString("creatCharacter"),0xffffff,40,true);
			addChild(titleText);
			titleText.x = panelwidth*0.1;
			titleText.y = panelheight*0.1;
			
			const listLayout: HorizontalLayout= new HorizontalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.paddingTop =listLayout.paddingBottom= 20*scale;
			listLayout.gap = 10*scale;
			
			
			list = new List();
			list.layout = listLayout;
			list.dataProvider = new ListCollection(SpecController.instance.getGroupArr("Character"));
			list.itemRendererFactory =function tileListItemRendererFactory():CharacterSelectRender
			{
				var renderer:CharacterSelectRender = new CharacterSelectRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
				renderer.width = panelwidth *0.2;
				renderer.height = panelheight *0.3;
				return renderer;
			}
			list.width =  panelwidth*0.7;
			list.height =  panelheight *0.45;
			list.verticalScrollPolicy = SCROLL_POLICY_ON;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this.addChild(list);
			list.x = panelwidth*0.15;
			list.y = panelheight*0.2;
			list.addEventListener(Event.CHANGE,onListChangeHandle);
			
			var nametext:TextField = FieldController.createSingleLineDynamicField(panelwidth, panelheight*0.06,LanguageController.getInstance().getString("heroname"),0x000000,panelheight*0.05);
			nametext.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(nametext);
			nametext.x = panelwidth*0.5 - nametext.width - panelwidth*0.02;
			nametext.y = panelheight*0.55;
			
			textinput = new TextInput();
			textinput.backgroundSkin = new Image(Game.assets.getTexture( "TitleTextSkin"));
			textinput.paddingLeft = 10;
			textinput.width  = panelwidth*0.2;
			textinput.height = panelheight*0.06;
			Factory(textinput,{color:0x000000,fontSize:panelheight*0.04,maxChars:15,text:"",displayAsPassword:false});
			addChild(this.textinput);
			textinput.x = panelwidth*0.5 ;
			textinput.y = nametext.y;
			
			configCostPart();
			
			creatButton = new Button();
			creatButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			if(canCreat){
				creatButton.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
				creatButton.label = LanguageController.getInstance().getString("creatnewhero");
			}else{
				creatButton.defaultSkin = new Image(Game.assets.getTexture("R_button"));
				creatButton.label = LanguageController.getInstance().getString("gotoTreasureShop");
			}
			creatButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			creatButton.addEventListener(Event.TRIGGERED, okButton_triggeredHandler);
			creatButton.paddingLeft =creatButton.paddingRight =  panelwidth*0.02;
			creatButton.paddingTop =creatButton.paddingBottom =  panelheight*0.01;
			addChild(creatButton);
			creatButton.validate();
			creatButton.x = panelwidth/2 - creatButton.width/2;
			creatButton.y = panelheight*0.82;
			
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.1;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			list.selectedIndex = 0;
		}
		private var canCreat:Boolean = true;
		private function configCostPart():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = panelwidth*0.25;
			container.y = panelheight*0.65;
			
			var skin:Scale9Image = new Scale9Image(new Scale9Textures( Game.assets.getTexture("PanelRenderSkin"),new Rectangle(12,12,40,40)));
			skin.width = panelwidth*0.5;
			skin.height = panelheight*0.15;
			container.addChild(skin);
			
			var nametext:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.5, panelheight*0.05,LanguageController.getInstance().getString("ShopTip01"),0x000000,panelheight*0.04);
			container.addChild(nametext);
			
			var coinIcon:Image = new Image(Game.assets.getTexture("CoinIcon"));
			coinIcon.width = coinIcon.height = panelheight*0.04;
			container.addChild(coinIcon);
			coinIcon.x = panelwidth*0.15;
			coinIcon.y = panelheight*0.05;
			
			var coinColor:uint = 0x23E96D;
			if(costCoin > player.coin){
				canCreat = false;
				coinColor = 0xF0466D;
			}
			var coinText:TextField = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,String(player.coin),coinColor,panelheight*0.03,true);
			coinText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(coinText);
			coinText.x = coinIcon.x + coinIcon.width + panelwidth*0.02;
			coinText.y = coinIcon.y;
			
			var coinText1:TextField = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,"/"+String(costCoin),0x000000,panelheight*0.03,true);
			coinText1.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(coinText1);
			coinText1.x = coinText.x + coinText.width + panelwidth*0.01;
			coinText1.y = coinIcon.y;
			
			
			
			var gemColor:uint = 0x23E96D;
			if(costGem > player.gem){
				canCreat = false;
				gemColor = 0xF0466D;
			}
			
			var gemIcon:Image = new Image(Game.assets.getTexture("GemIcon"));
			gemIcon.width = gemIcon.height = panelheight*0.04;
			container.addChild(gemIcon);
			gemIcon.y = panelheight*0.1;
			gemIcon.x = panelwidth*0.15;
			
			var gemText:TextField = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,String(player.gem),gemColor,panelheight*0.03,true);
			gemText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(gemText);
			gemText.x = gemIcon.x + gemIcon.width + panelwidth*0.02;
			gemText.y = gemIcon.y;
			
			var gemText1:TextField = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,"/"+String(costGem),0x000000,panelheight*0.03,true);
			gemText1.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(gemText1);
			gemText1.x = gemText.x + gemText.width + panelwidth*0.01;
			gemText1.y = gemIcon.y;
		}
		private function onListChangeHandle(e:Event):void
		{
//			var itemspec:CharacterItemSpec = list.selectedItem as CharacterItemSpec;
//			if(itemspec){
//				textinput.text = itemspec.cname + "_"+player.gameuid;
//			}
		}
		
		private var isCommanding:Boolean;
		private function okButton_triggeredHandler(e:Event):void
		{
			if(!isCommanding){
				if(canCreat){
					if(textinput.text =="" || textinput.text == " "){
						DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("creatNameTip")));
					}else{
						if(list.selectedItem is CharacterItemSpec){
							new CreatCharacterCommand((list.selectedItem as CharacterItemSpec).item_id,textinput.text,player.user_characters.length,onCreated);
							isCommanding = true;
						}else{
							DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warnselectcharacter")));
						}
					}
				}else{
					DialogController.instance.showPanel(new TreasurePanel());
					this.removeFromParent(true);
				}
			}
		}
		private function onCreated():void
		{
			isCommanding = false;
			dispatchEvent(new Event(Event.CLOSE));
			removeFromParent(true);
		}
		private function Factory(target:TextInput , inputParameters:Object ):void
		{
			var editor:StageTextTextEditor = new StageTextTextEditor;
			editor.color = (inputParameters.color == undefined) ? editor.color:inputParameters.color;
			editor.fontSize = (inputParameters.fontSize == undefined) ? editor.fontSize:inputParameters.fontSize;
			target.maxChars = (inputParameters.maxChars == undefined) ? editor.maxChars:inputParameters.maxChars;
			editor.displayAsPassword = (inputParameters.displayAsPassword == undefined)?editor.displayAsPassword:inputParameters.displayAsPassword;
			target.textEditorFactory = function textEditor():ITextEditor{return editor};
			target.text  = inputParameters.text;
		}
		private function onTriggerBack(e:Event):void
		{
			this.removeFromParent(true);
		}
		
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}