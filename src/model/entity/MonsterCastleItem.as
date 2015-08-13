package model.entity
{
	import controller.SpecController;
	
	import model.gameSpec.BattleItemSpec;

	public class MonsterCastleItem extends CastleItem
	{
		public function MonsterCastleItem(data:Object)
		{
			super(data);
			battleItemSpec = SpecController.instance.getItemSpec(battle_id) as BattleItemSpec;
		}
		public var battle_id:String;
		public var battleItemSpec:BattleItemSpec;
	}
}