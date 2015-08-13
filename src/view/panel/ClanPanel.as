package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.LocalData;
	import gameconfig.SystemDate;
	
	import model.clan.ClanBossData;
	import model.clan.ClanData;
	import model.gameSpec.ItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.player.BossPlayer;
	import model.player.GamePlayer;
	import model.staticData.MessageData;
	
	import service.command.battle.BeginBossAttack;
	import service.command.battle.RefreshClanBoss;
	import service.command.clan.DissolveClanCommand;
	import service.command.clan.EditClanMessage;
	import service.command.clan.RefreshMessage;
	import service.command.clan.SignOutClanCommand;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.ClanMemberRender;
	import view.render.MessageRender;
	import view.screen.BattleScene;
	
	public class ClanPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var memberList:List;
		private var titleText:TextField;
		private var backBut:Button;
		private var writeBut:Button;
		private var clanData:ClanData;
		private var infoText:TextField;
		private var deleteClanBut:Button;
		private var mesList:List;
		
		public function ClanPanel()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			clanData = hero.clanData;
			
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
			
			titleText = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,clanData.name,0xffffff,35,true);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			var str:String = clanData.clanMessage;
			if(!str){
				str = LanguageController.getInstance().getString("Noclaninfo");
			}
			infoText = FieldController.createNoFontField(panelwidth*0.7,panelheight*0.1,str,0xffFF00,panelheight*0.04);
			addChild(infoText);
			infoText.y =  panelheight*0.2;
			infoText.x = panelwidth*0.15;
			
			if(hero.isClanAdmin){
				writeBut = new Button();
				writeBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
				writeBut.label = LanguageController.getInstance().getString("Edit");
				writeBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				writeBut.paddingLeft = writeBut.paddingRight = 10*panelScale;
				writeBut.paddingTop = writeBut.paddingBottom = 8*panelScale;
				addChild(writeBut);
				writeBut.validate();
				writeBut.x = panelwidth*0.85;
				writeBut.y = panelheight*0.25 -  writeBut.height/2;
				writeBut.addEventListener(Event.TRIGGERED,onTriggerWrite);
			}
			
			const listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.gap = 10*panelScale;
			
			memberList = new List();
			
			var listSkin:Scale9Image =  new Scale9Image(new Scale9Textures( Game.assets.getTexture("WhiteSkin"),new Rectangle(2,2,60,60)));
			listSkin.alpha = 0.5;
			memberList.backgroundSkin =listSkin;
			
			memberList.layout = listLayout;
			memberList.dataProvider = new ListCollection(clanData.listMemberVec);
			memberList.itemRendererFactory =function tileListItemRendererFactory():ClanMemberRender
			{
				var renderer:ClanMemberRender = new ClanMemberRender();
				renderer.width = panelwidth *0.1;
				renderer.height = panelheight *0.18;
				return renderer;
			}
			memberList.width =  panelwidth*0.7;
			memberList.height =  panelheight *0.2;
			memberList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			memberList.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			addChild(memberList);
			memberList.x = panelwidth*0.15;
			memberList.y = panelheight*0.3;
			memberList.selectedIndex = -1;

			
			const listLayout1:VerticalLayout = new VerticalLayout();
			listLayout1.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout1.paddingTop = listLayout1.paddingBottom = 10*panelScale;
			listLayout1.gap = 10*panelScale;
			
			mesList = new List();
			
			var listSkin1:Scale9Image =  new Scale9Image(new Scale9Textures( Game.assets.getTexture("PanelRenderSkin"),new Rectangle(12,12,40,40)));
			mesList.backgroundSkin =listSkin1;
			
			mesList.layout = listLayout1;
			mesList.dataProvider = mesArr;
			mesList.itemRendererFactory =function tileListItemRendererFactory():MessageRender
			{
				var renderer:MessageRender = new MessageRender();
				renderer.width = panelwidth *0.45;
				renderer.height = panelheight *0.08;
				return renderer;
			}
			mesList.width =  panelwidth*0.5;
			mesList.height =  panelheight *0.38;
			mesList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			addChild(mesList);
			mesList.x = panelwidth*0.15;
			mesList.y = panelheight*0.52;
			mesList.addEventListener(Event.CHANGE,onMessageListChange);
			
			configBossPart();
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			deleteClanBut = new Button();
			deleteClanBut.defaultSkin = new Image(Game.assets.getTexture("R_button"));
			deleteClanBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
			deleteClanBut.paddingLeft = deleteClanBut.paddingRight = 10*panelScale;
			deleteClanBut.height = panelheight*0.06;
			addChild(deleteClanBut);
			if(hero.isClanAdmin){
				deleteClanBut.label = LanguageController.getInstance().getString("dissolve");
				deleteClanBut.addEventListener(Event.TRIGGERED,onTriggerDelete);
			}else{
				deleteClanBut.label = LanguageController.getInstance().getString("Sign out");
				deleteClanBut.addEventListener(Event.TRIGGERED,onTriggerOut);
			}
			deleteClanBut.validate();
			deleteClanBut.x = panelwidth*0.9 - deleteClanBut.width;
			deleteClanBut.y = panelheight*0.14- deleteClanBut.height/2 ;
		}
		private var bossPartContainer:Sprite;
		private function configBossPart():void
		{
			if(bossPartContainer){
				bossPartContainer.removeFromParent(true);
				bossPartContainer = null;
			}
			
			bossPartContainer = new Sprite;
			addChild(bossPartContainer);
			
			var skin1:Scale9Image =  new Scale9Image(new Scale9Textures( Game.assets.getTexture("PanelRenderSkin"),new Rectangle(12,12,40,40)));
			skin1.width = panelwidth*0.18;
			skin1.height = panelheight *0.38;
			bossPartContainer.addChild(skin1);
			
			if(hero.BossTime > SystemDate.systemTimeS){
				var spec:ItemSpec = SpecController.instance.getItemSpec(hero.BossId);
				
				var nameText:TextField = FieldController.createSingleLineDynamicField(skin1.width, panelheight *0.05,spec.cname,0x000000,panelheight *0.04);
				bossPartContainer.addChild(nameText);
				
				var icon:Image = new Image(spec.iconTexture);
				icon.height  = panelheight*0.15;
				icon.scaleX = icon.scaleY;
				bossPartContainer.addChild(icon);
				icon.x = skin1.width/2 - icon.width/2;
				icon.y = panelheight *0.06;
				
				var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
				expIcon.width = expIcon.height = panelwidth*0.05;
				bossPartContainer.addChild(expIcon);
				expIcon.x = icon.x+icon.width - expIcon.width/2;
				expIcon.y = icon.y + icon.height - expIcon.height;
				
				var expText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,expIcon.height,String(hero.clanBossDate.level),0x000000,expIcon.height*0.5);
				bossPartContainer.addChild(expText);
				expText.x = expIcon.x;
				expText.y = expIcon.y;
				
				var killNameText:TextField = FieldController.createSingleLineDynamicField(200,panelheight*0.06,LanguageController.getInstance().getString("killed") +":",0x000000,panelheight*0.04);
				killNameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				bossPartContainer.addChild(killNameText);
				killNameText.x = skin1.width/2 - killNameText.width;
				killNameText.y = icon.y + icon.height + panelheight*0.01;
				
				var killText:TextField = FieldController.createSingleLineDynamicField(200,panelheight*0.06," "+ String(hero.clanBossDate.kills),0x00ffc0,panelheight*0.05);
				killText.autoSize = TextFieldAutoSize.HORIZONTAL;
				bossPartContainer.addChild(killText);
				killText.x = skin1.width/2;
				killText.y = killNameText.y;
				
				
				var attackBut:Button = new Button();
				attackBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				var iconM:Image = new Image(Game.assets.getTexture("EnergyIcon"));
				iconM.width = iconM.height = panelheight*0.03;
				attackBut.defaultIcon = iconM;
				attackBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.03, 0x000000);
				attackBut.paddingLeft = attackBut.paddingRight = 10*panelScale;
				attackBut.paddingBottom = attackBut.paddingTop = 5*panelScale;
				attackBut.label =  "×"+String(Configrations.Battle_Energy_Cost) +" " + LanguageController.getInstance().getString("attack");
				bossPartContainer.addChild(attackBut);
				attackBut.validate();
				attackBut.x =skin1.width/2 - attackBut.width/2;
				attackBut.y = skin1.height - attackBut.height - panelheight*0.01;
				
				var clanleftTime:int = clanData.userClanData.bossTime - SystemDate.systemTimeS;
				if(clanleftTime<0){
					attackBut.addEventListener(Event.TRIGGERED,onTriggerAttack);
				}else{
					attackBut.filter = Configrations.grayscaleFilter;
					attackBut.touchable  = false;
					
					var clantimeText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.03,"("+SystemDate.getTimeMinLeftString(clanleftTime)+")",0x000000,panelheight*0.025);
					clantimeText.autoSize = TextFieldAutoSize.HORIZONTAL;
					bossPartContainer.addChild(clantimeText);
					clantimeText.x =  attackBut.x + attackBut.width/2 - clantimeText.width/2;
					clantimeText.y = attackBut.y - clantimeText.height - panelheight*0.01;
				}
				
			}else{
				if(!iscommanding){
					new RefreshClanBoss(clanData.data_id,onRefreshedBoss);
					iscommanding = true;
				}
			}
			bossPartContainer.x = panelwidth * 0.67;
			bossPartContainer.y = panelheight*0.52;
		}
		
		private function onRefreshedBoss():void
		{
			iscommanding = false;
			configBossPart();
		}
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support,parentAlpha);
			if(!iscommanding && LocalData.canRefreshMessage()){
				new RefreshMessage(clanData.data_id,onRefreshed);
				iscommanding  = true;
			}
		}
		private function onRefreshed():void
		{
			iscommanding = false;
			mesList.dataProvider = mesArr;
			mesList.validate();
		}
		private function onMessageListChange(e:Event):void
		{
			if(mesList.selectedIndex == 0 ){
				mesList.dataProvider = mesArr;
				mesList.validate();
				mesList.selectedIndex = -1;
			}
		}
		
		private function onTriggerAttack(e:Event):void
		{
			
			if(!iscommanding){
				if(hero.curPower < Configrations.Battle_Energy_Cost){
					var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("warningEnergyTip"),true);
					DialogController.instance.showPanel(panel);
					panel.addEventListener(PanelConfirmEvent.CLOSE,onConfirmed);
				}else if(!iscommanding){
					new BeginBossAttack(clanData.data_id,onBeginBoss);
					iscommanding = true;
				}
				
			}
		}
		private function onConfirmed(e:PanelConfirmEvent):void
		{
			if(e.BeConfirm){
				DialogController.instance.showPanel(new ItemPanel(ItemPanel.ENERGY));
			}
		}
		
		private function onBeginBoss():void
		{
			iscommanding = false;
			
			var bossSpec:SoldierItemSpec = SpecController.instance.getItemSpec(hero.BossId) as SoldierItemSpec;
			if(bossSpec){
				var data:ClanBossData = hero.clanBossDate;
				GameController.instance.showBattle(new BattleScene(GameController.instance.currentHero,new BossPlayer(bossSpec,data.level,data.kills)));
			}
			removeFromParent(true);
		}
		private function onTriggerWrite(e:Event):void
		{
			var panel:InputTextPanel = new InputTextPanel(LanguageController.getInstance().getString("claninfoTip"),clanData.clanMessage,100);
			DialogController.instance.showPanel(panel);
			panel.addEventListener(PanelConfirmEvent.CLOSE,onConfirmHandler);
		}
		private function onConfirmHandler(e:PanelConfirmEvent):void
		{
			var inputPanel:InputTextPanel = e.target as InputTextPanel;
			if(inputPanel){
				if(e.BeConfirm){
					//修改备注信息
					var newText:String = inputPanel.inputText.text;
					new EditClanMessage(newText,clanData.data_id);
					infoText.text = newText;
					clanData.clanMessage = newText;
				}
				inputPanel.removeFromParent(true);
			}
		}
		private function onTriggerOut(e:Event):void
		{
			var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("signOutclanTip01"),true)
			DialogController.instance.showPanel(panel);
			panel.addEventListener(PanelConfirmEvent.CLOSE,onSignOutConfirmHandler);
		}
		private function onSignOutConfirmHandler(e:PanelConfirmEvent):void
		{
			if(!iscommanding && e.BeConfirm){
				new SignOutClanCommand(clanData.data_id,onDissolved);
				iscommanding = true;
			}
		}
		private function onTriggerDelete(e:Event):void
		{
			var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("dissolveclanTip01"),true)
			DialogController.instance.showPanel(panel);
			panel.addEventListener(PanelConfirmEvent.CLOSE,onDissolveConfirmHandler);
		}
		private function onDissolveConfirmHandler(e:PanelConfirmEvent):void
		{
			if(!iscommanding && e.BeConfirm){
				new DissolveClanCommand(clanData.data_id,onDissolved);
				iscommanding = true;
			}
		}
		private var iscommanding:Boolean;
		private function get mesArr():ListCollection
		{
			var list:ListCollection;
			var arr:Array =   [new MessageData("")].concat(clanData.clanTalk);
			return new ListCollection(arr);
		}
		
		private function onDissolved():void
		{
			iscommanding = false;
			dispose();
		}
		private function onTriggerBack(e:Event):void
		{
			dispose();
		}
		
		private function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
	}
}