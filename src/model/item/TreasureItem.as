package model.item
{
	public class TreasureItem
	{
		public function TreasureItem(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("TreasureItem DOSE NOT EXIST in TreasureItem: TreasureItem["+str+"]="+data[str]);
				}
			}
		}
		
		public var name:String;
		public var number:int;
		public var price:int;
		public var suffer:String = "US$";
		public var isGem:Boolean = true;
		public var index:int;
		public var vip:int;
	}
}