package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import view.entity.GameEntity;
	
	public class BuffSkill extends ArmObject
	{
		private var timeT:int;
		protected var soldiers:Array;
		public function BuffSkill(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean=true)
		{
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			timeT = timeArr[level-1];
			attack();
		}
		
		override public function refresh():void
		{
			if(timeT>=0){
				timeT--;
			}else{
				disappear();
			}
		}
		
		override public function attack():void
		{
			for each(var entity:GameEntity in soldiers){
				entity.beBuffed(buffType,buffArr[level-1]);
			}
		}
		
		private function disappear():void
		{
			for each(var entity:GameEntity in soldiers){
				entity.removeBuffed(buffType,buffArr[level-1]);
			}
			
			super.dispose();
		}
		protected function get buffArr():Array 
		{
			return [2,3,4,5,6,7,8,9,10];
		}
		protected function get timeArr():Array 
		{
			return [100,100,100,120,120,120,150,150,150];
		}
		protected function get buffType():String
		{
			return "errorType";
		}
	}
}

