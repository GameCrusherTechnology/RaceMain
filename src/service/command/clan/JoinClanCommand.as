package service.command.clan
{
	import controller.GameController;
	
	import gameconfig.Configrations;
	
	import model.clan.ClanData;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class JoinClanCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function JoinClanCommand(data_id:String,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.JOINCLAN,onHandler,{data_id:data_id})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				var clandata:ClanData = new ClanData(result.clan);
				if(result.canJoin){
					GameController.instance.currentHero.clanData = clandata;
					GameController.instance.currentHero.clanData.validateMembers();
				}else{
					
					for each(var clan:ClanData in Configrations.ClansData){
						if(clan.data_id == clandata.data_id){
							clan = clandata;
							break;
						}
					}
				}
				onSuccess(result.canJoin);
			}
		}
	}
}

