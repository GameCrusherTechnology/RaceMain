package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.clan.ClanData;
	
	import service.command.clan.JoinClanCommand;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class SimpleClanInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var confirmBut:Button;
		private var clanData:ClanData;
		public function SimpleClanInfoPanel(_clan:ClanData)
		{
			clanData = _clan;
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
			
			titleText = FieldController.createNoFontField(panelwidth,titleSkin.height,clanData.name,0xffffff,titleSkin.height*0.8);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			var adminText:TextField = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("clanAdmin")+":",0x000000,panelheight*0.05,true);
			adminText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(adminText);
			adminText.y =  panelheight*0.3 ;
			adminText.x = panelwidth*0.5  - adminText.width - 10*panelScale;
			
			var adminNameText:TextField = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,clanData.adminHero.name,0xF0E266,panelheight*0.05,true);
			adminNameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(adminNameText);
			adminNameText.y =   panelheight*0.3;
			adminNameText.x = panelwidth*0.5 + 10*panelScale;
			
			
			var infoTextName:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.06,LanguageController.getInstance().getString("clan")+LanguageController.getInstance().getString("message") + ":",0x000000,panelheight*0.05,true);
			infoTextName.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(infoTextName);
			infoTextName.y =  panelheight*0.38  ;
			infoTextName.x = panelwidth*0.5  - adminText.width - 10*panelScale ;
			
			var str:String = clanData.clanMessage;
			if(!str){
				str = LanguageController.getInstance().getString("Noclaninfo");
			}
			var infoText:TextField = FieldController.createNoFontField(panelwidth*0.5,panelheight*0.1,str,0xF0E266,panelheight*0.03);
			addChild(infoText);
			infoText.y = panelheight*0.42 ;
			infoText.x = panelwidth*0.25;
			
			var memberText:TextField = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("members")+":",0x000000,panelheight*0.05,true);
			memberText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(memberText);
			memberText.y =  panelheight*0.52  ;
			memberText.x = panelwidth*0.5  - memberText.width - 10*panelScale;
			
			var canJoin:Boolean = true;
			if(clanData.memberCount >= clanData.totalMember){
				canJoin = false;
			}
			var memColor:uint;
			if(canJoin){
				memColor = 0xffffff;
			}else{
				memColor = 0xff0000;
			}
			var memberCountText:TextField = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,clanData.memberCount +"/" + clanData.totalMember,memColor,panelheight*0.05,true);
			memberCountText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(memberCountText);
			memberCountText.y = memberText.y;
			memberCountText.x = panelwidth*0.5  + 10*panelScale;
			
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.06;
			addChild(backBut);
			backBut.x = panelwidth*0.2 - panelheight*0.03;
			backBut.y = panelheight*0.2;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			if(canJoin){
				confirmBut = new Button();
				confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
				confirmBut.label = LanguageController.getInstance().getString("join");
				confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.05, 0x000000);
				confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
				confirmBut.height = panelheight*0.08;
				addChild(confirmBut);
				confirmBut.validate();
				confirmBut.x = panelwidth*0.5 - confirmBut.width/2;
				confirmBut.y = panelheight*0.8 - confirmBut.height - 10*panelScale;
				confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			}
		}
		
		private function onTriggerConfirm(e:Event):void
		{
			new JoinClanCommand(clanData.data_id,onJoinHandler);
		}
		private function onJoinHandler(bool:Boolean):void
		{
			if(bool){
				DialogController.instance.showPanel(new ClanPanel(),true);
			}else{
				dispose();
			}
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