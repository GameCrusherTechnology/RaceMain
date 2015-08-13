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
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.LocalData;
	import gameconfig.SystemDate;
	
	import model.clan.ClanBossData;
	import model.gameSpec.ItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.player.BossPlayer;
	import model.player.GamePlayer;
	import model.staticData.VipData;
	
	import service.command.battle.BeginBossAttack;
	import service.command.battle.GetRateClanReward;
	import service.command.battle.GetRateHeroReward;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.RatingRender;
	import view.screen.BattleScene;
	
	public class RatingPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var curHero :GamePlayer;
		private var tabBar:TabBar;
		private var itemList:List;
		
		public function RatingPanel()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			curHero = GameController.instance.currentHero;
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
			
			
			tabBar = new TabBar();
			var tabList:ListCollection =new ListCollection(
				[
					{ label: LanguageController.getInstance().getString("hero")},
					{ label: LanguageController.getInstance().getString("clan")}
				]);
			tabBar.dataProvider = tabList;
			tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			tabBar.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			tabBar.tabFactory = function():Button
			{
				var tab:Button = new Button();
				tab.defaultSelectedSkin =  new Image(Game.assets.getTexture("TabButtonSelectedSkin"));
				tab.defaultSkin =  new Image(Game.assets.getTexture("TabButtonSkin"));
				tab.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
				return tab;
			}
			addChild(this.tabBar);
			tabBar.width = panelwidth*0.8;
			tabBar.height = panelheight*0.08;
			tabBar.x = panelwidth*0.1 ;
			tabBar.y = panelheight*0.1 ;
			configTopNamePart();
			configList();
			
			configBottomPart();
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
		}
		
		private function configTopNamePart():void
		{
			heroTopContainer = new Sprite;
			var topskin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("TitleTextSkin"),new Rectangle(20,5,50,10)));
			topskin.width = panelwidth*0.7;
			topskin.height = panelheight*0.04;
			heroTopContainer.addChild(topskin);
			
			var text1:TextField = FieldController.createSingleLineDynamicField(panelwidth,topskin.height,LanguageController.getInstance().getString("name"),0xffffff,topskin.height*0.9);
			text1.autoSize = TextFieldAutoSize.HORIZONTAL;
			heroTopContainer.addChild(text1);
			text1.x = panelheight *0.05*1.6;
			
			var text2:TextField = FieldController.createSingleLineDynamicField(panelwidth,topskin.height,LanguageController.getInstance().getString("level"),0xffffff,topskin.height*0.9);
			text2.autoSize = TextFieldAutoSize.HORIZONTAL;
			heroTopContainer.addChild(text2);
			text2.x = panelwidth*0.7*0.4;
			
			var text3:TextField = FieldController.createSingleLineDynamicField(panelwidth,topskin.height,LanguageController.getInstance().getString("clan"),0xffffff,topskin.height*0.9);
			text3.autoSize = TextFieldAutoSize.HORIZONTAL;
			heroTopContainer.addChild(text3);
			text3.x = panelwidth*0.7*0.55;
			
			var text4:TextField = FieldController.createSingleLineDynamicField(panelwidth,topskin.height,LanguageController.getInstance().getString("score"),0xffffff,topskin.height*0.9);
			text4.autoSize = TextFieldAutoSize.HORIZONTAL;
			heroTopContainer.addChild(text4);
			text4.x = panelwidth*0.7*0.8;
			
			heroTopContainer.x = panelwidth*0.15;
			heroTopContainer.y = panelheight*0.18;
			addChild(heroTopContainer);
			
			clanTopContainer = new Sprite;
			var topskin1:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("TitleTextSkin"),new Rectangle(20,5,50,10)));
			clanTopContainer.addChild(topskin1);
			topskin1.width = panelwidth*0.7;
			topskin1.height = topskin.height;
			
			var text5:TextField = FieldController.createSingleLineDynamicField(panelwidth,topskin.height,LanguageController.getInstance().getString("name"),0xffffff,topskin.height*0.9);
			text5.autoSize = TextFieldAutoSize.HORIZONTAL;
			clanTopContainer.addChild(text5);
			text5.x = panelheight *0.05*1.6;
			
			var text6:TextField = FieldController.createSingleLineDynamicField(panelwidth,topskin.height,LanguageController.getInstance().getString("userId"),0xffffff,topskin.height*0.9);
			text6.autoSize = TextFieldAutoSize.HORIZONTAL;
			clanTopContainer.addChild(text6);
			text6.x = panelwidth*0.7*0.4;
			
			var text9:TextField = FieldController.createSingleLineDynamicField(panelwidth,topskin.height,LanguageController.getInstance().getString("boss"),0xffffff,topskin.height*0.9);
			text9.autoSize = TextFieldAutoSize.HORIZONTAL;
			clanTopContainer.addChild(text9);
			text9.x = panelwidth*0.7*0.6 - text9.width/2 ;
			
			var text7:TextField = FieldController.createSingleLineDynamicField(panelwidth,topskin.height,LanguageController.getInstance().getString("level"),0xffffff,topskin.height*0.9);
			text7.autoSize = TextFieldAutoSize.HORIZONTAL;
			clanTopContainer.addChild(text7);
			text7.x = panelwidth*0.7*0.75 - text7.width/2;
			
			var text8:TextField = FieldController.createSingleLineDynamicField(panelwidth,topskin.height,LanguageController.getInstance().getString("killed"),0xffffff,topskin.height*0.9);
			text8.autoSize = TextFieldAutoSize.HORIZONTAL;
			clanTopContainer.addChild(text8);
			text8.x = panelwidth*0.7*0.9 - text8.width/2;
			
			
			clanTopContainer.x = panelwidth*0.15;
			clanTopContainer.y = panelheight*0.18;
			addChild(clanTopContainer);
			
		}
		
		private var heroTopContainer:Sprite;
		private var clanTopContainer:Sprite;
		private function configList():void
		{
			if(!itemList){
				itemList = new List();
				
				const listLayout:VerticalLayout = new VerticalLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_TOP;
				listLayout.gap = panelheight*0.01;
				
				itemList.layout = listLayout;
				itemList.dataProvider = listData;
				itemList.itemRendererFactory =function tileListItemRendererFactory():RatingRender
				{
					var renderer:RatingRender = new RatingRender();
					
					renderer.defaultSkin = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListRenderSkin"),new Rectangle(50,15,200,30)));
					renderer.width = panelwidth *0.7;
					renderer.height = panelheight *0.05;
					return renderer;
				}
				itemList.width =  panelwidth*0.7;
				itemList.height =  panelheight *0.47;
				itemList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				itemList.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
				addChild(itemList);
				itemList.x = panelwidth*0.15;
				itemList.y = panelheight*0.22;
				itemList.selectedIndex = -1;
			}else{
				itemList.dataProvider = listData;
				itemList.validate();
			}
		}
		private var bottomPart:Sprite;
		private function configBottomPart():void
		{
			if(bottomPart){
				bottomPart.removeFromParent(true);
				bottomPart = null;
			}
			bottomPart = new Sprite;
			addChild(bottomPart);
			
			var skin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(20,20,20,20)));
			bottomPart.addChild(skin);
			skin.width = panelwidth*0.34;
			skin.height = panelheight*0.18;
			
			var skin1:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(20,20,20,20)));
			bottomPart.addChild(skin1);
			skin1.width = panelwidth*0.34;
			skin1.height = panelheight*0.18;
			skin1.x = panelwidth*0.36;
			
			
			if(currentTabIndex == 1){
				
				var clanicon:Image= new Image(Game.assets.getTexture("ClanBigIcon"));
				clanicon.height = panelheight*0.12;
				clanicon.scaleX = clanicon.scaleY;
				bottomPart.addChild(clanicon);
				clanicon.x = panelwidth*0.02;
				clanicon.y = skin.height/2- clanicon.height/2;
				
				if(hero.clanData){
					var spec:ItemSpec = SpecController.instance.getItemSpec(hero.BossId);
					if(spec){
						
						var clanscoreText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString("score") +": ",0x000000,panelheight*0.04);
						clanscoreText.autoSize = TextFieldAutoSize.HORIZONTAL;
						bottomPart.addChild(clanscoreText);
						clanscoreText.x = clanicon.x + clanicon.width ;
						clanscoreText.y = 0;
						
						var clanscoreText1:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,String(hero.clanBossDate.level),0x00ffff,panelheight*0.04);
						clanscoreText1.autoSize = TextFieldAutoSize.HORIZONTAL;
						bottomPart.addChild(clanscoreText1);
						clanscoreText1.x = clanscoreText.x+clanscoreText.width;
						
						var clanrateText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString("rank") +": ",0x000000,panelheight*0.04);
						clanrateText.autoSize = TextFieldAutoSize.HORIZONTAL;
						bottomPart.addChild(clanrateText);
						clanrateText.x = clanscoreText.x;
						clanrateText.y = panelheight*0.05;
						
						var clanrank:int = hero.clanData.clanRank;
						
						var clanrateText1:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,String((clanrank == 0)?"100+":clanrank),0x0000ff,panelheight*0.04);
						clanrateText1.autoSize = TextFieldAutoSize.HORIZONTAL;
						bottomPart.addChild(clanrateText1);
						clanrateText1.x = clanrateText.x+clanrateText.width;
						clanrateText1.y = panelheight*0.05;
						
						var clanrewardBut:Button = new Button();
						clanrewardBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
						clanrewardBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
						clanrewardBut.paddingLeft = clanrewardBut.paddingRight = 10*panelScale;
						clanrewardBut.paddingBottom = clanrewardBut.paddingTop = 5*panelScale;
						bottomPart.addChild(clanrewardBut);
						clanrewardBut.validate();
						clanrewardBut.x =clanscoreText.x;
						clanrewardBut.y = panelheight*0.1;
						var clanleftTime:int = hero.clanRateTime - SystemDate.systemTimeS;
						if(clanleftTime>0){
							clanrewardBut.label = LanguageController.getInstance().getString("recived");
							clanrewardBut.filter = Configrations.grayscaleFilter;
							clanrewardBut.touchable  = false;
							
							var clantimeText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.03,"("+SystemDate.getTimeMinLeftString(clanleftTime)+")",0x000000,panelheight*0.025);
							clantimeText.autoSize = TextFieldAutoSize.HORIZONTAL;
							bottomPart.addChild(clantimeText);
							clantimeText.x =  clanrewardBut.x + clanrewardBut.width/2 - clantimeText.width/2;
							clantimeText.y = panelheight*0.15;
						}else{
							clanrewardBut.label = LanguageController.getInstance().getString("recive");
							clanrewardBut.addEventListener(Event.TRIGGERED,onTriggerClanReward);
						}
						
					}
				}else{
					
					
					var searchBut:Button = new Button();
					searchBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
					searchBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
					searchBut.label = LanguageController.getInstance().getString("join") +" "+ LanguageController.getInstance().getString("clan");
					searchBut.paddingLeft = searchBut.paddingRight = 10*panelScale;
					searchBut.paddingBottom = searchBut.paddingTop = 5*panelScale;
					bottomPart.addChild(searchBut);
					searchBut.validate();
					searchBut.x = clanicon.x + clanicon.width + (skin.width - clanicon.x - clanicon.width)/2 - searchBut.width/2;
					searchBut.y = skin.height/2- searchBut.height/2;
					searchBut.addEventListener(Event.TRIGGERED,onTriggerJoinClan);
					
				}
				
			}else{
				
				var heroicon:Image= new Image(Game.assets.getTexture(hero.characterSpec.name+"HeadIcon"));
				heroicon.height = panelheight*0.15;
				heroicon.scaleX = heroicon.scaleY;
				bottomPart.addChild(heroicon);
				heroicon.x = panelwidth*0.02;
				heroicon.y = skin.height/2- heroicon.height/2;
				
				var scoreText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString("score") +": ",0x000000,panelheight*0.04);
				scoreText.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(scoreText);
				scoreText.x = heroicon.x + heroicon.width;
				scoreText.y = 0;
				
				var scoreText1:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,String(hero.rateData.score),0x00ffff,panelheight*0.04);
				scoreText1.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(scoreText1);
				scoreText1.x = scoreText.x+scoreText.width;
				
				var rateText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString("rank") +": ",0x000000,panelheight*0.04);
				rateText.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(rateText);
				rateText.x = scoreText.x;
				rateText.y = panelheight*0.05;
				
				var rank:int = hero.heroRank;
				
				var rateText1:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,String((rank == 0)?"100+":rank),0x0000ff,panelheight*0.04);
				rateText1.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(rateText1);
				rateText1.x = rateText.x+rateText.width;
				rateText1.y = panelheight*0.05;
				
				if(hero.rateData.score > 0){
					var rewardBut:Button = new Button();
					rewardBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
					rewardBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
					rewardBut.paddingLeft = rewardBut.paddingRight = 10*panelScale;
					rewardBut.paddingBottom = rewardBut.paddingTop = 5*panelScale;
					bottomPart.addChild(rewardBut);
					rewardBut.validate();
					rewardBut.x =scoreText.x;
					rewardBut.y = panelheight*0.1;
					var leftTime:int = hero.heroRateTime - SystemDate.systemTimeS;
					if(leftTime>0){
						rewardBut.label = LanguageController.getInstance().getString("recived");
						rewardBut.filter = Configrations.grayscaleFilter;
						rewardBut.touchable  = false;
						
						var timeText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.03,"("+SystemDate.getTimeMinLeftString(leftTime)+")",0x000000,panelheight*0.025);
						timeText.autoSize = TextFieldAutoSize.HORIZONTAL;
						bottomPart.addChild(timeText);
						timeText.x =  rewardBut.x + rewardBut.width/2 - timeText.width/2;
						timeText.y = panelheight*0.15;
					}else{
						rewardBut.label = LanguageController.getInstance().getString("recive");
						rewardBut.addEventListener(Event.TRIGGERED,onTriggerReward);
					}
				}
				
			}
			
			if(currentTabIndex == 1 && hero.clanData){
				var bossspec:ItemSpec = SpecController.instance.getItemSpec(hero.BossId);
				if(bossspec){
					
				}
				
				var icon:Image = new Image(bossspec.iconTexture);
				icon.height  = panelheight*0.15;
				icon.scaleX = icon.scaleY;
				bottomPart.addChild(icon);
				icon.x = skin1.x + panelwidth*0.02;
				icon.y = skin1.height/2 - icon.height/2;
				
				var expNameText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString("level")+": ",0x000000,panelheight*0.04);
				expNameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(expNameText);
				expNameText.x = icon.x + icon.width + panelwidth*0.02;
				expNameText.y = 0;
				
				var expText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,String(hero.clanBossDate.level),0x000000,panelheight*0.04);
				expText.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(expText);
				expText.x = expNameText.x + expNameText.width;
				expText.y = expNameText.y;
				
				var killNameText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString("killed") +": ",0x000000,panelheight*0.04);
				killNameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(killNameText);
				killNameText.x = expNameText.x;
				killNameText.y = expNameText.y + expNameText.height ;
				
				var killText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05, String(hero.clanBossDate.kills),0xfadf00,panelheight*0.04);
				killText.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(killText);
				killText.x = killNameText.x + killNameText.width;
				killText.y = killNameText.y;
				
				
				var attackBut:Button = new Button();
				attackBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				var iconM:Image = new Image(Game.assets.getTexture("EnergyIcon"));
				iconM.width = iconM.height = panelheight*0.04;
				attackBut.defaultIcon = iconM;
				attackBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
				attackBut.paddingLeft = attackBut.paddingRight = 10*panelScale;
				attackBut.paddingBottom = attackBut.paddingTop = 5*panelScale;
				attackBut.label =  "×"+String(Configrations.Battle_Energy_Cost) +" " + LanguageController.getInstance().getString("attack");
				bottomPart.addChild(attackBut);
				attackBut.validate();
				attackBut.x = expNameText.x;
				attackBut.y = panelheight*0.1;
				
				var clanBossleftTime:int = hero.clanData.userClanData.bossTime - SystemDate.systemTimeS;
				if(clanBossleftTime<0){
					attackBut.addEventListener(Event.TRIGGERED,onTriggerClanAttack);
				}else{
					attackBut.filter = Configrations.grayscaleFilter;
					attackBut.touchable  = false;
					
					var clanBosstimeText:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.03,"("+SystemDate.getTimeMinLeftString(clanleftTime)+")",0x000000,panelheight*0.025);
					clanBosstimeText.autoSize = TextFieldAutoSize.HORIZONTAL;
					bottomPart.addChild(clanBosstimeText);
					clanBosstimeText.x =  attackBut.x + attackBut.width/2 - clanBosstimeText.width/2;
					clanBosstimeText.y = panelheight*0.15;
				}
			}else{
				var pkicon:Image= new Image(Game.assets.getTexture("PKHeroIcon"));
				pkicon.height = panelheight*0.15;
				pkicon.scaleX = pkicon.scaleY;
				bottomPart.addChild(pkicon);
				pkicon.x = skin1.x;
				pkicon.y = skin1.height/2 - pkicon.height/2;
				
				var titext:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,LanguageController.getInstance().getString("callHelpTip"),0x000000,panelheight*0.04);
				titext.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(titext);
				titext.y = 0;
				titext.x = pkicon.x + (panelwidth*0.7 - pkicon.x + pkicon.width)/2 - titext.width/2;	
				
				var vipData:VipData =  Configrations.VIPlist[hero.vipLevel];
				var totalC:int = vipData.pkAddCount;
				var dayC:int = hero.dayCountData.pkAddCount;
				
				var countT:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,String(dayC),(dayC>=totalC)?0xff00ff:0x8EE770,panelheight*0.04);
				countT.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(countT);
				countT.y = panelheight*0.05;
				countT.x = pkicon.x+ (panelwidth*0.7 - pkicon.x + pkicon.width)/2 - countT.width - 5*panelScale;	
				
				var countT1:TextField = FieldController.createSingleLineDynamicField(panelwidth,panelheight*0.05,"/"+String(totalC),0xF7BF2A,panelheight*0.04);
				countT1.autoSize = TextFieldAutoSize.HORIZONTAL;
				bottomPart.addChild(countT1);
				countT1.y = countT.y ;
				countT1.x = pkicon.x+ (panelwidth*0.7 - pkicon.x + pkicon.width)/2 ;	
				
				var pkBut:Button = new Button();
				pkBut.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
				pkBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
				pkBut.paddingLeft = pkBut.paddingRight = 10*panelScale;
				pkBut.paddingBottom = pkBut.paddingTop = 5*panelScale;
				
				if(dayC >= totalC){
					pkBut.label = LanguageController.getInstance().getString("get") + LanguageController.getInstance().getString("more");
					pkBut.addEventListener(Event.TRIGGERED,onTriggedCheck);
				}else{
					var iconM1:Image = new Image(Game.assets.getTexture("EnergyIcon"));
					iconM1.width = iconM1.height = panelheight*0.04;
					pkBut.defaultIcon = iconM1;
					pkBut.label = "×"+String(Configrations.Battle_Energy_Cost) +" " +LanguageController.getInstance().getString("attack");
					pkBut.addEventListener(Event.TRIGGERED,onTriggedAttack);
				}
				
				bottomPart.addChild(pkBut);
				pkBut.validate();
				pkBut.x = pkicon.x + (panelwidth*0.7 - pkicon.x + pkicon.width)/2 - pkBut.width/2;
				pkBut.y = panelheight*0.1;
				
			}
			
			
			
			bottomPart.x = panelwidth*0.15;
			bottomPart.y = panelheight*0.7;
		}
			
		
		private function get listData():ListCollection
		{
			 if(currentTabIndex == 0){
				 heroTopContainer.visible = true;
				 clanTopContainer.visible = false;
				return new ListCollection(Configrations.TopHeroRatingList.topArr);
			}else{
				clanTopContainer.visible = true;
				heroTopContainer.visible = false;
				return new ListCollection(Configrations.TopClanRatingList.topArr);
			}
		}
		
		private function onTriggerJoinClan(e:Event):void
		{
			DialogController.instance.showPanel(new ShowClansPanel(),true);
		}
		private var isCommanding:Boolean;
		private function onTriggerClanReward(e:Event):void
		{
			if(!isCommanding){
				new GetRateClanReward(hero.clanData.clanRank,onGetClanRewards);
				isCommanding = true;
			}
		}
		private function onGetClanRewards():void
		{
			isCommanding = false;
			configBottomPart();
		}
		private function onTriggerReward(e:Event):void
		{
			if(!isCommanding){
				new GetRateHeroReward(hero.heroRank,onGetHeroRewards);
				isCommanding = true;
			}
		}
		private function onGetHeroRewards():void
		{
			isCommanding = false;
			configBottomPart();
		}
		private function onTriggedCheck(e:Event):void
		{
			DialogController.instance.showPanel(new VipPanel());
		}
		
		private function onTriggerClanAttack(e:Event):void
		{
			if(!isCommanding){
				if(hero.curPower < Configrations.Battle_Energy_Cost){
					var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("warningEnergyTip"),true);
					DialogController.instance.showPanel(panel);
					panel.addEventListener(PanelConfirmEvent.CLOSE,onConfirmed);
				}else if(!isCommanding){
					new BeginBossAttack(hero.clanData.data_id,onBeginBoss);
					isCommanding = true;
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
			isCommanding = false;
			var bossSpec:SoldierItemSpec = SpecController.instance.getItemSpec(hero.BossId) as SoldierItemSpec;
			if(bossSpec){
				var data:ClanBossData = hero.clanBossDate;
				GameController.instance.showBattle(new BattleScene(GameController.instance.currentHero,new BossPlayer(bossSpec,data.level,data.kills)));
			}
			removeFromParent(true);
		}
		private function onTriggedAttack(e:Event):void
		{
			DialogController.instance.showPanel(new FindingEnemyPanel());
		}
		
		private var currentTabIndex:int;
		private function tabBar_changeHandler(event:Event):void
		{
			if(tabBar.selectedIndex != currentTabIndex){
				currentTabIndex = tabBar.selectedIndex;
				configList();
				configBottomPart();
				LocalData.validateClans();
				LocalData.validatePlayers()
			}
		}
		
		public function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
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

