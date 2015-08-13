package service.command.battle
{
	import gameconfig.Configrations;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class FindEnemyCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function FindEnemyCommand(_score:int,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.FINDENEMY,onHandler,{score:_score})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.enemys){
					Configrations.PKList = result.enemys;
				}
				onSuccess();
			}
		}
	}
}

