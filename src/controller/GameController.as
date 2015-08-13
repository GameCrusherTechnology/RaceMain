
package controller
{
	import flash.desktop.NativeApplication;
	import flash.geom.Point;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.BattleItemSpec;
	import model.player.GamePlayer;
	import model.player.GameUser;
	import model.player.MonsterPlayer;
	
	import service.command.hero.SetArmyCommand;
	import service.command.hero.SetSkillCommand;
	import service.command.item.ComposeCommand;
	import service.command.user.LoginCommand;
	
	import starling.display.Sprite;
	
	import view.panel.BattleInfoPanel;
	import view.panel.BattleWorldPanel;
	import view.panel.CastlePanel;
	import view.panel.ComposePanel;
	import view.panel.GuidePanel;
	import view.panel.HeroInfoPanel;
	import view.panel.PackagePanel;
	import view.screen.BattleScene;
	import view.screen.CharacterSelectScreen;
	import view.screen.UIScreen;
	import view.screen.WorldScene;

	public class GameController
	{
		private var gameLayer:Sprite;
		private var sceneLayer:Sprite;
		private var dialogLayer:Sprite;
		private var uiLayer:Sprite;
		
		public var localPlayer:GameUser;
		public var selectTool:String;
		public var selectSeed:String;
		public var isNewer:Boolean = false;
		//super_man_01
		private static var _controller:GameController;
		public static function get instance():GameController
		{
			if(!_controller){
				_controller = new GameController();
			}
			return _controller;
		}
		public function GameController()
		{
			
		}
		
		public function show(layer:Game):void
		{
			gameLayer = layer;
			
			sceneLayer = new Sprite();
			gameLayer.addChild(sceneLayer);
			
			uiLayer = new Sprite;
			gameLayer.addChild(uiLayer);
			
			dialogLayer = new Sprite();
			gameLayer.addChild(dialogLayer);
			DialogController.instance.setLayer(dialogLayer);
			
		}
		public function start():void
		{
			VoiceController.instance.init();
			new LoginCommand(onLogin);
		}
		private var hasLogined:Boolean =false;
		private function onLogin():void
		{
			hasLogined = true;
			DialogController.instance.showPanel(new CharacterSelectScreen());
		}
		public function get layer():Sprite
		{
			return gameLayer;
		}
		
		private var curWorld:WorldScene;
		private var curHero:GamePlayer;
		private var curUI:UIScreen;
		
		public function get currentHero():GamePlayer
		{
			return curHero;
		}
		public function get curWorldScene():WorldScene
		{
			return curWorld;
		}
		public function get curUIScene():UIScreen
		{
			return curUI;
		}
		public function resetWorldScene(gamehero:GamePlayer):void
		{
			if(gamehero){
				curHero = gamehero;
			}
			if(curWorld){
				curWorld.removeFromParent(true);
			}
			curWorld = new WorldScene();
			sceneLayer.addChild(curWorld);
			
			if(curUI){
				curUI.removeFromParent(true);
			}
			curUI = new UIScreen();
			
			uiLayer.addChild(curUI);
		}
		public function showWorldScene(gamehero:GamePlayer = null):void{
			if(gamehero){
				curHero = gamehero;
			}
			if(!curWorld){
				curWorld = new WorldScene();
			}
			sceneLayer.addChild(curWorld);
			
			if(!curUI){
				curUI = new UIScreen();
			}else{
				curUI.refresh();
			}
			uiLayer.addChild(curUI);
		}
		
		public function beginGuide(curguiderStep:int):void
		{
			switch(curguiderStep)
			{
				case 0:
				{
//					showBattle(new BattleScene(GameController.instance.currentHero,new MonsterPlayer(getGuideBattleSpec()),getGuideHero() ));
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip0"),new Point(Configrations.ViewPortWidth/2,Configrations.ViewPortHeight*0.5),200,100,true));
					break;
				}
					
				case 1:
				{
					curWorld.packageButton.showFilter();
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip1"),curWorld.localToGlobal(new Point(curWorld.scenewidth*0.52,curWorld.sceneheight*0.56)),curWorld.scenewidth*0.2,curWorld.sceneheight*0.3));
					break;
				}
				
				case 2:
				{
					curWorld.packageButton.removeFilter();
					DialogController.instance.showPanel(new PackagePanel());
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip2"),new Point(Configrations.ViewPortWidth*0.3,Configrations.ViewPortHeight*0.375),Configrations.ViewPortWidth*0.2,Configrations.ViewPortHeight*0.25));
					break;
				}
				case 3:
				{
					DialogController.instance.showPanel(new ComposePanel());
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip3"),new Point(Configrations.ViewPortWidth*0.5,Configrations.ViewPortHeight*0.76),Configrations.ViewPortWidth*0.2,Configrations.ViewPortHeight*0.1));
					break;
				}
				case 4:
				{
					var pid:String;
					var cId:String;
					if(curHero.item_id == "10000"){
						pid = "70002";
						cId = "30002";
					}else if(curHero.item_id == "10001"){
						pid = "70001";
						cId = "30001";
					}else{
						pid = "70005";
						cId = "30005";
					}
					new ComposeCommand(pid,cId,10,Configrations.UpdateSkillCoin[0],function():void{
						DialogController.instance.showPanel(new ComposePanel(),true);
						DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip4"),new Point(Configrations.ViewPortWidth*0.5,Configrations.ViewPortHeight*0.76),Configrations.ViewPortWidth*0.2,Configrations.ViewPortHeight*0.1));
					});
					break;
				}
				case 5:
				{
					var pid1:String;
					var cId1:String;
					if(curHero.item_id == "10000"){
						pid1 = "70100";
						cId1 = "50000";
					}else if(curHero.item_id == "10001"){
						pid1 = "70101";
						cId1 = "50001";
					}else{
						pid1 = "70100";
						cId1 = "50000";
					}
					new ComposeCommand(pid1,cId1,10,Configrations.UpdateSoldierCoin[0],function():void{
						curWorld.castleButton.showFilter();
						DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip5"),curWorld.localToGlobal(new Point(curWorld.scenewidth*0.35,curWorld.sceneheight*0.1)),curWorld.scenewidth*0.3,curWorld.sceneheight*0.3),true);
					});	
					break;
				}
				case 6:
				{
					curWorld.castleButton.removeFilter();
					DialogController.instance.showPanel(new CastlePanel(),true);
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip6"),new Point(Configrations.ViewPortWidth*0.5,Configrations.ViewPortHeight*0.56),Configrations.ViewPortHeight*0.2,Configrations.ViewPortHeight*0.2));
					break;
				}
				case 7:
				{
					var sId:String;
					if(curHero.item_id == "10000"){
						sId = "50000";
					}else if(curHero.item_id == "10001"){
						sId = "50001";
					}else{
						sId = "50000";
					}
					new SetArmyCommand([sId],function():void{
						DialogController.instance.showPanel(new CastlePanel(),true);
						DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip7"),new Point(Configrations.ViewPortWidth*0.1,Configrations.ViewPortHeight*0.08),Configrations.ViewPortHeight*0.1,Configrations.ViewPortHeight*0.1));
					});
					break;
				}
				case 8:
				{
					curWorld.heroButton.showFilter();
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip8"),curWorld.localToGlobal(new Point(curWorld.scenewidth*0.62,curWorld.sceneheight*0.2)),curWorld.scenewidth*0.1,curWorld.sceneheight*0.4),true);
					break;
				}
				case 9:
				{
					curWorld.heroButton.removeFilter();
					DialogController.instance.showPanel(new HeroInfoPanel(),true);
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip9"),new Point(Configrations.ViewPortWidth*0.5,Configrations.ViewPortHeight*0.65),Configrations.ViewPortWidth*0.1,Configrations.ViewPortHeight*0.12));
					break;
				}
				case 10:
				{
					var skId:String;
					if(curHero.item_id == "10000"){
						skId = "30002";
					}else if(curHero.item_id == "10001"){
						skId = "30001";
					}else{
						skId = "30005";
					}
					new SetSkillCommand([skId],function():void{
						DialogController.instance.showPanel(new HeroInfoPanel(),true);
						DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip10"),new Point(Configrations.ViewPortWidth*0.1,Configrations.ViewPortHeight*0.08),Configrations.ViewPortHeight*0.1,Configrations.ViewPortHeight*0.1));
					});
					break;
				}
					
				case 11:
				{
					curWorld.battleButton.showFilter();
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip11"),curWorld.localToGlobal(new Point(curWorld.scenewidth*0.22,curWorld.sceneheight*0.5)),curWorld.scenewidth*0.25,curWorld.sceneheight*0.3),true);
					break;
				}
					
				case 12:
				{
					curWorld.battleButton.removeFilter();
					DialogController.instance.showPanel(new BattleWorldPanel(),true);
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip12"),new Point(Configrations.ViewPortWidth*0.29,Configrations.ViewPortHeight*0.21),Configrations.ViewPortWidth*0.18,Configrations.ViewPortHeight*0.2));
					break;
				}
				case 13:
				{
					DialogController.instance.showPanel(new BattleInfoPanel(SpecController.instance.getItemSpec("20100")as BattleItemSpec,Configrations.Ordinary_type),true);
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip13"),new Point(Configrations.ViewPortWidth*0.35,Configrations.ViewPortHeight*0.2),Configrations.ViewPortWidth*0.4,Configrations.ViewPortHeight*0.28));
					break;
				}
					
				case 14:
				{
					DialogController.instance.showPanel(new BattleInfoPanel(SpecController.instance.getItemSpec("20100")as BattleItemSpec,Configrations.Ordinary_type),true);
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip14"),new Point(Configrations.ViewPortWidth*0.775,Configrations.ViewPortHeight*0.2),Configrations.ViewPortWidth*0.15,Configrations.ViewPortHeight*0.28));
					break;
				}
				case 15:
				{
					DialogController.instance.showPanel(new BattleInfoPanel(SpecController.instance.getItemSpec("20100")as BattleItemSpec,Configrations.Ordinary_type),true);
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip15"),new Point(Configrations.ViewPortWidth*0.5,Configrations.ViewPortHeight*0.51),Configrations.ViewPortWidth*0.7,Configrations.ViewPortHeight*0.3));
					break;
				}
					
				case 16:
				{
					DialogController.instance.showPanel(new BattleInfoPanel(SpecController.instance.getItemSpec("20100")as BattleItemSpec,Configrations.Ordinary_type),true);
					DialogController.instance.showPanel(new GuidePanel(curguiderStep,LanguageController.getInstance().getString("GuideTip16"),new Point(Configrations.ViewPortWidth*0.5,Configrations.ViewPortHeight*0.8),Configrations.ViewPortWidth*0.23,Configrations.ViewPortHeight*0.1));
					break;
				}
					
				default:
				{
					break;
				}
			}
		}

		private function getGuideHero():GamePlayer
		{
			
			return new GamePlayer({	
				exp:10000	,
				item_id:"10001"	,
				name:"Hero",
				skills:	"30001:30006:30013:30017:30021"	,
				items:[
					{item_id:"30001",count:4},
					{item_id:"30006",count:4},
					{item_id:"30013",count:4},
					{item_id:"30017",count:4},
					{item_id:"30021",count:4}]
			});
		}
		private function getGuideBattleSpec():BattleItemSpec
		{		
			return SpecController.instance.getItemSpec("20000") as BattleItemSpec;
		}
		public function showBattle(battleScene:BattleScene):void
		{
			curWorld.removeFromParent();
			curUI.removeFromParent();
			sceneLayer.addChild(battleScene);
			curUI.refresh();
			
			DialogController.instance.destroy();
		}
		public function endBattle(battleScene:BattleScene):void
		{
			battleScene.removeFromParent(true);
			showWorldScene();
		}
		
		public function onKeyCancel():void
		{
			if(DialogController.instance.hasPanel){
				DialogController.instance.destroy();
			}else{
				NativeApplication.nativeApplication.exit();
			}
		}
		public function refreshLanguage():void
		{
		}
		public function levelUp():void
		{
		}
		public function get VersionMes():Array
		{
			return [1,2,3];
		}
		
	}
}