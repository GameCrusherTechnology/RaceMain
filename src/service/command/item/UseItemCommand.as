package service.command.item
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class UseItemCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function UseItemCommand(_itemid:String,_count:int,_useGem:Boolean,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.USEITEM,onResult,{itemId:_itemid});
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				
				
				onSuccess();
			}
		}
	}
}

