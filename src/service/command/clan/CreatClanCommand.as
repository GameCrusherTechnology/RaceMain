package service.command.clan
{
	import controller.GameController;
	
	import model.clan.ClanData;
	
	import service.command.AbstractCommand;
	import service.command.Command;

	public class CreatClanCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function CreatClanCommand(_name:String,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.CREATCLAN,onHandler,{name:_name})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.clan){
					GameController.instance.currentHero.clanData = new ClanData(result.clan);
					GameController.instance.currentHero.clanData.validateMembers();
				}
				onSuccess();
			}
		}
	}
}