package view.panel
{
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
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
	import gameconfig.LocalData;
	
	import model.player.GamePlayer;
	import model.staticData.RatingData;
	
	import service.command.battle.BeginBossAttack;
	import service.command.battle.BeginPkCommand;
	import service.command.battle.FindEnemyCommand;
	import service.command.hero.GetHerosInfoCommand;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.screen.BattleScene;

	public class FindingEnemyPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var loadingMC:MovieClip;
		private var searchBut:Button;
		private var attackBut:Button;
		public function FindingEnemyPanel()
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
			backSkin.width = panelwidth*0.5;
			backSkin.height = panelheight*0.5;
			backSkin.x = panelwidth*0.25;
			backSkin.y = panelheight*0.25;
			
			var titleSkin:Scale9Image = new Scale9Image(Configrations.PanelTitleSkinTexture);
			addChild(titleSkin);
			titleSkin.width = backSkin.width;
			titleSkin.height = panelheight*0.08;
			titleSkin.x = backSkin.x;
			titleSkin.y = panelheight*0.25;
			
			titleText = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height,LanguageController.getInstance().getString("search")+" "+LanguageController.getInstance().getString("enemy"),0xffffff,titleSkin.height*0.8,true);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			loadingMC = new MovieClip(Game.assets.getTextures("effect_loading"));
			loadingMC.height = panelheight *0.05;
			loadingMC.scaleX = loadingMC.scaleY;
			loadingMC.x = panelwidth *0.5 - loadingMC.width/2;
			loadingMC.y = panelheight *0.5 - loadingMC.height/2;
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.25 - panelheight*0.05;
			backBut.y = panelheight*0.25;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			searchBut = new Button();
			searchBut.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
			searchBut.label = LanguageController.getInstance().getString("search");
			searchBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.03, 0x000000);
			searchBut.paddingLeft = searchBut.paddingRight = 20*panelScale;
			searchBut.paddingBottom = searchBut.paddingTop = 10*panelScale;
			searchBut.addEventListener(Event.TRIGGERED,onTriggerSearch);
			
			attackBut = new Button();
			attackBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			var iconM:Image = new Image(Game.assets.getTexture("EnergyIcon"));
			iconM.width = iconM.height = panelheight*0.03;
			attackBut.defaultIcon = iconM;
			attackBut.label = "×"+String(Configrations.Battle_Energy_Cost) +" " + LanguageController.getInstance().getString("attack");
			attackBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.03, 0x000000);
			attackBut.paddingLeft = attackBut.paddingRight = 20*panelScale;
			attackBut.paddingBottom = attackBut.paddingTop = 10*panelScale;
			attackBut.addEventListener(Event.TRIGGERED,onTriggerAttack);
			
			laterCall();
		}
		
		private function config():void
		{
			callTime += 10;
			loadingMC.removeFromParent();
			Starling.juggler.remove(loadingMC);
			
			if(ratingData){
				addChild(searchBut);
				searchBut.validate();
				searchBut.x = panelwidth*0.375 - searchBut.width/2;
				searchBut.y = panelheight*0.6;
					
				addChild(attackBut);
				attackBut.validate();
				attackBut.x = panelwidth*0.625 - attackBut.width/2;
				attackBut.y = panelheight*0.6;
					
				configHeroPart();
			}else{
				addChild(searchBut);
				searchBut.validate();
				searchBut.x = panelwidth*0.5 - searchBut.width/2;
				searchBut.y = panelheight*0.6;
			}
		}
		
		private var heroPart:Sprite;
		private function configHeroPart():void
		{
			if(heroPart){
				heroPart.removeFromParent(true);
				heroPart = null;
			}
			if(ratingData && ratingData.owner is GamePlayer){
				var hero:GamePlayer = ratingData.owner as GamePlayer;
				heroPart = new Sprite;
				addChild(heroPart);
				
				var skin:Scale9Image  = new Scale9Image(new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(20,20,20,20)));
				skin.width = panelwidth*0.3;
				skin.height= panelheight*0.2;
				heroPart.addChild(skin);
				
				var icon:Image  = new Image(Game.assets.getTexture(hero.characterSpec.name+"HeadIcon"));
				icon.height = panelheight*0.16;
				icon.scaleX = icon.scaleY;
				heroPart.addChild(icon);
				icon.x = panelwidth*0.02;
				icon.y = panelheight*0.02;
				
				var nameText:TextField = FieldController.createNoFontField(200, panelheight*0.05,hero.name,0x000000,panelheight*0.04);
				nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				heroPart.addChild(nameText);
				nameText.y = icon.y;
				nameText.x = icon.x + icon.width;
				
				var expNameText:TextField = FieldController.createSingleLineDynamicField(200,panelheight*0.05,LanguageController.getInstance().getString("level")+": ",0x000000,panelheight*0.04,true);
				expNameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				heroPart.addChild(expNameText);
				expNameText.x = nameText.x ;
				expNameText.y = nameText.y + nameText.height;
				
				var expText:TextField = FieldController.createSingleLineDynamicField(200,panelheight*0.05,String(hero.level) ,0xffff00,panelheight*0.04,true);
				expText.autoSize = TextFieldAutoSize.HORIZONTAL;
				heroPart.addChild(expText);
				expText.x = expNameText.x + expNameText.width;
				expText.y = expNameText.y;
				
				var scoreNameText:TextField = FieldController.createSingleLineDynamicField(200,panelheight*0.05,LanguageController.getInstance().getString("score")+": ",0x000000,panelheight*0.04,true);
				scoreNameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				heroPart.addChild(scoreNameText);
				scoreNameText.x = nameText.x ;
				scoreNameText.y = expNameText.y + expNameText.height;
				
				var scoreText:TextField = FieldController.createSingleLineDynamicField(200,panelheight*0.05,String(ratingData.score),0x0ff000,panelheight*0.04,true);
				scoreText.autoSize = TextFieldAutoSize.HORIZONTAL;
				heroPart.addChild(scoreText);
				scoreText.x = scoreNameText.x + scoreNameText.width;
				scoreText.y = scoreNameText.y;
				
				
				heroPart.x = panelwidth*0.35;
				heroPart.y = panelheight*0.35;
			}
		}
		private var isCommanding:Boolean;
		private function onTriggerAttack(e:Event):void
		{
			if(!isCommanding && ratingData){
				
				if(hero.curPower < Configrations.Battle_Energy_Cost){
					var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("warningEnergyTip"),true);
					DialogController.instance.showPanel(panel);
					panel.addEventListener(PanelConfirmEvent.CLOSE,onConfirmed);
				}else if(!isCommanding){
					new BeginPkCommand(ratingData.id,onAttackHandler);
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
		
		private function onAttackHandler():void
		{
			isCommanding = false;
			if(ratingData){
				GameController.instance.showBattle(new BattleScene(GameController.instance.currentHero,ratingData.owner as GamePlayer));
			}
			removeFromParent(true);
		}
		private function onTriggerSearch(e:Event):void
		{
			laterCall();
		}
		private function laterCall():void
		{
			searchBut.removeFromParent();
			attackBut.removeFromParent();
			
			addChild(loadingMC);
			Starling.juggler.add(loadingMC);
			setTimeout(call,callTime);
			
			ratingData = null;
			configHeroPart();
		}
		private var ratingData:RatingData;
		private function call():void
		{
			if(!isCommanding){
				if(Configrations.PKList.length >1){
					var index:int = Math.floor(Math.random()*Configrations.PKList.length);
					var data:Object = Configrations.PKList.splice(index,1)[0];
					if(data){
						ratingData = new RatingData(data);
						new GetHerosInfoCommand([ratingData.id],onGetHero,true);
						isCommanding = true;
					}
				}else{
					
					new FindEnemyCommand(hero.rateData.score,onFind);
				}
			}
		}
			
		private function onGetHero(heros:Array):void
		{
			isCommanding = false;
			LocalData.onGetPlayers(heros);
			config();
		}
		private function onFind():void{
			isCommanding = false;
			if(Configrations.PKList.length >1){
				var index:int = Math.floor(Math.random()*Configrations.PKList.length);
				var data:Object = Configrations.PKList.splice(index,1)[0];
				if(data){
					ratingData = new RatingData(data);
					if(!LocalData.getLocalPlayer(ratingData.id,true)){
						new GetHerosInfoCommand([ratingData.id],onGetHero);
					}else{
						config()
					}
				}
			}else{
				config()
			}
		}
		private var callTime:int = 30;
		
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
			Starling.juggler.remove(loadingMC);
			removeFromParent(false);
			super.dispose();
		}
	}
}