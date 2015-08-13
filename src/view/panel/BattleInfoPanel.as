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
	
	import model.clan.ClanMemberData;
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.ItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	import model.player.MonsterPlayer;
	import model.staticData.VipData;
	
	import service.command.battle.BeginSpecBattle;
	import service.command.battle.QuickPassBattle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.BattleEnemyRender;
	import view.render.BattleSoldierRender;
	import view.render.ClanMemberRender;
	import view.screen.BattleScene;

	public class BattleInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var battleSpec:BattleItemSpec;
		private var battleType:String;
		public function BattleInfoPanel(spec:BattleItemSpec,type:String)
		{
			battleSpec = spec;
			battleType = type;
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			scale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.2;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth*0.8;
			backSkin.height = panelheight*0.8;
			backSkin.x = panelwidth*0.1;
			backSkin.y = panelheight*0.1;
			
			var titleSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20)));
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.8;
			titleSkin.height = panelheight*0.08;
			titleSkin.x = panelwidth*0.1;
			titleSkin.y = panelheight*0.1;
			
			var titleText:TextField = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,battleSpec.cname+"("+LanguageController.getInstance().getString(battleType)+")",0x000000,35,true);
			addChild(titleText);
			titleText.y =  panelheight*0.1;
			
			configHeroContainer();
			configEnemyContainer();
			
			
			
			var attackBut:Button = new Button();
			attackBut.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
			attackBut.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			attackBut.label = "×"+String(Configrations.Battle_Energy_Cost) +" " + LanguageController.getInstance().getString("attack");
			var iconM:Image = new Image(Game.assets.getTexture("EnergyIcon"));
			iconM.width = iconM.height = panelheight*0.05;
			attackBut.defaultIcon = iconM;
			attackBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.05, 0x000000);
			attackBut.paddingLeft =attackBut.paddingRight =  20;
			attackBut.paddingTop =attackBut.paddingBottom =  10;
			addChild(attackBut);
			attackBut.validate();
			attackBut.x = panelwidth/2- attackBut.width/2;
			attackBut.y = panelheight*0.9 - attackBut.height - 10*scale;
			attackBut.addEventListener(Event.TRIGGERED,onAttackTriggered);
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			configQucikPassPart();
			
		}
		
		private var quickPart:Sprite;
		private function configQucikPassPart():void
		{
			if(quickPart){
				quickPart.removeFromParent(true);
			}
			var newId:String = (battleType == Configrations.Ordinary_type)?battleSpec.item_id:battleSpec.getSupId();
			var battleData:OwnedItem = hero.getBattleItem(newId);
			if(battleData.count >= 3){
				quickPart = new Sprite;
				addChild(quickPart);
				
				
				var qucikItem:OwnedItem = hero.getItem("80003");
				var but:Button = new Button();
				but.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
				but.label = LanguageController.getInstance().getString("quickPass");
				var iconIg :Image = new Image (qucikItem.itemSpec.iconTexture);
				iconIg.height =  panelheight*0.05;
				iconIg.scaleX = iconIg.scaleY;
				but.defaultIcon = iconIg;
				but.paddingLeft =but.paddingRight =  10;
				but.paddingTop =but.paddingBottom =  10;
				but.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.04, 0x000000);
				quickPart.addChild(but);
				but.validate();
				
				but.addEventListener(Event.TRIGGERED,onQucikAttackTriggered);
				quickPart.x = panelwidth *0.9 - but.width;
				quickPart.y = panelheight*0.9 - but.height - 10*scale;
			}
		}
		private var heroContainer:Sprite;
		private function configHeroContainer():void
		{
			if(heroContainer){
				heroContainer.removeFromParent(true);
			}
			heroContainer = new Sprite;
			addChild(heroContainer);
			heroContainer.x = panelwidth*0.15;
			heroContainer.y = panelheight*0.21;
			
			//
			var heroSkin:Image = new Image(Game.assets.getTexture("SelectRenderSkin"));
			heroSkin.width = panelwidth*0.15;
			heroSkin.height = panelheight*0.25;
			heroContainer.addChild(heroSkin);
			
			var headIcon:Image = new Image(Game.assets.getTexture(hero.characterSpec.name+"Icon"));
			var s:Number =  Math.min(heroSkin.width*0.8/headIcon.width,heroSkin.height*0.8/headIcon.height);
			headIcon.scaleY = headIcon.scaleX = s;
			heroContainer.addChild(headIcon);
			headIcon.x = heroSkin.x + heroSkin.width/2 - headIcon.width/2;
			headIcon.y = heroSkin.y + heroSkin.height/2-headIcon.height/2;
			
			const listLayout: HorizontalLayout= new HorizontalLayout();
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			
			var skillList:List = new List();
			skillList.layout = listLayout;
			skillList.dataProvider = getskillListData();
			skillList.itemRendererFactory =function tileListItemRendererFactory():BattleSoldierRender
			{
				var renderer:BattleSoldierRender = new BattleSoldierRender();
				renderer.defaultSkin = new Scale9Image(Configrations.BlueRenderSkinTexture);
				renderer.width = renderer.height = panelheight *0.1;
				return renderer;
			}
			skillList.width =  panelwidth*0.38;
			skillList.height =  panelheight *0.12;
			heroContainer.addChild(skillList);
			skillList.x = panelwidth*0.16;
			skillList.y = heroSkin.y;
			
			
			const listLayout1: HorizontalLayout= new HorizontalLayout();
			listLayout1.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout1.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			
			var soldierList:List = new List();
			soldierList.layout = listLayout1;
			soldierList.dataProvider = getsoldierListData();
			soldierList.itemRendererFactory =function tileListItemRendererFactory():BattleSoldierRender
			{
				var renderer:BattleSoldierRender = new BattleSoldierRender();
				renderer.defaultSkin = new Scale9Image(Configrations.BlueRenderSkinTexture);
				renderer.width = renderer.height = panelheight *0.12;
				return renderer;
			}
			soldierList.width =  panelwidth*0.38;
			soldierList.height =  panelheight *0.14;
			heroContainer.addChild(soldierList);
			soldierList.x = panelwidth*0.16;
			soldierList.y = heroSkin.y+panelheight *0.12;
			
			configHelpPart();
		}
		
		private var helpContainer:Sprite;
		private function configHelpPart():void
		{
			if(helpContainer){
				helpContainer.removeFromParent(true);
				helpContainer = null;
			}
			helpContainer = new Sprite;
			heroContainer.addChild(helpContainer);
			helpContainer.x = panelwidth*0.55;
			
			
			var heroSkin1:Image = new Image(Game.assets.getTexture("SelectRenderSkin"));
			heroSkin1.width = panelwidth*0.15;
			heroSkin1.height = panelheight*0.25;
			helpContainer.addChild(heroSkin1);
			
			if(curClanMem){
				var icon:Image  = new Image(Game.assets.getTexture(curClanMem.heroData.characterSpec.name+"HeadIcon"));
				icon.width = icon.height = Math.min(heroSkin1.width*0.8,heroSkin1.height*0.8);
				helpContainer.addChild(icon);
				icon.x = helpContainer.width/2 - icon.width/2;
				icon.y = helpContainer.height/2 - icon.height/2;
				
				var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
				expIcon.width = expIcon.height = 50*scale;
				helpContainer.addChild(expIcon);
				expIcon.x = icon.x + icon.width - expIcon.width;
				expIcon.y = icon.y + icon.height - expIcon.height;
				
				var expText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,expIcon.height,String(curClanMem.heroData.level),0x000000,25,true);
				helpContainer.addChild(expText);
				expText.x = expIcon.x;
				expText.y = expIcon.y;
				
				var nameText:TextField = FieldController.createNoFontField(heroSkin1.width,heroSkin1.height*0.2,curClanMem.heroData.name,0x000000,heroSkin1.height*0.1);
				helpContainer.addChild(nameText);
				nameText.y =  5*scale ;
				
			}else{
				var headIcon1:Image = new Image(Game.assets.getTexture("NewHeroIcon"));
				var s1:Number =  Math.min(heroSkin1.width*0.8/headIcon1.width,heroSkin1.height*0.8/headIcon1.height);
				headIcon1.scaleY = headIcon1.scaleX = s1;
				helpContainer.addChild(headIcon1);
				headIcon1.x = heroSkin1.x + heroSkin1.width/2 - headIcon1.width/2;
				headIcon1.y = heroSkin1.y + heroSkin1.height/2-headIcon1.height/2;
				
				var titext:TextField = FieldController.createSingleLineDynamicField(200,heroSkin1.height,LanguageController.getInstance().getString("callHelpTip"),0x000000,25);
				titext.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				helpContainer.addChild(titext);
				titext.y = heroSkin1.y +heroSkin1.height*0.02;
				titext.x = heroSkin1.x + heroSkin1.width/2 - titext.width/2;	
				
				
				var vipData:VipData =  Configrations.VIPlist[hero.vipLevel];
				var totalC:int = vipData.totalinviteFriendCount;
				var dayC:int = hero.dayCountData.inviteFriendCount;
				
				var countT:TextField = FieldController.createSingleLineDynamicField(heroSkin1.width,heroSkin1.height,String(dayC),(dayC>=totalC)?0xff00ff:0x8EE770,35);
				countT.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				helpContainer.addChild(countT);
				countT.y = titext.y +titext.height;
				countT.x = heroSkin1.x+heroSkin1.width/2 - countT.width - 5*scale;	
				
				var countT1:TextField = FieldController.createSingleLineDynamicField(heroSkin1.width,heroSkin1.height,"/"+String(totalC),0xF7BF2A,35);
				countT1.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				helpContainer.addChild(countT1);
				countT1.y = countT.y ;
				countT1.x = heroSkin1.x+heroSkin1.width/2 ;	
				
				var pItem:OwnedItem = hero.getItem("80002");
				var itemIcon:Image = new Image(pItem.itemSpec.iconTexture);
				itemIcon.width = itemIcon.height = heroSkin1.width*0.6;
				helpContainer.addChild(itemIcon);
				itemIcon.x = heroSkin1.x + heroSkin1.width*0.5 - itemIcon.width/2;
				itemIcon.y = countT.y +countT.height;
				
				var countT2:TextField = FieldController.createSingleLineDynamicField(heroSkin1.width,heroSkin1.height,"×"+String(pItem.count),0x000000,30);
				countT2.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				helpContainer.addChild(countT2);
				countT2.y = itemIcon.y +itemIcon.height - countT2.height ;
				countT2.x = itemIcon.x+ itemIcon.width - countT2.width/2 ;	
				
				var inviteBut:Button = new Button();
				inviteBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
				inviteBut.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
				
				if(pItem.count <= 0 ){
					inviteBut.label = LanguageController.getInstance().getString("buy");
					inviteBut.addEventListener(Event.TRIGGERED,onTriggedBuy);
				}else{
					if(dayC >= totalC){
						inviteBut.label = "VIP";
						inviteBut.addEventListener(Event.TRIGGERED,onTriggedCheck);
					}else{
						inviteBut.label = LanguageController.getInstance().getString("use");
						inviteBut.addEventListener(Event.TRIGGERED,onTriggedUse);
					}
				}
				
				inviteBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				inviteBut.paddingLeft =inviteBut.paddingRight =  20;
				inviteBut.paddingTop =inviteBut.paddingBottom =  5;
				helpContainer.addChild(inviteBut);
				inviteBut.validate();
				inviteBut.x = heroSkin1.x + heroSkin1.width/2 - inviteBut.width/2;
				inviteBut.y = itemIcon.y +itemIcon.height + 5*scale;
			}
		}
		private var enemyContainer:Sprite;
		private function configEnemyContainer():void
		{
			if(enemyContainer){
				enemyContainer.removeFromParent(true);
			}
			enemyContainer = new Sprite;
			addChild(enemyContainer);
			enemyContainer.x = panelwidth*0.15;
			enemyContainer.y = panelheight*0.52;
			
			
			var listSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackPanelSkin"),new Rectangle(14,15,110,55)));
			enemyContainer.addChild(listSkin);
			listSkin.alpha = 0.8;
			listSkin.width = panelwidth*0.7;
			listSkin.height = panelheight*0.28;
			
			var baseText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.3,panelheight*0.06,LanguageController.getInstance().getString("simple"),0xffffff,35);
			enemyContainer.addChild(baseText);
			
			var baseTextInfo:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.3,panelheight*0.06,LanguageController.getInstance().getString("simpleinfo"),0x000000,25);
			enemyContainer.addChild(baseTextInfo);
			baseTextInfo.y = panelheight*0.06;
			const listLayout1: HorizontalLayout= new HorizontalLayout();
			listLayout1.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout1.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout1.gap = panelwidth *0.02;
			
			var enemyList:List = new List();
			enemyList.layout = listLayout1;
			enemyList.dataProvider = getBaseEnemyListData();
			enemyList.itemRendererFactory =function tileListItemRendererFactory():BattleEnemyRender
			{
				var renderer:BattleEnemyRender = new BattleEnemyRender();
				renderer.width = renderer.height = Math.min(panelwidth *0.1,panelheight *0.1);
				return renderer;
			}
			enemyList.width =  panelwidth*0.4;
			enemyList.height =  panelheight *0.12;
			enemyContainer.addChild(enemyList);
			enemyList.x = panelwidth*0.3;
			
			
			var lineIg:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("WhiteSkin"),new Rectangle(5,5,40,40)));
			enemyContainer.addChild(lineIg);
			lineIg.alpha = 0.9;
			lineIg.width = panelwidth*0.6;
			lineIg.height = 1;
			lineIg.x = panelwidth*0.05;
			lineIg.y = panelheight*0.126;
			
			var supText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.3,panelheight*0.07,LanguageController.getInstance().getString("senior"),0xffffff,35);
			enemyContainer.addChild(supText);
			supText.y = panelheight *0.14;
			var supTextInfo:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.3,panelheight*0.07,LanguageController.getInstance().getString("seniorinfo"),0x000000,25);
			enemyContainer.addChild(supTextInfo);
			supTextInfo.y = panelheight *0.21;
			
			const listLayout: HorizontalLayout= new HorizontalLayout();
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			listLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout.gap = panelwidth *0.02;
			
			var supenemyList:List = new List();
			supenemyList.layout = listLayout;
			supenemyList.dataProvider = getEnemyListData();
			supenemyList.itemRendererFactory =function tileListItemRendererFactory():BattleEnemyRender
			{
				var renderer:BattleEnemyRender = new BattleEnemyRender();
				renderer.width = renderer.height = Math.min(panelwidth *0.12,panelheight *0.12);
				return renderer;
			}
			supenemyList.width =  panelwidth*0.4;
			supenemyList.height =  panelheight *0.12;
			enemyContainer.addChild(supenemyList);
			supenemyList.x = panelwidth*0.3;
			supenemyList.y = panelheight *0.14;
		}
		
		private var memberList:List;
		
		private function showSelectList():void
		{
			if(hero.clanData){
				if(!memberList){
					const listLayout:HorizontalLayout = new HorizontalLayout();
					listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
					listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
					
					memberList = new List();
					
					var listSkin:Scale9Image =  new Scale9Image(new Scale9Textures( Game.assets.getTexture("WhiteSkin"),new Rectangle(2,2,60,60)));
					listSkin.alpha = 0.8;
					memberList.backgroundSkin =listSkin;
					
					memberList.layout = listLayout;
					memberList.dataProvider = new ListCollection(hero.clanData.getMemberArrExceptUser(hero.characteruid));
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
					memberList.x = panelwidth*0.15;
					memberList.y = panelheight*0.5;
					memberList.addEventListener(Event.CHANGE,onMemberListChange);
				}
				memberList.selectedIndex = -1;
				addChild(memberList);
			}else{
				var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("noClanTip"),true);
				panel.addEventListener(PanelConfirmEvent.CLOSE,onConfirmHandler);
				DialogController.instance.showPanel(panel);
			}
		}
		
		private function onTriggedBuy(e:Event):void
		{
			DialogController.instance.showPanel(new ItemPanel(ItemPanel.INVITE),true);
		}
		private function onTriggedCheck(e:Event):void
		{
			DialogController.instance.showPanel(new VipPanel());
		}
		private function onTriggedUse(e:Event):void
		{
			showSelectList();
		}
		
		private var curClanMem:ClanMemberData;
		private function onMemberListChange(e:Event):void
		{
			if(memberList.selectedItem){
				curClanMem = memberList.selectedItem as ClanMemberData;
				configHelpPart();
				memberList.removeFromParent();
			}
		}
		private function onConfirmHandler(e:PanelConfirmEvent):void
		{
			if(e.BeConfirm){
				DialogController.instance.showPanel(new ShowClansPanel(),true);
			}
		}
		private var iscommanding:Boolean;
		private function onAttackTriggered(e:Event):void
		{
			if(hero.curPower < Configrations.Battle_Energy_Cost){
				var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("warningEnergyTip"),true);
				DialogController.instance.showPanel(panel);
				panel.addEventListener(PanelConfirmEvent.CLOSE,onConfirmed);
			}else if(!iscommanding){
				new BeginSpecBattle(battleSpec.item_id,battleType,curClanMem?true:false,onCommanded);
				iscommanding = true;
			}
		}
		
		private function onConfirmed(e:PanelConfirmEvent):void
		{
			if(e.BeConfirm){
				DialogController.instance.showPanel(new ItemPanel(ItemPanel.ENERGY),true);
			}
		}
		private function onCommanded():void
		{
			iscommanding = false;
			if(curClanMem){
				hero.addItem("80002",-1);
			}
			GameController.instance.showBattle(new BattleScene(GameController.instance.currentHero,new MonsterPlayer(battleSpec,battleType)));
			removeFromParent(true);
		}
		private function onTriggerBack(e:Event):void
		{
			this.removeFromParent(true);
		}
		
		private function onQucikAttackTriggered(e:Event):void
		{
			var qucikItem:OwnedItem = hero.getItem("80003");
			if(qucikItem.count <=0 ){
				DialogController.instance.showPanel(new ItemPanel(ItemPanel.QUICKPASS));
			}else if(!iscommanding){
				rewards = Configrations.getRewards(3,false,new MonsterPlayer(battleSpec,battleType));
				new QuickPassBattle(battleSpec.item_id,battleType,rewards,onQuickCommanded);
			}
		}
		private var rewards:Array = [];
		private function onQuickCommanded():void
		{
			DialogController.instance.showPanel(new BattleResultPanel(3,rewards));
			for each(var ownedItem:OwnedItem in rewards){
				if(ownedItem.item_id == "coin"){
					GameController.instance.localPlayer.changeCoin(ownedItem.count);
				}else if(ownedItem.item_id == "exp"){
					hero.addExp( ownedItem.count);
				}else{
					hero.addItem(ownedItem.item_id,ownedItem.count);
				}
			}
		}
		private function getBaseEnemyListData():ListCollection
		{
			var enemyArr:Array = battleSpec.getBaseEnemyItems();
			return new ListCollection(enemyArr);
		}
		private function getEnemyListData():ListCollection
		{
			var enemyArr:Array = battleSpec.getSupEnemyItems();
			return new ListCollection(enemyArr);
		}
		private function getsoldierListData():ListCollection
		{
			var arr:Array = [];
			var spec:ItemSpec;
			for each(var id:String in hero.soldierList){
				spec = SpecController.instance.getItemSpec(id);
				arr.push(spec);
			}
			return new ListCollection(arr);
		}
		
		private function getskillListData():ListCollection
		{
			var arr:Array = [];
			var spec:ItemSpec;
			for each(var id:String in hero.skillList){
				spec = SpecController.instance.getItemSpec(id);
				arr.push(spec);
			}
			return new ListCollection(arr);
		}
		
		private function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
	}
}