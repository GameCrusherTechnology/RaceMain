package model.entity
{
	import model.gameSpec.SoldierItemSpec;

	public class SoldierData
	{
		public var attackPoint:int;
		public var healthPoint:int;
		public var attackSpeedT:Number;
		public function SoldierData(spec:SoldierItemSpec,level:int)
		{
			attackPoint = spec.baseAttack + level*spec.attackUp;
			healthPoint = spec.baseLife + spec.lifeUp*level;
			attackSpeedT =  Math.round(spec.attackCycle/30 * 100)/100;
		}
	}
}