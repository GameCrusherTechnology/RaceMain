package model.item
{
	import controller.SpecController;
	
	import model.gameSpec.ItemSpec;

	public class RandomShopItem
	{
		public function RandomShopItem(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("RandomShopItem DOSE NOT EXIST in RandomShopItem: RandomShopItem["+str+"]="+data[str]);
				}
			}
		}
		
		public var item_id:String;
		public var count:int = 10;
		
		public var beBought:Boolean;
		public var useGem:Boolean;
		
		public function get cost():int
		{
			if(useGem){
				return itemSpec.gem * count;
			}else{
				return itemSpec.coin*count;
			}
		}
		public function get itemSpec():ItemSpec
		{
			return SpecController.instance.getItemSpec(item_id);
		}
	}
}