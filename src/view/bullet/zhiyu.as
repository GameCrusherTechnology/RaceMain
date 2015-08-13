package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	public class zhiyu extends BuffSkill
	{
		private var timeT:int;
		public function zhiyu(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean=true)
		{
			if(_isleft){
				soldiers = _rule.soldierVec;
			}else{
				soldiers = _rule.monsterVec;
			}
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
		}
		override protected function get buffArr():Array 
		{
			return [8,10,13,16,19,22,25,28,30];
		}
		override protected function get timeArr():Array 
		{
			return [150,150,150,180,180,180,210,210,210];
		}
		override protected function get buffType():String
		{
			return "zhiyu";
		}
	}
}

