package service.command.clan
{
	import controller.GameController;
	
	import gameconfig.LocalData;
	import gameconfig.SystemDate;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class SendClanMessage extends AbstractCommand
	{
		private var onSuccess:Function;
		public function SendClanMessage(mes:String,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.SENDCLANMES,onHandler,{message:mes})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				var hero:GamePlayer = GameController.instance.currentHero;
				if(result.messages){
					hero.clanData.addMessages(result.messages);
				}
				onSuccess();
			}
		}
	}
}

