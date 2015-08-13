package service.command.hero
{
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class GetHerosInfoCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function GetHerosInfoCommand(arr:Array,callBack:Function,_more:Boolean = false)
		{
			onSuccess =callBack;
			super(Command.GETHEROSINFO,onLogin,{heros:arr,more:_more})
		}
		private function onLogin(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.heros){
					onSuccess(result.heros);
				}
			}
		}
	}
}

