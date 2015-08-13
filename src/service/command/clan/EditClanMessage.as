package service.command.clan
{
	import service.command.AbstractCommand;
	import service.command.Command;

	public class EditClanMessage extends AbstractCommand
	{
		public function EditClanMessage(newMess:String,clanId:String)
		{
			super(Command.EDITCLANINFO,onHandler,{clanInfo:newMess,data_id:clanId})
		}
		
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
			}
		}
		
	}
}