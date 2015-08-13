package view.compenent
{
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	
	import gameconfig.Configrations;
	
	import model.CreatMonsterData;
	import model.battle.BattleRule;
	import model.gameSpec.SoldierItemSpec;
	import model.player.BossPlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	import view.entity.BossHomeEntity;
	import view.render.TopSoldierRender;
	
	public class TopBossPart extends TopBattlePart
	{
		private var bossEntity:BossHomeEntity;
		
		private var tWidth:Number;
		private var tHeight:Number;
		private var list:List;
		private var rule:BattleRule;
		private const ListLength:int = 5;
		private var curCreatData:CreatMonsterData;
		private var bossPlayer:BossPlayer;
		
		public function TopBossPart(homeEntity:BossHomeEntity,_rule:BattleRule,_bossPlayer:BossPlayer)
		{
			rule = _rule;
			bossEntity = homeEntity;
			bossPlayer = _bossPlayer;
			tWidth = Configrations.ViewPortWidth*0.5 - Configrations.ViewPortHeight*0.15*0.5/2;
			tHeight= Configrations.ViewPortHeight*0.15;
			
			initCreatList();
			configPart();
		}
		private var container:Sprite;
		private var soldierListData:Array = [];
		private function configPart():void
		{
			container = new Sprite;
			addChild( container);
			
			list = new List();
			
			var rightIcon:Image	 = new Image(bossPlayer.bossSpec.iconTexture);
			var s:Number =  tHeight*0.8/rightIcon.height ;
			rightIcon.scaleY = rightIcon.scaleX = s;
			container.addChild(rightIcon);
			rightIcon.x = tWidth*0.98-rightIcon.width;
			rightIcon.y = tHeight/2- rightIcon.height/2;
			
			var proiconSkin:Image = new Image(Game.assets.getTexture("YPanelSkin"));
			proiconSkin.width = proiconSkin.height = tHeight*0.48;
			container.addChild(proiconSkin);
			proiconSkin.x = tWidth*0.9 - tHeight*0.8 -proiconSkin.width ;
			proiconSkin.y = tHeight*0.01 ;
			
			const listLayout:HorizontalLayout = new HorizontalLayout();
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			
			list.layout = listLayout;
			list.dataProvider = new ListCollection(soldierListData);
			list.itemRendererFactory =function tileListItemRendererFactory():TopSoldierRender
			{
				var renderer:TopSoldierRender = new TopSoldierRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("BPanelSkin"));
				renderer.width = renderer.height = tHeight *0.4;
				return renderer;
			}
			list.width =  tWidth*0.65 - tHeight*0.6;
			list.height =  tHeight *0.5;
			list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FIXED;
			list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			container.addChild(list);
			list.x = tWidth*0.9 - tHeight*0.6 - list.width;
			list.y = tHeight*0.5;
			list.touchable = false;
			
		}
		
		private var curIcon:Image;
		private var curProgress:GreenProgressBar;
		private function configProgressPart():void
		{
			if(curCreatData){
				
				if(!curProgress){
					curProgress = new GreenProgressBar(tWidth*0.5 -  tHeight*0.8,tHeight*0.3,3);
					curProgress.fillDirection = GreenProgressBar.RIGHT_TO_LEFT;
					container.addChild(curProgress);
					curProgress.x = tWidth*0.9 - tHeight*1.25  -curProgress.width ;
					curProgress.y = tHeight*0.25 - curProgress.height/2;
				}
				setProgress();
				
				if(curIcon){
					curIcon.removeFromParent(true);
				}
				curIcon = new Image(curCreatData.itemSpec.iconTexture);
				var s:Number =  tHeight*0.4/curIcon.height ;
				curIcon.scaleY = curIcon.scaleX = s;
				container.addChild(curIcon);
				curIcon.x =  tWidth*0.9 - tHeight*0.8 - tHeight*0.24 - curIcon.width/2;
				curIcon.y =  tHeight*0.25 - curIcon.height/2;
				
				curProgress.comment = String(curCreatData.itemSpec.cname);
				
			}else{
				curProgress.comment = String(curCreatData.itemSpec.cname);
				if(curIcon){
					curIcon.removeFromParent(true);
				}
			}
		}
		
		private function setProgress():void
		{
			curProgress.progress = curCreatData.progress;
		}
		
		private function initCreatList():void
		{
			var spec:SoldierItemSpec = bossPlayer.bossSpec;
			
			var level:int = bossPlayer.bossLevel;
			var i:int;
			while(i< 4){
				soldierListData.push(new CreatMonsterData(spec,level));
				i++;
			}
		}
		
		private var curIndex:int;
		override public function validate():void
		{
			if(soldierListData.length > 0){
				if(curCreatData){
					var data:CreatMonsterData;
					for each(data in soldierListData){
						if(data.creatCD > 0){
							data.creatCD --;
						}
					}
					if(curCreatData.creatCD <= 0){
						curCreatData.recycleTime --;
						setProgress();
						if(curCreatData.recycleTime <= 0){
							bossEntity.creatSoldier(curCreatData.itemSpec,curCreatData.level);
							curCreatData.reset();
							changeNext();
						}
					}
				}else{
					changeNext();
				}
			}
		}
		
		private function changeNext():void
		{
			if(curIndex >= soldierListData.length){
				curIndex = 0;
			}
			curCreatData = (soldierListData[curIndex] as CreatMonsterData);
			curIndex++;
			configProgressPart();
			list.dataProvider = new ListCollection(soldierListData);
		}
		
	}
}
