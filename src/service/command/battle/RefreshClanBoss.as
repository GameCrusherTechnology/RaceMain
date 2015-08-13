package service.command.battle
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class RefreshClanBoss extends AbstractCommand
	{
		private var onSuccess:Function;
		public function RefreshClanBoss(ID:String,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.REFRESHCLANBOSS,onHandler,{clanId:ID})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				var hero:GamePlayer = GameController.instance.currentHero;
				if(hero.clanData){
					if(result.clanRateInfo){
						hero.clanRate = result.clanRateInfo;
					}
					
				}
				if(result.bossData){
					hero.bossData = result.bossData;
				}
				
				onSuccess();
			}
		}
	}
}

