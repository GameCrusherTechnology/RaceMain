package service.command.battle
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class GetPKBattleReward extends AbstractCommand
	{
		private var onSuccess:Function;
		public function GetPKBattleReward(id:String,star:int,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.GETPKBATTLEREWARDS,onHandler,{enemyId:id,battleStar:star})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess();
			}
		}
	}
}

