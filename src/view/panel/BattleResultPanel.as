package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.compenent.ThreeStarBar;
	import view.render.RewardListRender;

	public class BattleResultPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var stars:int;
		private var rewards:Object;
		public function BattleResultPanel(_stars:int,_rewards:Array=null)
		{
			rewards = _rewards;
			stars = _stars;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.2;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth*0.8;
			backSkin.height = panelheight*0.7;
			backSkin.x = panelwidth*0.1;
			backSkin.y = panelheight*0.1;
			
			var titleSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20)));
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.8;
			titleSkin.height = panelheight*0.08;
			titleSkin.x = panelwidth*0.1;
			titleSkin.y = panelheight*0.1;
			
			var str:String ;
			if(stars <=0){
				str = LanguageController.getInstance().getString("defeat");
			}else{
				str = LanguageController.getInstance().getString("victory");
			}
			var titleText:TextField = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,str,0x000000,titleSkin.height*0.6,true);
			addChild(titleText);
			titleText.y =  panelheight*0.1;
			
			var bar:ThreeStarBar = new ThreeStarBar(stars,panelheight*0.18);
			addChild(bar);
			bar.x = panelwidth/2 - bar.width/2;
			bar.y = panelheight*0.2;
			
			if(stars>0){
				configRewardContainer();
			}else{
				configDefeatContainer();
			}
			
			var confirmBut:Button = new Button();
			confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			confirmBut.label = LanguageController.getInstance().getString("confirm");
			confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
			confirmBut.height = panelheight*0.08;
			addChild(confirmBut);
			confirmBut.validate();
			confirmBut.addEventListener(Event.TRIGGERED,onTriggerConfirm);
			confirmBut.x = panelwidth/2 - confirmBut.width/2;
			confirmBut.y = panelheight*0.65;
			
		}
		private function configRewardContainer():void
		{
			const listLayout1: HorizontalLayout= new HorizontalLayout();
			listLayout1.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout1.gap = panelwidth*0.02;
			
			var rewardsList:List = new List();
			
			var listSkin:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("WhiteSkin"),new Rectangle(2,2,60,60)));
			listSkin.alpha = 0.5;
			rewardsList.backgroundSkin =listSkin;
			rewardsList.layout = listLayout1;
			rewardsList.dataProvider = getInfoListData();
			rewardsList.itemRendererFactory =function tileListItemRendererFactory():RewardListRender
			{
				
				var renderer:RewardListRender = new RewardListRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
				renderer.width =renderer.height =  panelwidth *0.15;
				return renderer;
			}
			rewardsList.width =  panelwidth*0.6;
			rewardsList.height =  panelheight*0.3;
			rewardsList.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			rewardsList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			addChild(rewardsList);
			rewardsList.x = panelwidth/2 - rewardsList.width/2;
			rewardsList.y = panelheight*0.3;
		}
		
		
		private function configDefeatContainer():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = panelwidth*0.2;
			container.y = panelheight*0.3;
			
			var cback:Scale9Image =  new Scale9Image(new Scale9Textures(Game.assets.getTexture("WhiteSkin"),new Rectangle(2,2,60,60)));
			cback.alpha = 0.5;
			container.addChild(cback);
			cback.width =  panelwidth*0.6;
			cback.height =  panelheight*0.3;
			
			var spSkin:Image = new Image(Game.assets.getTexture("TitleTextSkin"));
			container.addChild(spSkin);
			var nameText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.6,panelheight*0.07,LanguageController.getInstance().getString("improveself"),0xffffff,panelheight*0.06);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x =  panelwidth*0.3 - nameText.width/2;
			
			spSkin.width = nameText.width + panelwidth*0.06;
			spSkin.height = panelheight*0.07;
			spSkin.x =  panelwidth*0.3 - spSkin.width/2;
			
			var skin1:Image =  new Image(Game.assets.getTexture("BPanelSkin"));
			skin1.width =  panelwidth*0.25;
			skin1.height = panelheight*0.2;
			container.addChild(skin1);
			skin1.x = panelwidth*0.02;
			skin1.y = panelheight*0.08;
			
			var text1:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.25,panelheight*0.15,LanguageController.getInstance().getString("vipinfo"),0x000000,panelheight*0.04);
			container.addChild(text1);
			text1.x = skin1.x;
			text1.y = skin1.y;
			
			var checkVipBut:Button = new Button();
			checkVipBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			checkVipBut.label = LanguageController.getInstance().getString("check");
			checkVipBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.03, 0x000000);
			checkVipBut.paddingLeft = checkVipBut.paddingRight = 10*panelScale;
			checkVipBut.height = panelheight*0.05;
			container.addChild(checkVipBut);
			checkVipBut.validate();
			checkVipBut.addEventListener(Event.TRIGGERED,onTriggerCheck);
			checkVipBut.x = skin1.x + skin1.width/2 - checkVipBut.width/2;
			checkVipBut.y = panelheight*0.22;
			
			
			var skin2:Image =  new Image(Game.assets.getTexture("BPanelSkin"));
			skin2.width =  panelwidth*0.25;
			skin2.height = panelheight*0.2;
			container.addChild(skin2);
			skin2.x = panelwidth*0.33;
			skin2.y = panelheight*0.08;
			
			
			var text2:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.25,panelheight*0.15,LanguageController.getInstance().getString("updateinfo"),0x000000,panelheight*0.04);
			container.addChild(text2);
			text2.x = skin2.x;
			text2.y = skin2.y;
			
			var updateBut:Button = new Button();
			updateBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			updateBut.label = LanguageController.getInstance().getString("compose");
			updateBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.03, 0x000000);
			updateBut.paddingLeft = updateBut.paddingRight = 10*panelScale;
			updateBut.height = panelheight*0.05;
			container.addChild(updateBut);
			updateBut.validate();
			updateBut.addEventListener(Event.TRIGGERED,onTriggerUpdate);
			updateBut.x = skin2.x + skin2.width/2 - updateBut.width/2;
			updateBut.y = panelheight*0.22;
		}
		
		
		private function getInfoListData():ListCollection
		{
			return new ListCollection(rewards);
		}
		
		private function onTriggerConfirm(e:Event):void
		{
			removeFromParent(true);
		}
		private function onTriggerCheck(e:Event):void
		{
			removeFromParent(true);
			DialogController.instance.showPanel(new VipPanel());
		}
		private function onTriggerUpdate(e:Event):void
		{
			removeFromParent(true);
			DialogController.instance.showPanel(new ComposePanel());
		}
		
	}
}