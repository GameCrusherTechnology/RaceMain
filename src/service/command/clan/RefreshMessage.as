package service.command.clan
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class RefreshMessage extends AbstractCommand
	{
		private var onSuccess:Function;
		public function RefreshMessage(id:String,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.REFRESHMESSAGE,onHandler,{clanId:id})
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
