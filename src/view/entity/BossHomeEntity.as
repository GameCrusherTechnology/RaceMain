package view.entity
{
	import model.battle.BattleRule;
	import model.entity.BossCastleItem;
	import model.entity.SoldierItem;
	import model.gameSpec.SoldierItemSpec;
	import model.player.BossPlayer;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	public class BossHomeEntity extends GameEntity
	{
		public var isLeft:Boolean = true;
		public function BossHomeEntity(_item:BossCastleItem,rule:BattleRule,boss:BossPlayer)
		{
			super(_item,rule,false);
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
