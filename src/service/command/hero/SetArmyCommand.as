package service.command.hero
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class SetArmyCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		private var newArr:Array;
		public function SetArmyCommand(_army:Array,callBack:Function)
		{
			onSuccess =callBack;
			newArr = _army;
			super(Command.SETARMY,onHandler,{army:_army})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				
				GameController.instance.currentHero.soldierList = newArr;
				onSuccess();
			}
		}
	}
}

