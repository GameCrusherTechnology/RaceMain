package view.entity
{
	import model.battle.BattleRule;
	import model.entity.MonsterCastleItem;
	import model.entity.SoldierItem;
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.SoldierItemSpec;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	public class MonsterHomeEntity extends GameEntity
	{
		public var battleItemSpec:BattleItemSpec;
		public var isLeft:Boolean = true;
		public function MonsterHomeEntity(_item:MonsterCastleItem,rule:BattleRule)
		{
			super(_item,rule,false);
			battleItemSpec = _item.battleItemSpec;
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
			
			x = item.pos_x - surface.width/2;
			y = item.pos_y;
		}
		
		
		public function creatSoldier(spec:SoldierItemSpec,level:int,isBoss:Boolean=false):void
		{
			var item:SoldierItem = new SoldierItem({pos_x:x,pos_y:y,item_id:spec.item_id,level:level});
			battleRule.addMonsterEntity(item);
		}
		
		override protected function beDead():void
		{
			super.beDead();
			battleRule.endGame(true);
		}
	}
}

