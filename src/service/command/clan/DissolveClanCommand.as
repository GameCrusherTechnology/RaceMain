package service.command.clan
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class DissolveClanCommand extends AbstractCommand
	{
		private var onSuccese:Function;
		public function DissolveClanCommand(clanId:String,_onHandler:Function)
		{
			onSuccese = _onHandler;
			super(Command.DISSOLVECLAN,onHandler,{data_id:clanId})
		}
		
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				GameController.instance.currentHero.clanData = null;
				onSuccese();
			}
		}
		
	}
}

