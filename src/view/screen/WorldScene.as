package view.screen
{
	import flash.geom.Point;
	
	import controller.DialogController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.compenent.SceneButton;
	import view.panel.BattleWorldPanel;
	import view.panel.CastlePanel;
	import view.panel.ClanPanel;
	import view.panel.HeroInfoPanel;
	import view.panel.PackagePanel;
	import view.panel.RatingPanel;
	import view.panel.ShopPanel;
	import view.panel.ShowClansPanel;
	import view.panel.WarnnigTipPanel;

	public class WorldScene extends Sprite
	{
		public var scenewidth:Number;
		public var sceneheight:Number;
		private var sX:Number;
		private var sY:Number;
		private var list:List;
		public var castleButton:SceneButton;
		public var heroButton:SceneButton;
		public var battleButton:SceneButton;
		public var advenButton:SceneButton;
		public var clanButton:SceneButton;
		public var bossButton:SceneButton;
		public var shopButton:SceneButton;
		public var packageButton:SceneButton;
		public function WorldScene()
		{
			initializeHandler();
		}
		
		
		protected function initializeHandler():void
		{
			var sceneBack:Image = new Image(Game.assets.getTexture("SceneMap"));
			addChild(sceneBack);
			
			sX = sY = Math.max(Configrations.ViewPortWidth/sceneBack.width,Configrations.ViewPortHeight/sceneBack.height);
			sceneBack.scaleX = sX;
			sceneBack.scaleY = sY;
			
			scenewidth = sceneBack.width;
			sceneheight = sceneBack.height;
			
			
			castleButton = creatSceneButton("CastleScene");
			addChild(castleButton);
			
			heroButton = creatSceneButton("HeroScene");
			addChild(heroButton);
			
			battleButton = creatSceneButton("BattleScene");
			addChild(battleButton);
			
			advenButton = creatSceneButton("AdvenScene");
			addChild(advenButton);
			
			clanButton = creatSceneButton("ClanScene");
			addChild(clanButton);
			
			bossButton = creatSceneButton("BossScene");
			addChild(bossButton);
			
			shopButton = creatSceneButton("ShopScene");
			addChild(shopButton);
			
			packageButton = creatSceneButton("PackageScene");
			addChild(packageButton);
			
			addEventListener(TouchEvent.TOUCH,onTouch);
		}
		
		
		
		private function onClick(e:Event):void
		{
			var but:Button = e.target as Button;
			if(but){
				switch(but.name){
					case "BattleScene":
						DialogController.instance.showPanel(new BattleWorldPanel());
						break;
					case "ClanScene":
						if(hero.clanData){
							DialogController.instance.showPanel(new ClanPanel());
						}else{
							DialogController.instance.showPanel(new ShowClansPanel());
						}
						break;
					case "HeroScene":
							DialogController.instance.showPanel(new HeroInfoPanel());
						break;
					case "CastleScene":
						DialogController.instance.showPanel(new CastlePanel());
						break;
					case "PackageScene":
						DialogController.instance.showPanel(new PackagePanel());
						break;
					case "AdvenScene":
						DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("comesoonTip")));
						break;
					case "ShopScene":
						DialogController.instance.showPanel(new ShopPanel());
						break;
					case "BossScene":
						DialogController.instance.showPanel(new RatingPanel());
						break;
				}
			}
		}
		
		
		private var curBeginTouch:Touch;
		private var mouseDownPos:Point;
		private var _hasDragged:Boolean;
		
		protected function get mouseStagePosition():Point{
			return new Point(stage.pivotX,stage.pivotY);
		}
		
		public function onTouch(evt:TouchEvent):void{
			var scenePos:Point;
			var touches:Vector.<Touch> = evt.getTouches(this, TouchPhase.MOVED);
			if (touches.length >= 1){
					
				if(!_hasDragged){
					if (mouseStagePosition && mouseDownPos && mouseStagePosition.subtract(mouseDownPos).length >= Configrations.CLICK_EPSILON){
						_hasDragged = true;
					}
				}else{
					var delta:Point = touches[0].getMovement(this.parent);
					this.dragScreenTo(delta);
				}
			}
			
			//touch begin
			var beginTouch:Touch = evt.getTouch(this,TouchPhase.BEGAN);
			if(beginTouch){
				mouseDownPos = new Point(beginTouch.globalX, beginTouch.globalY);
				curBeginTouch = beginTouch;
			}
					
			var touch:Touch = evt.getTouch(this, TouchPhase.ENDED);
			//click event
			if(touch){
				if(curBeginTouch){
					curBeginTouch = null;
				}
				if(_hasDragged){
					_hasDragged=false;
				}
			}
		}
		
		protected function dragScreenTo(delta:Point):void
		{
			if(x+delta.x >0){
				x = 0;
			}else if((x+delta.x)<(Configrations.ViewPortWidth - scenewidth)){
				x = (Configrations.ViewPortWidth - scenewidth);
			}else{
				x+=delta.x;
			}
			if(y+delta.y >0){
				y = 0;
			}else if((y+delta.y)<(Configrations.ViewPortHeight - sceneheight)){
				y = (Configrations.ViewPortHeight - sceneheight);
			}else{
				y+=delta.y;
			}
		}
		
		private function creatSceneButton(name:String):SceneButton
		{
			var posObj:Object = scenePos[name];
			var but:SceneButton = new SceneButton(name,posObj["icon"],sX,sY);
			but.addEventListener(Event.TRIGGERED,onClick);
			addChild(but);
			but.x = posObj["x"]*sX;
			but.y = posObj["y"]*sX;
			return but;
		}
		
		private const scenePos:Object = {	
							"CastleScene":{"x":255,"y":50,icon:"CastleFilter"},
							"HeroScene":{"x":675,"y":118,icon:"HeroFilter"},
							"BattleScene":{"x":107,"y":306,icon:"BattleFilter"},
							"AdvenScene":{"x":809,"y":48,icon:"BossFilter"},
							"ClanScene":{"x":972,"y":242,icon:"ClanFilter"},
							"BossScene":{"x":130,"y":431,icon:"PKFilter"},
							"PackageScene":{"x":515,"y":335,icon:"PackageFilter"},
							"ShopScene":{"x":434,"y":292,icon:"ShopFilter"}
		};
		private function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
	}
}