package service.command.user
{
	import controller.GameController;
	
	import gameconfig.Configrations;
	
	import model.player.GameUser;
	
	import service.command.AbstractCommand;
	import service.command.Command;

	public class LoginCommand extends AbstractCommand
	{
		private var onLoginSuccess:Function;
		public function LoginCommand(callBack:Function)
		{
			onLoginSuccess =callBack;
			super(Command.LOGIN,onLogin,{uid:Configrations.userID})
		}
		private function onLogin(result:Object):void
		{
			if(Command.isSuccess(result)){
				
				GameController.instance.localPlayer = new GameUser(result['user_account']);
				GameController.instance.isNewer = result['is_new'];
				
				if(result.ad_ids){
					Configrations.AD_ids = result.ad_ids;
				}
				if(result.HeroCost){
					Configrations.HeroCost = result.HeroCost;
				}
				onLoginSuccess();
				
			}
		}
	}
}