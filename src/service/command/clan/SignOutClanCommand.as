package service.command.clan
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class SignOutClanCommand extends AbstractCommand
	{
		private var onSuccese:Function;
		public function SignOutClanCommand(clanId:String,_onHandler:Function)
		{
			onSuccese = _onHandler;
			super(Command.SIGNOUTCLAN,onHandler,{data_id:clanId})
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
