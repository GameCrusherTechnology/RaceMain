package model.item
{
	import controller.SpecController;
	
	import model.gameSpec.ItemSpec;

	public class OwnedItem
	{
		public function OwnedItem(_itemid:String,_count:int)
		{
			item_id = _itemid;
			count = _count;
		}
		public var item_id:String;
		public var count:int;
		
		private var _itemspec:ItemSpec;
		public function get itemSpec():ItemSpec
		{
			if(!_itemspec){
				_itemspec = SpecController.instance.getItemSpec(item_id);
			}
			return _itemspec;
		}
	}
}