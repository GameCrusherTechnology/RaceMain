package  service.command.payment
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class BuyCoinCommand extends AbstractCommand
	{
		public function BuyCoinCommand(id:String,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.BUYCOINS,onResult,{item_id:id});
		}
		private var onSuccess:Function;
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				var change:Object = result['change'];
				GameController.instance.localPlayer.addCoin(change['coin']);
				GameController.instance.localPlayer.changeGem(change['gem']);
				onSuccess();
			}else{
				
			}
		}
	}
}



