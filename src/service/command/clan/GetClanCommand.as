package service.command.clan
{
	import gameconfig.LocalData;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class GetClanCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function GetClanCommand(data_ids:Array,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.GETCLANINFO,onHandler,{idArr:data_ids})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.clans){
					LocalData.onGetClans(result.clans);
				}
				onSuccess(result.clans);
			}
		}
	}
}

