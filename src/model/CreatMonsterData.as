package model
{
	import model.gameSpec.SoldierItemSpec;
	
	public class CreatMonsterData
	{
		public var itemSpec:SoldierItemSpec;
		public var level:int;
		public function CreatMonsterData(sd:SoldierItemSpec,_level:int=1,_creatTime:int=0)
		{
			itemSpec = sd;
			level = _level;
			creatTime = _creatTime;
			recycleTime = itemSpec.recycle;
		}
		
		public var creatTime:int;
		
		public var recycleTime:int ;
		
		public var creatCD:int;
		public function reset():void{
			recycleTime = itemSpec.recycle;
			creatCD = recycleTime*2;
		}
		
		public function get progress():Number
		{
			return (1 - recycleTime / (itemSpec.recycle));
		}
		public function get cdProgress():Number
		{
			return creatCD/(2*itemSpec.recycle);
		}
		public function clone():CreatMonsterData
		{
			return new CreatMonsterData(itemSpec,level,creatTime);
		}
		
	}
}