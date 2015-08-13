package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	import controller.VoiceController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.ToggleSwitch;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import service.command.hero.HeroLoginCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.render.HeroChooseRender;
	
	public class UserInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var curHero :GamePlayer;
		public function UserInfoPanel()
		{
			curHero = GameController.instance.currentHero;
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
			
			titleText = FieldController.createNoFontField(panelwidth,titleSkin.height,curHero.name,0xffffff,titleSkin.height*0.8);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			configUserPart();
			configHeroPart();
			configSettingPanel();
			
			var backBut:Button = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.1;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
		}
		
		private var vipContainer:Sprite;
		private function configUserPart():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = panelwidth*0.25;
			container.y = panelheight*0.2;
			var skin:Scale9Image = new Scale9Image(new Scale9Textures( Game.assets.getTexture("PanelRenderSkin"),new Rectangle(12,12,40,40)));
			skin.width = panelwidth*0.4;
			skin.height = panelheight*0.2;
			skin.alpha = 0.8;
			container.addChild(skin);
			skin.x  = panelwidth*0.05;
			
			vipContainer = new Sprite;
			container.addChild(vipContainer);
			
			
			var vipSkin:Image = new Image(Game.assets.getTexture("toolsStateSkin"));
			vipSkin.width = vipSkin.height = panelheight*0.14;
			vipContainer.addChild(vipSkin);
			vipSkin.x = -vipSkin.width/2 - panelwidth*0.05 ;
			vipSkin.y = panelheight*0.1 - vipSkin.height/2;
			
			var vipIcon:Image = new Image(Game.assets.getTexture("vipIcon"));
			vipIcon.width = vipIcon.height = panelheight*0.1;
			vipContainer.addChild(vipIcon);
			vipIcon.x = -vipIcon.width/2 - panelwidth*0.05 ;
			vipIcon.y = panelheight*0.1 - vipIcon.height/2;
			
			
			var vipText1:TextField = FieldController.createSingleLineDynamicField(300 ,panelheight*0.05,"VIP ",0x000000,panelheight*0.04,true);
			vipText1.autoSize = TextFieldAutoSize.HORIZONTAL;
			vipContainer.addChild(vipText1);
			vipText1.x = vipIcon.x + vipIcon.width/2 - vipText1.width/2;
			vipText1.y = vipIcon.y + vipIcon.height - 20*panelScale;
			
			var vipText:TextField = FieldController.createSingleLineDynamicField(300 ,panelheight*0.05,String(hero.vipLevel),0x23E96D,panelheight*0.04,true);
			vipText.autoSize = TextFieldAutoSize.HORIZONTAL;
			vipContainer.addChild(vipText);
			vipText.x = vipIcon.x + vipIcon.width - vipText.width;
			vipText.y = vipIcon.y + vipIcon.height - vipText.height;
			
			vipContainer.addEventListener(TouchEvent.TOUCH,onTouched);
			
			
			var idText:TextField = FieldController.createSingleLineDynamicField(400,panelheight*0.06,LanguageController.getInstance().getString("userId"),0x000000,panelheight*0.05);
			idText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(idText);
			idText.x = panelwidth*0.25 - idText.width - 10*panelScale;
			
			var idText1:TextField = FieldController.createSingleLineDynamicField(400,panelheight*0.06,player.gameuid,0x23E9ff,panelheight*0.05);
			idText1.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(idText1);
			idText1.x = panelwidth*0.25 ;
			
			
			
			var coinIcon:Image = new Image(Game.assets.getTexture("CoinIcon"));
			coinIcon.width = coinIcon.height = panelheight*0.05;
			container.addChild(coinIcon);
			coinIcon.y = panelheight*0.07;
			
			var coinText:TextField = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,String(player.coin),0x23E96D,panelheight*0.04,true);
			coinText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(coinText);
			coinText.x = panelwidth*0.25;
			coinText.y = coinIcon.y;
			
			var coinText1:TextField = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,LanguageController.getInstance().getString("coin"),0x000000,panelheight*0.04,true);
			coinText1.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(coinText1);
			coinText1.x = panelwidth*0.25 - coinText1.width - 10*panelScale;
			coinText1.y = coinIcon.y;
			
			coinIcon.x = coinText1.x - coinIcon.width;
			
			var gemIcon:Image = new Image(Game.assets.getTexture("GemIcon"));
			gemIcon.width = gemIcon.height = panelheight*0.05;
			container.addChild(gemIcon);
			gemIcon.y = panelheight*0.13;
			
			var gemText:TextField = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,String(player.gem),0x23E96D,panelheight*0.04,true);
			gemText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(gemText);
			gemText.x = panelwidth*0.25;
			gemText.y = gemIcon.y;
			
			var gemText1:TextField = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,LanguageController.getInstance().getString("gem"),0x000000,panelheight*0.04,true);
			gemText1.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(gemText1);
			gemText1.x = panelwidth*0.25 - gemText1.width - 10*panelScale;
			gemText1.y = gemIcon.y;
			
			gemIcon.x = gemText1.x - gemIcon.width;
			
		}
		private var list:List;
		private function configHeroPart():void
		{
			
			var container:Sprite = new Sprite;
			addChild(container);
			container.x = panelwidth*0.15;
			container.y = panelheight*0.43;
			
			const listLayout: HorizontalLayout= new HorizontalLayout();
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.gap = panelwidth*0.02;
			
			list = new List();
			list.layout = listLayout;
			list.dataProvider = getListCoarr();
			list.itemRendererFactory =function tileListItemRendererFactory():HeroChooseRender
			{
				var renderer:HeroChooseRender = new HeroChooseRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
				renderer.width = panelwidth *0.15;
				renderer.height = panelheight *0.25;
				return renderer;
			}
			list.width =  panelwidth*0.7;
			list.height =  panelheight *0.26;
			container.addChild(list);
			list.addEventListener(Event.CHANGE,onListChangeHandle);
			
		}
		private var musictoggle:ToggleSwitch;
		private var soundToggle:ToggleSwitch;
		private function configSettingPanel():void
		{
			var contaner:Sprite = new Sprite;
			addChild(contaner);
			contaner.x = panelwidth*0.15;
			contaner.y = panelheight*0.75;
			
			var musicText:TextField = FieldController.createSingleLineDynamicField(panelwidth/2,panelheight*0.05,LanguageController.getInstance().getString("music")+":",0x000000,panelheight*0.04,true);
			musicText.autoSize = TextFieldAutoSize.HORIZONTAL;
			contaner.addChild(musicText);
			musicText.x =  panelwidth*0.35 - musicText.width - 10*panelScale;
			musicText.y =  0;
			musictoggle = creatToggle();
			if(!VoiceController.MUSIC_DISABLE){
				musictoggle.isSelected = false;
			}
			contaner.addChild(musictoggle);
			musictoggle.x =  panelwidth*0.35;
			musictoggle.y =  musicText.y;
			musictoggle.addEventListener(Event.CHANGE,onMusicChange);
			
			
			var musicText1:TextField = FieldController.createSingleLineDynamicField(panelwidth/2,panelheight*0.05,LanguageController.getInstance().getString("sound")+":",0x000000,panelheight*0.04,true);
			musicText1.autoSize = TextFieldAutoSize.HORIZONTAL;
			contaner.addChild(musicText1);
			musicText1.x =  panelwidth*0.35 - musicText1.width - 10*panelScale;
			musicText1.y =  panelheight*0.08;
			soundToggle = creatToggle();
			if(!VoiceController.SOUND_DISABLE){
				soundToggle.isSelected = false;
			}
			contaner.addChild(soundToggle);
			soundToggle.x =  panelwidth*0.35;
			soundToggle.y =  panelheight*0.08;
			soundToggle.addEventListener(Event.CHANGE,onSoundChange);
		}
		private function creatToggle():ToggleSwitch
		{
			var toggle:ToggleSwitch = new ToggleSwitch();
			toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF;
			toggle.isSelected = true;
			toggle.defaultLabelProperties.textFormat =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
			toggle.width = panelwidth*0.15;
			toggle.height =  panelheight*0.05;
			var onImage1:Image = new Image(Game.assets.getTexture("blueButtonSkin"));
			var onImage2:Image = new Image(Game.assets.getTexture("greenButtonSkin"));
			toggle.onTrackProperties.defaultSkin =onImage1;
			toggle.offTrackProperties.defaultSkin = onImage2;
			return toggle;
		}
		
		private function onTouched(e:TouchEvent):void
		{
			var evts:Vector.<Touch> = e.getTouches(vipContainer,TouchPhase.BEGAN);
			if(evts.length>=1 ){
				DialogController.instance.showPanel(new VipPanel());
			}
			
		}
		private function getListCoarr():ListCollection
		{
			
			var arr:Array = player.user_characters.concat();
			if(Configrations.HeroCost.length >arr.length){
				arr.push("creat");
			}
			return new ListCollection(arr);
		}
		private function onMusicChange( event:Event ):void
		{
			var toggle:ToggleSwitch = ToggleSwitch( event.currentTarget );
			VoiceController.instance.setMusic(toggle.isSelected);
		}
		
		private function onSoundChange( event:Event ):void
		{
			var toggle:ToggleSwitch = ToggleSwitch( event.currentTarget );
			VoiceController.instance.setSound(toggle.isSelected);
		}
		
		private var isLogining:Boolean;
		
		private function onListChangeHandle(e:Event):void
		{
			if(!isLogining){
				if(list.selectedItem is GamePlayer){
					if((list.selectedItem as  GamePlayer).characteruid != GameController.instance.currentHero.characteruid){
						var panel:MessagePanel = new MessagePanel(LanguageController.getInstance().getString("WarningrechooseHero") ,true)
						DialogController.instance.showPanel(panel);
						panel.addEventListener(PanelConfirmEvent.CLOSE,onConfirmHandler);
					}
					
				}else if(list.selectedItem == "creat"){
					showCreatPanel();
					list.selectedIndex = -1;
				}
			}
		}
		
		private function onConfirmHandler(e:PanelConfirmEvent):void
		{
			if(e.BeConfirm){
				new HeroLoginCommand((list.selectedItem as GamePlayer),onLogin);
				isLogining = true;
			}else{
				list.selectedIndex = -1;
			}
		}
		private function onLogin():void
		{
			isLogining = false;
			this.removeFromParent(true);
		}
		
		private function showCreatPanel():void
		{
			creatPanel =new CharacterCreatPanel();
			DialogController.instance.showPanel(creatPanel);
			creatPanel.addEventListener(Event.CLOSE,onCreatClose);
		}
		private var creatPanel:CharacterCreatPanel;
		
		private function onCreatClose(e:Event):void
		{
			refresh();
			creatPanel.removeEventListener(Event.CLOSE,onCreatClose);
			creatPanel = null;
		}
		
		public function refresh():void
		{
			list.dataProvider = getListCoarr();
			list.validate();
		}
		
		private function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		private function onTriggerBack(e:Event):void
		{
			dispose();
		}
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
	}
}

