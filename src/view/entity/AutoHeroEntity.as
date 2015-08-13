package view.entity
{
	import controller.SpecController;
	
	import model.battle.BattleRule;
	import model.entity.HeroItem;
	import model.entity.SoldierItem;
	import model.gameSpec.SkillItemSpec;

	public class AutoHeroEntity extends SoldierEntity
	{
		public function AutoHeroEntity(item:HeroItem,rule:BattleRule,_isLeft:Boolean)
		{
			super(item,rule,_isLeft);
		}
		
		override protected function attack():void
		{
			if(!curSkill){
				checkSkill();
			}
			super.attack();
		}
	}
}