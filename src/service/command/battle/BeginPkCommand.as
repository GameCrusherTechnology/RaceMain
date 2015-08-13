package service.command.battle
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	import model.staticData.VipUsedData;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class BeginPkCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function BeginPkCommand(id:String,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.BEGINPK,onHandler,{enemyId:id})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				var hero:GamePlayer = GameController.instance.currentHero;
				
				if(result.vipCache){
					hero.dayCountData = new VipUsedData(result.vipCache);;
				}
				if(result.power){
					hero.power = result.power;
				}
				if(result.powertime){
					hero.powertime = result.powertime;
				}
				onSuccess();
			}
		}
	}
}

