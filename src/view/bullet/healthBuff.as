package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	public class healthBuff extends BuffSkill
	{
		private var timeT:int;
		public function healthBuff(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean=true)
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
			return [8,10,12,14,16,18,20,22,25];
		}
		override protected function get timeArr():Array 
		{
			return [150,150,150,180,180,180,210,210,210];
		}
		override protected function get buffType():String
		{
			return "healthBuff";
		}
	}
}

