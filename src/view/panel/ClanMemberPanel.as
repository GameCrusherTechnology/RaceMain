package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.clan.ClanMemberData;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;

	public class ClanMemberPanel  extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var deleteBut:Button;
		
		private var memberData:ClanMemberData;
		public function ClanMemberPanel(mem:ClanMemberData)
		{
			memberData = mem;
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
			
			titleText = FieldController.createNoFontField(panelwidth,titleSkin.height,memberData.heroData.name,0xffffff,titleSkin.height*0.8);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.06;
			addChild(backBut);
			backBut.x = panelwidth*0.2 - panelheight*0.03;
			backBut.y = panelheight*0.2;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			var icon:Image = new Image(Game.assets.getTexture(memberData.heroData.characterSpec.name+"Icon"));
			icon.height = panelheight * 0.2;
			icon.scaleX = icon.scaleY;
			addChild(icon);
			icon.x = panelwidth*0.25;
			icon.y = panelheight*0.3;
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = 50*panelScale;
			addChild(expIcon);
			expIcon.x = panelwidth*0.5 + 5*panelScale;
			expIcon.y = panelheight*0.3;
			
			var expText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,expIcon.height,String(memberData.heroData.level),0x000000,15,true);
			addChild(expText);
			expText.x = expIcon.x;
			expText.y = expIcon.y;
			
			if(isClanOwner &&　(memberData.heroData.characteruid != GameController.instance.currentHero.characteruid)){
				deleteBut = new Button();
				deleteBut.defaultSkin = new Image(Game.assets.getTexture("R_button"));
				deleteBut.label = LanguageController.getInstance().getString("Remove");
				deleteBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				deleteBut.paddingLeft = deleteBut.paddingRight = 20*panelScale;
				deleteBut.height = panelheight*0.08;
				addChild(deleteBut);
				deleteBut.validate();
				deleteBut.x = panelwidth*0.5 - deleteBut.width/2;
				deleteBut.y = panelheight*0.8 - deleteBut.height - 10*panelScale;
				deleteBut.addEventListener(Event.TRIGGERED,onTriggerDelete);
			}
		}
		
		private function get isClanOwner():Boolean
		{
			return GameController.instance.currentHero.isClanAdmin;
		}
		
		private function onTriggerDelete(e:Event):void
		{
			var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("removeMemberTip01"),true)
			DialogController.instance.showPanel(panel);
			panel.addEventListener(PanelConfirmEvent.CLOSE,onConfirmHandler);
		}
		
		private function onConfirmHandler(e:PanelConfirmEvent):void
		{
			if(e.BeConfirm){
				
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