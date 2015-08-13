package service.command.battle
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class GetRateHeroReward extends AbstractCommand
	{
		private var onSuccess:Function;
		public function GetRateHeroReward(_rank:int,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.GETRATEHEROREWARD,onHandler,{rank:_rank})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.rateHeroTime){
					GameController.instance.currentHero.heroRateTime = result.rateHeroTime;
				}
				onSuccess();
			}
		}
	}
}

