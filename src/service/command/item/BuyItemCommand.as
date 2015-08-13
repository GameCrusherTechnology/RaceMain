package service.command.item
{
	import service.command.AbstractCommand;
	import service.command.Command;

	public class BuyItemCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function BuyItemCommand(_itemid:String,_count:int,_useGem:Boolean,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.BUYITEM,onResult,{itemId:_itemid,count:_count,useGem:_useGem});
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess(true);
			}else{
				onSuccess(false);
			}
		}
	}
}
