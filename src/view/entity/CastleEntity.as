package view.entity
{
	import model.battle.BattleRule;
	import model.entity.CastleItem;
	import model.entity.HeroItem;
	import model.entity.SoldierItem;
	import model.gameSpec.SoldierItemSpec;
	import model.player.GamePlayer;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class CastleEntity extends GameEntity
	{
		public var isLeft:Boolean ;
		public var curPlayer:GamePlayer;
		
		public function CastleEntity(_item:CastleItem,rule:BattleRule,_hero:GamePlayer,_isLeft:Boolean)
		{
			curPlayer = _hero;
			isLeft = _isLeft;
			super(_item,rule,true);
		}
		public function configHero():void
		{
			var heroItem:HeroItem = curPlayer.getHeroItem();
			heroItem.pos_x = x;
			heroItem.pos_y = y;
			curHeroEntity = new HeroEntity(heroItem,battleRule,isLeft);
			if(isLeft){
				curHeroEntity.touchable = true;
				curHeroEntity.addEventListener(TouchEvent.TOUCH,onTouchedHero);
				battleRule.curHeroEntity = curHeroEntity;
			}else{
				curHeroEntity.touchable = false;
			}
			
			battleRule.addHeroEntity(curHeroEntity,isLeft);
		}
		private var curHeroEntity:HeroEntity;
		private function onTouchedHero(e:TouchEvent):void
		{
			if(curHeroEntity && !curHeroEntity.isDead){
				var touch:Touch = e.getTouch(curHeroEntity,TouchPhase.BEGAN);
				if(touch){
					battleRule.hasSelectedHero = true;
					curHeroEntity.setOut();
					battleRule.removeEntityFromList(curHeroEntity);
				}
			}
		}
		
		override protected function creatSurface():void
		{
			surface = new MovieClip(Game.assets.getTextures("Crystal"));
			surface.scaleX = surface.scaleY = 0.8*BattleRule.cScale;
			addChild(surface);
			Starling.juggler.add(surface as MovieClip);
		}
		override protected function configPosition():void
		{
			surface.x = -surface.width/2;
			surface.y = -surface.height + 40*BattleRule.cScale;
			if(isLeft){
				x = item.pos_x + surface.width/2;
				y = item.pos_y ;
			}else{
				x = item.pos_x - surface.width/2;
				y = item.pos_y ;
			}
		}
		
		
		public function creatSoldier(spec:SoldierItemSpec,level:int):void
		{
			var item:SoldierItem = new SoldierItem({pos_x:x,pos_y:y,item_id:spec.item_id,level:level});
			if(isLeft){
				battleRule.addSoldierEntity(item);
			}else{
				battleRule.addMonsterEntity(item);
			}
		}
		
		override protected function beDead():void
		{
			super.beDead();
			battleRule.endGame(false);
		}
		
	}
}