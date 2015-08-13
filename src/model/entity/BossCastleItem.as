package model.entity
{
	import model.gameSpec.ItemSpec;
	
	public class BossCastleItem extends CastleItem
	{
		public function BossCastleItem(data:Object)
		{
			super(data);
		}
		public var bossSpec:ItemSpec;
	}
}

