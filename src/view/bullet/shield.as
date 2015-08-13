package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import view.entity.GameEntity;

	public class shield extends ArmObject
	{
		private var hurtTargets:Array=[];
		public function shield(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			attack();
		}
		
		
		private function gethurt():int 
		{
			return Math.round(hurt*(1*level/10+1));
		}
		override public function attack():void
		{
			var targetSoldier:GameEntity ;
			if(isLeft){
				targetSoldier = rule.soldierVec[0];
			}else{
				targetSoldier = rule.monsterVec[0];
			}
			targetSoldier.beBuffed("shield",gethurt());
			removeFromParent();
			super.dispose();
		}
		
		
	}
}



