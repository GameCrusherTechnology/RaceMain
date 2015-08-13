package service.command.battle
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class GetRateClanReward extends AbstractCommand
	{
		private var onSuccess:Function;
		public function GetRateClanReward(_rank:int,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.GETRATECLANREWARD,onHandler,{rank:_rank})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.rateClanTime){
					GameController.instance.currentHero.clanRateTime = result.rateClanTime;
				}
				onSuccess();
			}
		}
	}
}
