package model.player
{
	import model.gameSpec.BattleItemSpec;

	public class MonsterPlayer extends GamePlayer
	{
		public var battleSpec:BattleItemSpec;
		
		// Elite  Ordinary
		public var battleType:String;
		public function MonsterPlayer(_battleStep:BattleItemSpec,type:String = "Ordinary")
		{
			super(null);
			battleSpec = _battleStep;
			battleType = type;
		}
	}
}