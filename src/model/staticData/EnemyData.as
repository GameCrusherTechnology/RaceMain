package model.staticData
{
	import controller.SpecController;
	
	import model.gameSpec.SoldierItemSpec;

	public class EnemyData
	{
		public var soldierId:String;
		public var level:int = 1;
		public var isSuper:Boolean ;
		public var soldierSpec:SoldierItemSpec;
		public var creatTime:int;
		public function EnemyData(id:String,_level:int,_isSuper:Boolean,_creatTime:int)
		{
			soldierId = id;
			level = _level;
			isSuper = _isSuper;
			soldierSpec = SpecController.instance.getItemSpec(soldierId) as SoldierItemSpec;
			creatTime = _creatTime;
		}
		
	}
}