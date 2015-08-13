package service.command.clan
{
	import controller.GameController;
	
	import model.clan.ClanData;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class LoginClanCommand extends AbstractCommand
	{
		public function LoginClanCommand()
		{
			super(Command.GETUSERCLAN,onLogin);
		}
		private function onLogin(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.clan){
					GameController.instance.currentHero.clanData = new ClanData(result.clan);
				}
			}
		}
	}
}

