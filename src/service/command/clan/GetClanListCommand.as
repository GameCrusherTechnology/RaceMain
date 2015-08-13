package service.command.clan
{
	import gameconfig.Configrations;
	
	import model.clan.ClanData;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class GetClanListCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function GetClanListCommand(callBack:Function)
		{
			onSuccess = callBack;
			super(Command.GETCLANLIST,onLogin)
		}
		private function onLogin(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.clans){
					var arr:Array = [];
					for each(var obj:Object in result.clans){
						arr.push(new ClanData(obj));
					}
					Configrations.ClansData = arr;
				}
				onSuccess();
			}
		}
	}
}

