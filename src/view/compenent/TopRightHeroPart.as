
package view.compenent
{
	import controller.SpecController;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.layout.TiledRowsLayout;
	
	import gameconfig.Configrations;
	
	import model.CreatMonsterData;
	import model.battle.BattleRule;
	import model.gameSpec.SoldierItemSpec;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	import view.entity.CastleEntity;
	import view.render.TopSoldierRender;
	
	public class TopRightHeroPart extends TopBattlePart
	{
		private var list:List;
		private var tWidth:Number;
		private var tHeight:Number;
		
		private var curHero:GamePlayer;
		private var castleEntity:CastleEntity;
		private var soldierListData:Array = [];
		private var rule:BattleRule;
		private const ListLength:int = 5;
		private var curCreatData:CreatMonsterData;
		
		public function TopRightHeroPart(homeEntity:CastleEntity,_rule:BattleRule)
		{
			rule = _rule;
			curHero = homeEntity.curPlayer;
			castleEntity = homeEntity;
			tWidth = Configrations.ViewPortWidth*0.5 - Configrations.ViewPortHeight*0.15*0.5/2;
			tHeight= Configrations.ViewPortHeight*0.15;
			
			initCreatList();
			configPart();
		}
		private var container:Sprite;
		private function configPart():void
		{
			container = new Sprite;
			addChild( container);
			
			var backIcon:Image = new Image(Game.assets.getTexture("stateButtonSkin"));
			backIcon.width = backIcon.height = tHeight*0.84;
			container.addChild(backIcon);
			backIcon.x = tWidth - tWidth*0.018 - backIcon.width;
			backIcon.y = tHeight/2 - backIcon.height/2;
			
			var icon:Image = new Image(Game.assets.getTexture(curHero.characterSpec.name+"HeadIcon"));
			icon.height = tHeight*0.8;
			icon.scaleX = -icon.scaleY;
			container.addChild(icon);
			icon.x = tWidth - tWidth*0.02 ;
			icon.y = tHeight/2 - icon.height/2;
			
			
			
			if(soldierListData.length>0){
				var proiconSkin:Image = new Image(Game.assets.getTexture("YPanelSkin"));
				proiconSkin.width = proiconSkin.height = tHeight*0.48;
				container.addChild(proiconSkin);
				proiconSkin.x = tWidth*0.1 + tHeight*0.8;
				proiconSkin.y = tHeight*0.01 ;
				
				const listLayout:TiledRowsLayout = new TiledRowsLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_RIGHT;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
				list = new List();
				list.layout = listLayout;
				list.dataProvider = new ListCollection(soldierListData);
				list.itemRendererFactory =function tileListItemRendererFactory():TopSoldierRender
				{
					var renderer:TopSoldierRender = new TopSoldierRender();
					
					renderer.defaultSkin = new Image(Game.assets.getTexture("BPanelSkin"));
					renderer.width = renderer.height = tHeight *0.4;
					return renderer;
				}
				list.width =  tWidth*0.9 - icon.width;
				list.height =  tHeight *0.5;
				list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				list.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
				container.addChild(list);
				list.x = tWidth*0.1 + icon.width;
				list.y = tHeight*0.5;
				
				curCreatData = (soldierListData[0] as CreatMonsterData);
				curIndex = 1;
				configProgressPart();
			}
		}
		
		private var curIcon:Image;
		private var curProgress:GreenProgressBar;
		private function configProgressPart():void
		{
			if(curCreatData){
				
				if(!curProgress){
					curProgress = new GreenProgressBar(tWidth*0.5 -  tHeight*0.8,tHeight*0.3,3);
					container.addChild(curProgress);
					curProgress.x = tWidth*0.1 + tHeight*1.25  ;
					curProgress.y = tHeight*0.25 - curProgress.height/2;
				}
				setProgress();
				
				if(curIcon){
					curIcon.removeFromParent(true);
				}
				curIcon = new Image(curCreatData.itemSpec.iconTexture);
				var s:Number =  Math.min(tHeight*0.4/curIcon.width,tHeight*0.4/curIcon.height) ;
				curIcon.scaleY = curIcon.scaleX = s;
				container.addChild(curIcon);
				curIcon.x =  tWidth*0.1 + tHeight*0.8 +tHeight*0.24 - curIcon.width/2;
				curIcon.y =  tHeight*0.25 - curIcon.height/2;
				curProgress.comment = String(curCreatData.itemSpec.cname);
			}else{
				if(curIcon){
					curIcon.removeFromParent(true);
				}
			}
		}
		
		private function setProgress():void
		{
			curProgress.progress = 1 - curCreatData.recycleTime / curCreatData.itemSpec.recycle;
		}
		
		private function initCreatList():void
		{
			var arr:Array = curHero.soldierList;
			var spec:SoldierItemSpec ;
			var id:String;
			for each(id in arr){
				spec = SpecController.instance.getItemSpec(id) as SoldierItemSpec;
				if(spec){
					soldierListData.push(new CreatMonsterData(spec));
				}
			}
		}
		
		private var curIndex:int;
		override public function validate():void
		{
			if(soldierListData.length > 0){
				if(curCreatData){
					var data:CreatMonsterData;
					var boolIn:Boolean =false;
					for each(data in soldierListData){
						if(data.creatCD > 0){
							if(curCreatData.itemSpec.item_id == data.itemSpec.item_id){
								boolIn = true;
							}
							data.creatCD --;
						}
						
					}
					if(!boolIn){
						curCreatData.recycleTime --;
						setProgress();
						if(curCreatData.recycleTime <= 0){
							castleEntity.creatSoldier(curCreatData.itemSpec,curCreatData.level);
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


