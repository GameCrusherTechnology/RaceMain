package model.player
{
	import model.gameSpec.ItemSpec;
	import model.gameSpec.SoldierItemSpec;

	public class BossPlayer extends  GamePlayer
	{
		public function BossPlayer(itemSpec:SoldierItemSpec,l:int,_kill:int)
		{
			super(null);
			bossSpec = itemSpec;
			bossLevel = l;
			kills = _kill;
		}
		
		public var bossSpec:SoldierItemSpec;
		public var kills:int;
		public var bossLevel:int;
	}
}