package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;

	public class attackBuff extends BuffSkill
	{
		private var timeT:int;
		public function attackBuff(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean=true)
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
			return [15,17,20,22,24,26,28,30,32];
		}
		override protected function get timeArr():Array 
		{
			return [150,150,150,180,180,180,210,210,210];
		}
		override protected function get buffType():String
		{
			return "attackBuff";
		}
	}
}