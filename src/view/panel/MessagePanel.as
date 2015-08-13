package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class MessagePanel  extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var message:String;
		private var isConfirm:Boolean = false;
		
		private var confirmBut:Button;
		private var cancelBut:Button;
		public function MessagePanel(mess:String,_isConfirm:Boolean = false)
		{
			message = mess ;
			isConfirm = _isConfirm;
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
			backSkin.height = panelheight*0.6;
			backSkin.x = panelwidth*0.2;
			backSkin.y = panelheight*0.2;
			
			var mesText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.5,panelheight,message,0xffffff,40,true);
			addChild(mesText);
			mesText.autoSize = TextFieldAutoSize.VERTICAL;
			mesText.x = panelwidth*0.25;
			mesText.y = panelheight*0.25;
			
			
			confirmBut = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("confirm");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.paddingBottom = confirmBut.paddingTop = 20*panelScale;
			addChild(confirmBut);
			confirmBut.validate();
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			
			if(isConfirm){
				
				cancelBut = new Button();
				cancelBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
				cancelBut.label = LanguageController.getInstance().getString("cancel");
				cancelBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				cancelBut.paddingLeft = cancelBut.paddingRight = 20*panelScale;
				cancelBut.paddingBottom = cancelBut.paddingTop = 20*panelScale;
				addChild(cancelBut);
				cancelBut.validate();
				cancelBut.addEventListener(Event.TRIGGERED,onTriggerCancel);
				cancelBut.x = panelwidth*0.5 - confirmBut.width - 10*panelScale;
				
				confirmBut.x = panelwidth*0.5 + 10*panelScale;
				confirmBut.y = cancelBut.y =  panelheight*0.25 + mesText.height + 20*panelScale;
				
			}else{
					
				confirmBut.x = panelwidth*0.5 - confirmBut.width/2;
				confirmBut.y = panelheight*0.25 + mesText.height + 20*panelScale;
			}
			
			backSkin.height = confirmBut.y + confirmBut.height + 10*panelScale - backSkin.y;
		}
		
		private function onTriggerConfirm(e:Event):void
		{
			dispatchEvent(new PanelConfirmEvent(PanelConfirmEvent.CONFIRM));
			dispose();
		}
		
		private function onTriggerCancel(e:Event):void
		{
			dispatchEvent(new PanelConfirmEvent(PanelConfirmEvent.CANCEL));
			dispose();
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
	}
}