package service.command.battle
{
	import service.command.AbstractCommand;
	import service.command.Command;

	public class GetBattleRewards extends AbstractCommand
	{
		private var onSuccess:Function;
		public function GetBattleRewards(specid:String,type:String,rewards:Array,star:int,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.GETBATTLEREWARDS,onHandler,{specId:specid,battletype:type,battlerewards:rewards,battleStar:star})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				onSuccess();
			}
		}
	}
}