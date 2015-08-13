package view.compenent
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.panel.UserInfoPanel;

	public class HeadCompenet extends Sprite
	{
		private var hero:GamePlayer;
		private var coinText:TextField;
		private var gemText:TextField;
		private var gemIcon:Image;
		private var powerText:TextField;
		private var totalpowerText:TextField;
		private var powerTimeText:TextField;
		private var vl:Image;
		private var skin:Image;
		public function HeadCompenet(_hero:GamePlayer)
		{
			hero = _hero;
			config();
			addEventListener(TouchEvent.TOUCH,onTouched);
		}
		private function config():void
		{
			skin = new Image(Game.assets.getTexture("HeadSkin"));
			addChild(skin);
			
			var headIcon:Image = new Image(Game.assets.getTexture(hero.characterSpec.name+"HeadIcon"));
			addChild(headIcon);
			headIcon.width = headIcon.height = Configrations.ViewPortHeight * 0.15;
			
			skin.height =  Configrations.ViewPortHeight * 0.15;
			skin.scaleX = skin.scaleY;
			skin.x = headIcon.height*0.1;
			skin.y = headIcon.height*0.1;
			
			
			var levelText:TextField = FieldController.createSingleLineDynamicField(headIcon.width ,headIcon.height,String(hero.level),0xffffff,20,true);
			levelText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(levelText);
			levelText.x = skin.x + skin.width*0.28 - levelText.width/2;
			levelText.y = skin.y + skin.height*0.08;
			
			
			var nameText:TextField = FieldController.createNoFontField(skin.width,skin.height,hero.name,0xffffff,skin.height*0.2);
			nameText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(nameText);
			nameText.x = skin.x + skin.width*0.35;
			nameText.y = skin.y + skin.height*0.25;
			
			var coinIcon:Image = new Image(Game.assets.getTexture("CoinIcon"));
			coinIcon.width = coinIcon.height = skin.height *0.2;
			addChild(coinIcon);
			coinIcon.x = skin.x + skin.width*0.35;
			coinIcon.y = skin.y;
			
			coinText = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,String(user.coin),0xffffff,coinIcon.height*0.8,true);
			coinText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(coinText);
			coinText.x = coinIcon.x+coinIcon.width+2;
			coinText.y = coinIcon.y;
			
			gemIcon = new Image(Game.assets.getTexture("GemIcon"));
			gemIcon.width = gemIcon.height = 30;
			addChild(gemIcon);
			gemIcon.x = coinText.x + coinText.width + 5;
			gemIcon.y = coinIcon.y;
			
			gemText = FieldController.createSingleLineDynamicField(skin.width ,coinIcon.height,String(user.gem),0xffffff,20,true);
			gemText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(gemText);
			gemText.x = gemIcon.x+gemIcon.width+2;
			gemText.y = coinIcon.y;
			
			var powerIcon:Image = new Image(Game.assets.getTexture("EnergyIcon"));
			powerIcon.width = powerIcon.height = skin.height *0.2;
			addChild(powerIcon);
			powerIcon.x = skin.x + skin.width*0.35;
			powerIcon.y = skin.y + skin.height*0.6;
			
			
			powerText = FieldController.createSingleLineDynamicField(skin.width ,powerIcon.height,String(hero.curPower),0x8EE770,powerIcon.height*0.8,true);
			powerText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(powerText);
			powerText.x = powerIcon.x+powerIcon.width+2;
			powerText.y = powerIcon.y;
			
			
			totalpowerText = FieldController.createSingleLineDynamicField(skin.width ,powerIcon.height,String("/" + hero.totalPower),0xF7BF2A,powerIcon.height*0.8,true);
			totalpowerText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(totalpowerText);
			totalpowerText.x = powerText.x+powerText.width+2;
			totalpowerText.y = powerIcon.y;
			
			powerTimeText = FieldController.createSingleLineDynamicField(skin.width ,powerIcon.height,SystemDate.getTimeMinLeftString(hero.getLeftPowerCycleTime()),0xffffff,powerIcon.height*0.8,true);
			powerTimeText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(powerTimeText);
			powerTimeText.x = totalpowerText.x+totalpowerText.width+2;
			powerTimeText.y = powerIcon.y ;
			
			
			var vipIcon:Image = new Image(Game.assets.getTexture("vipIcon"));
			vipIcon.width = vipIcon.height = skin.height *0.25;
			addChild(vipIcon);
			vipIcon.x = skin.x ;
			vipIcon.y = skin.y + skin.height*0.8;
			
			configVipImage();
			
		}
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support,parentAlpha);
			if(powerTimeText.parent){
				if(hero.curPower <hero.totalPower){
					var leftTime:int = hero.getLeftPowerCycleTime();
					powerTimeText.text ="("+SystemDate.getTimeMinLeftString(leftTime) +")";
					powerTimeText.x = totalpowerText.x+totalpowerText.width+2;
					if(leftTime <= 1 ){
						powerText.text = String(hero.curPower);
						totalpowerText.text = String("/" + hero.totalPower);
						totalpowerText.x = powerText.x+powerText.width+2;
					}
					
				}else{
					powerTimeText.removeFromParent();
				}
			}
		}
		public function refresh():void
		{
			coinText .text = String(user.coin);
			gemIcon.x = coinText.x + coinText.width + 5;
			gemText .text = String(user.gem);
			gemText.x = gemIcon.x+gemIcon.width+2;
			
			powerText.text = String(hero.curPower);
			totalpowerText.text = String("/" + hero.totalPower);
			totalpowerText.x = powerText.x+powerText.width+2;
			
			if(hero.curPower < hero.totalPower){
				addChild(powerTimeText);
			}
			
			if(vl && LanguageController.getInstance().getNumberTexture(hero.vipLevel,LanguageController.NUMBERFONT_DARKBLUE) != vl.texture){
				configVipImage();
			}
		}
		private function configVipImage():void
		{
			if(vl){
				vl.removeFromParent(true);
			}
			vl = new Image(LanguageController.getInstance().getNumberTexture(hero.vipLevel,LanguageController.NUMBERFONT_DARKBLUE));
			vl.height = skin.height *0.25;
			vl.scaleX = vl.scaleY;
			addChild(vl);
			vl.x = skin.x+skin.height *0.25;
			vl.y = skin.y + skin.height*0.8 ;
		}
		private function onTouched(e:TouchEvent):void
		{
			var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.ENDED);
			if(touches.length>=1){
				DialogController.instance.showPanel(new UserInfoPanel(),true);
			}
		}
		private function get user():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}