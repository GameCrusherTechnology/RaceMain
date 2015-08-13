package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;

	public class InputTextPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		public var inputText:TextInput;
		private var oldMes:String;
		private var maxSize:int;
		private var confirmBut:Button;
		private var cancelBut:Button;
		private var name:String;
		public function InputTextPanel(_name:String,text:String,_maxSize:int)
		{
			name = _name;
			oldMes = text;
			maxSize = _maxSize;
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
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackPanelSkin"),new Rectangle(19,5,100,25)));
			addChild(backSkin);
			backSkin.width = panelwidth*0.6;
			backSkin.height = panelheight*0.5;
			backSkin.x = panelwidth*0.2;
			backSkin.y = panelheight*0.2;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.6,panelheight*0.1,name,0xffffff,panelheight*0.05);
			addChild(nameText);
			nameText.x = panelwidth*0.2;
			nameText.y = panelheight*0.2;
			
			inputText = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20, 20, 20, 20));
			inputText.backgroundSkin = new Scale9Image(_inputSkinTextures);
			inputText.paddingLeft = 10;
			inputText.width = panelwidth*0.4;
			inputText.height = panelheight*0.15;
			Configrations.InputTextFactory(inputText,{color:0x000000,fontSize:30,maxChars:maxSize,text:oldMes,displayAsPassword:false});
			addChild(inputText);
			inputText.x = panelwidth/2 - inputText.width/2;
			inputText.y = panelheight*0.35 ;
			
			confirmBut = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("confirm");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.height = panelheight*0.08;
			addChild(confirmBut);
			confirmBut.validate();
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			
			cancelBut = new Button();
			cancelBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			cancelBut.label = LanguageController.getInstance().getString("cancel");
			cancelBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			cancelBut.paddingLeft = cancelBut.paddingRight = 20*panelScale;
			cancelBut.height = panelheight*0.08;
			addChild(cancelBut);
			cancelBut.validate();
			cancelBut.addEventListener(Event.TRIGGERED,onTriggerCancel);
			cancelBut.x = panelwidth*0.5 - confirmBut.width - 10*panelScale;
				
			confirmBut.x = panelwidth*0.5 + 10*panelScale;
			confirmBut.y = cancelBut.y =  panelheight*0.55;
		}
		
		private function onTriggerConfirm(e:Event):void
		{
			dispatchEvent(new PanelConfirmEvent(PanelConfirmEvent.CONFIRM));
		}
		
		private function onTriggerCancel(e:Event):void
		{
			dispatchEvent(new PanelConfirmEvent(PanelConfirmEvent.CANCEL));
		}
	}
}