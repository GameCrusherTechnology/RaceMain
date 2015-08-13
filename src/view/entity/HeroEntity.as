package view.entity
{
	import model.battle.BattleRule;
	import model.entity.HeroItem;

	public class HeroEntity extends SoldierEntity
	{
		public function HeroEntity(item:HeroItem,rule:BattleRule,isLeft:Boolean)
		{
			super(item,rule,isLeft);
		}
		
		override protected function beDead():void
		{
			if(isLeft){
				battleRule.heroDead();
			}else{
				super.beDead();
			}
			
		}
	}
}