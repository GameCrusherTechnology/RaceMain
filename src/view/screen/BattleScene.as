package view.screen
{
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.battle.BattleRule;
	import model.gameSpec.SkillItemSpec;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	import view.compenent.BattleLoadingScreen;
	import view.compenent.BattleTop;
	import view.compenent.HeroSkillButton;
	import view.compenent.HeroSkillTouchEvent;
	import view.compenent.ThreeStarBar;
	import view.entity.GameEntity;
	import view.entity.HeroEntity;

	public class BattleScene extends Sprite
	{
		private var mouseDownPos:Point;
		private var _hasDragged:Boolean;
		private var scenewidth:Number;
		private var sceneheight:Number;
		private var backLayer:Sprite;
		private var bgLayer:Sprite;
		private var entityLayer:Sprite;
		public var armLayer:Sprite;
		private var superLayer:Sprite;
		private var uiLayer:Sprite;
		private var bottomLine:Number = 0;
		private var backScale:Number;
		private var battleRule:BattleRule;
		private var leftHero:GamePlayer;
		private var rightHero:GamePlayer;
		private var helpHero:GamePlayer;
		
		public function BattleScene(Lplayer:GamePlayer,Rplayer:GamePlayer,helpHero:GamePlayer=null,isSuper:Boolean = false)
		{
			leftHero=Lplayer;
			rightHero = Rplayer;
			initializeBack();
			battleRule = new BattleRule(this,new Rectangle(0,0,scenewidth,bottomLine),backScale,Lplayer,Rplayer,helpHero,isSuper);
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			prepareBattle();
		}
		
		private var loadedTexturesAltas:Object;
		private function prepareBattle():void
		{
			if(!Configrations.BattleLoadingScene){
				Configrations.BattleLoadingScene = new BattleLoadingScreen();
			}
			addChild(Configrations.BattleLoadingScene);
			Configrations.BattleLoadingScene.start();
			
			
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = Game.assets;
			
			loadedTexturesAltas = battleRule.getAllTextures();
			
			
			var dic:Dictionary = new Dictionary;
			var soldierArr:Array = loadedTexturesAltas['soldier'];
			var i:int;
			var s:*;
			for(i = 0;i<soldierArr.length;i++){
				dic[soldierArr[i]] = true;
			}
			soldierArr = [];
			for(s in dic){
				soldierArr.push(s);
			}
			
			var skillArr:Array = loadedTexturesAltas['skill'];
			dic = new Dictionary;
			for(i = 0;i<skillArr.length;i++){
				dic[skillArr[i]] = true;
			}
			skillArr = [];
			for(s in dic){
				skillArr.push(s);
			}
			
			
			var name:String;
			for each(name in soldierArr){
				assets.enqueue(
					appDir.resolvePath("textures/role/"+name)
				);
			}
			for each(name in skillArr){
				assets.enqueue(
					appDir.resolvePath("textures/skill/"+name)
				);
			}
			assets.loadQueue(onPrepared);
			
			
		}
		private function onPrepared(progress:Number):void
		{
			Configrations.BattleLoadingScene.validateLoading(progress);
			if(progress >= 1){
				Configrations.BattleLoadingScene.dispose();
				battleRule.beginBattle();
				initializeHandler();
				addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		private function onAddToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		private function initializeBack():void
		{
			bgLayer = new Sprite;
			addChild(bgLayer);
			backLayer= new Sprite;
			bgLayer.addChild(backLayer);
			entityLayer = new Sprite;
			bgLayer.addChild(entityLayer);
			armLayer = new Sprite;
			bgLayer.addChild(armLayer);
			superLayer = new Sprite;
			bgLayer.addChild(superLayer);
			uiLayer = new Sprite;
			addChild(uiLayer);
			configMap();
		}
		protected function initializeHandler():void
		{
			configTop();
			configSkill();
			
			bgLayer.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		public var topContainer:BattleTop;
		private var topTipText:TextField ;
		private var topTipTextSkin:Image ;
		private var timeText:TextField;
		public var starbar:ThreeStarBar;
		private function configTop():void
		{
			topContainer = new BattleTop(battleRule);
			uiLayer.addChild(topContainer);
			
			timeText = FieldController.createSingleLineDynamicField(Configrations.ViewPortWidth ,Configrations.ViewPortHeight*0.05,"000000",0xffffff,Configrations.ViewPortHeight*0.04);
			timeText.y = Configrations.ViewPortHeight*0.1;
			uiLayer.addChild(timeText);
			
			starbar = new ThreeStarBar(3,Configrations.ViewPortHeight*0.2);
			addChild(starbar);
			starbar.x = Configrations.ViewPortWidth*0.5 - starbar.width/2;
			starbar.y = Configrations.ViewPortHeight*0.15;
			
			topTipText = FieldController.createSingleLineDynamicField(Configrations.ViewPortWidth ,Configrations.ViewPortHeight*0.05,"000000",0xEE565D,Configrations.ViewPortHeight*0.04);
			topTipText.y = Configrations.ViewPortHeight*0.25;
			topTipText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			
			topTipTextSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
			
		}
		private function configTime():void
		{
			timeText.text = SystemDate.getTimeMinLeftString(battleRule.battleCount/30);
		}
		public function showTip(str:String):void
		{
			topTipText.text = str;
			topTipText.x = Configrations.ViewPortWidth*0.5 - topTipText.width/2;
			topTipTextSkin.x = topTipText.x - 10*backScale;
			topTipTextSkin.y = topTipText.y - 5*backScale;
			topTipTextSkin.width = topTipText.width + 20*backScale;
			topTipTextSkin.height = topTipText.height + 10*backScale;
			uiLayer.addChild(topTipTextSkin);
			uiLayer.addChild(topTipText);
			setTimeout(function():void{
				topTipText.removeFromParent();
				topTipTextSkin.removeFromParent();
			},5000);
		}
		
		private function configMap():void
		{
			var scenebackSkin:Image = new Image(Game.assets.getTexture("arryBG"));
			backScale = Math.max(Configrations.ViewPortWidth/scenebackSkin.width ,Configrations.ViewPortHeight/scenebackSkin.height)
			scenebackSkin.scaleX = scenebackSkin.scaleY = backScale;
			backLayer.addChild(scenebackSkin);
			scenebackSkin.y = scenebackSkin.height - Configrations.ViewPortHeight;
			scenewidth = scenebackSkin.width;
			sceneheight = Configrations.ViewPortHeight;
			bottomLine = scenebackSkin.height *0.7;
		}
		private var skillButs:Array = [];
		private function configSkill():void
		{
			skillButs = [];
			var container:Sprite = new Sprite;
			var skills:Array = leftHero.skillList;
			var spec:SkillItemSpec;
			var curIndex:int = 0;
			var but:HeroSkillButton;
			var side:Number = Configrations.ViewPortWidth *0.1;
			var bottom:Number = Configrations.ViewPortHeight -  side - 20*Configrations.ViewScale;
			
			
			for each(var id:String in skills){
				spec = SpecController.instance.getItemSpec(id) as SkillItemSpec;
				if(spec){
					but = new HeroSkillButton(spec,side,spec.recycle);
					container.addChild(but);
					skillButs.push(but);
					but.addEventListener(HeroSkillTouchEvent.trigger,onSkillTriggered);
					but.x = curIndex*(side*1.3);
					curIndex++;
				}
			}
			container.addEventListener(Event.TRIGGERED,onSkillTriggered);
			uiLayer.addChild(container);
			container.x = Configrations.ViewPortWidth/2 - container.width/2;
			container.y = bottom;
		}
		
		private function onSkillTriggered(e:HeroSkillTouchEvent):void
		{
			var skillSpec:SkillItemSpec = e.skill;
			var hero:HeroEntity = battleRule.curHeroEntity;
			var skillClss:Class = getDefinitionByName("view.bullet."+skillSpec.name) as Class;
			var lv:int = leftHero.getSkillItem(skillSpec.item_id).count;
			battleRule.addArm(new skillClss(battleRule,hero.getSkillPoint(),hero.getCurAttackPoint(),lv,true));
		}
		
		private function onEnterFrame(e:Event):void
		{
			battleRule.validate();
			configTime();
			topContainer.validate();
			for each(var but:HeroSkillButton in skillButs){
				but.validate();
			}
		}
		public function addEntity(entity:GameEntity):void
		{
			entityLayer.addChild(entity);
			
		}
		
		public function removeEntity(entity:GameEntity):void
		{
			entity.removeFromParent(true);
		}
		
		protected function get mouseStagePosition():Point{
			return new Point(stage.pivotX,stage.pivotY);
		}
		
		public function onTouch(evt:TouchEvent):void{
			var scenePos:Point;
			var touches:Vector.<Touch> = evt.getTouches(this, TouchPhase.MOVED);
			if (touches.length >= 1){
				var movetouch:Touch = touches[0] as Touch;
				if(battleRule.hasSelectedHero){
					var point:Point = movetouch.getMovement(this.parent);
					battleRule.curHeroEntity.move(point);
				}else{
					if(!_hasDragged){
						if (mouseStagePosition && mouseDownPos && mouseStagePosition.subtract(mouseDownPos).length >= Configrations.CLICK_EPSILON){
							_hasDragged = true;
						}
					}else{
						var delta:Point = movetouch.getMovement(this.parent);
						this.dragScreenTo(delta);
					}
				}
			}
			
			//touch begin
			var beginTouch:Touch = evt.getTouch(this,TouchPhase.BEGAN);
			if(beginTouch){
				mouseDownPos = new Point(beginTouch.globalX, beginTouch.globalY);
			}
			
			var touch:Touch = evt.getTouch(this, TouchPhase.ENDED);
			//click event
			if(touch){
				if(battleRule.hasSelectedHero){
					battleRule.releaseHero();
				}else{
					if(_hasDragged){
						_hasDragged=false;
					}
				}
			}
		}
		
		public function showSkillTip(soldierTexture:Texture,skillTexture:Texture,isLeft:Boolean):void
		{
			var container:Sprite = new Sprite;
			uiLayer.addChild(container);
			
			var soldierIcon:Image = new Image(soldierTexture);
			container.addChild(soldierIcon);
			soldierIcon.width = soldierIcon.height = Configrations.ViewPortHeight*0.15;
			
			var skillIcon:Image = new Image(skillTexture);
			container.addChild(skillIcon);
			skillIcon.width = skillIcon.height = Configrations.ViewPortHeight*0.1;
			
		}
		protected function dragScreenTo(delta:Point):void
		{
			if(bgLayer.x+delta.x >0){
				bgLayer.x = 0;
			}else if((bgLayer.x+delta.x)<(Configrations.ViewPortWidth - scenewidth)){
				bgLayer.x = (Configrations.ViewPortWidth - scenewidth);
			}else{
				bgLayer.x+=delta.x;
			}
			if(bgLayer.y+delta.y >0){
				bgLayer.y = 0;
			}else if((bgLayer.y+delta.y)<(Configrations.ViewPortHeight - sceneheight)){
				bgLayer.y = (Configrations.ViewPortHeight - sceneheight);
			}else{
				bgLayer.y+=delta.y;
			}
		}
		
		public function endBattle(star:int):void
		{
			var name:String;
			for each(name in loadedTexturesAltas['soldier']){
				Game.assets.removeTextureAtlas(name,true);
			}
			for each(name in loadedTexturesAltas['skill']){
				Game.assets.removeTextureAtlas(name,true);
			}
			
			GameController.instance.showWorldScene();
			removeFromParent(true);
			
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}