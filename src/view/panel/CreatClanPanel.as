package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import service.command.clan.CreatClanCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class CreatClanPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var inputText:TextInput;
		private var confirmBut:Button;
		private var costContainer:Sprite;
		private var clanGem:int = 20;
		
		public function CreatClanPanel()
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
			backSkin.width = panelwidth*0.6;
			backSkin.height = panelheight*0.6;
			backSkin.x = panelwidth*0.2;
			backSkin.y = panelheight*0.2;
			
			var titleSkin:Scale9Image = new Scale9Image(Configrations.PanelTitleSkinTexture);
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.6;
			titleSkin.height = panelheight*0.06;
			titleSkin.x = panelwidth*0.2;
			titleSkin.y = panelheight*0.2;
			
			titleText = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("creat")+" "+LanguageController.getInstance().getString("clan"),0xffffff,35,true);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.4,panelheight*0.08,LanguageController.getInstance().getString("creatNameTip"),0x000000,30,true);
			addChild(nameText);
			nameText.x = panelwidth*0.3 ;
			nameText.y = panelheight*0.26;
			
			inputText = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			inputText.backgroundSkin = new Scale9Image(_inputSkinTextures);
			inputText.paddingLeft = 10;
			inputText.width = panelwidth*0.4;
			inputText.height = panelheight*0.08;
			Configrations.InputTextFactory(inputText,{color:0x000000,fontSize:30,maxChars:15,text:"",displayAsPassword:false});
			addChild(inputText);
			inputText.x = panelwidth/2 - inputText.width/2;
			inputText.y = panelheight*0.36 ;
			
			configCostPart();
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.08;
			addChild(backBut);
			backBut.x = panelwidth*0.2 - panelheight*0.04;
			backBut.y = panelheight*0.18;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			
			confirmBut = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("confirm");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.height = panelheight*0.08;
			addChild(confirmBut);
			confirmBut.validate();
			confirmBut.x = panelwidth*0.5 - confirmBut.width/2;
			confirmBut.y = costContainer.y + costContainer.height + 10*panelScale;
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
		}
		
		private function configCostPart():void
		{
			costContainer = new Sprite;
			addChild(costContainer);
			costContainer.x = panelwidth*0.3;
			costContainer.y = inputText.y + inputText.height + 10*panelScale;
			
			var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"), new Rectangle(20, 20, 20, 20)));
			costContainer.addChild(skin);
			skin.width = panelwidth*0.4;
			skin.height = panelheight*0.25;
			
			var infoText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.4,panelheight*0.1,LanguageController.getInstance().getString("ShopTip01"),0x000000,40,true);
			costContainer.addChild(infoText);
			
			var gemIcon:Image = new Image(Game.assets.getTexture("GemIcon"));
			gemIcon.width = gemIcon.height = panelheight*0.1;
			costContainer.addChild(gemIcon);
			gemIcon.x = panelwidth*0.2 - gemIcon.width - 5*panelScale;
			gemIcon.y = panelheight*0.12;
			
			var gemText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.2,gemIcon.height,"× "+clanGem,0x000000,40,true);
			gemText.autoSize = TextFieldAutoSize.HORIZONTAL;
			costContainer.addChild(gemText);
			gemText.x = panelwidth*0.2 + 5*panelScale;
			gemText.y = panelheight*0.12;
			
		}
		private function onTriggerConfirm(e:Event):void
		{
			if(GameController.instance.localPlayer.gem >= clanGem){
				if(inputText.text){
					new CreatClanCommand(inputText.text,onCreatSuccess);
				}else{
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("NoNameWarningTip")));
				}
			}else{
				DialogController.instance.showPanel(new BuyItemPanel());
				dispose();
			}
		}
		private function onCreatSuccess():void
		{
			DialogController.instance.showPanel(new ClanPanel(),true);
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
			