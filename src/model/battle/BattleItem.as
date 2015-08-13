package model.battle
{
	import model.gameSpec.BattleItemSpec;

	public class BattleItem
	{
		public function BattleItem(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("BattleItem DOSE NOT EXIST in BattleData: BattleItem["+str+"]="+data[str]);
				}
			}
		}
		
		public var item:BattleItemSpec;
		public var type:String;
		public var beReady:Boolean = true;
	}
}