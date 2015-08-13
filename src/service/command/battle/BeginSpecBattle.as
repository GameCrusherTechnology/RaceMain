package service.command.battle
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;

	public class BeginSpecBattle extends AbstractCommand
	{
		private var onSuccess:Function;
		public function BeginSpecBattle(specid:String,type:String,_isHelp:Boolean,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.BEGINSPECBATTLE,onHandler,{specId:specid,battletype:type,isHelp:_isHelp})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				var hero:GamePlayer = GameController.instance.currentHero;
				if(result.power){
					hero.power = result.power;
				}
				if(result.powertime){
					hero.powertime = result.powertime;
				}
				GameController.instance.curUIScene.refresh();
				onSuccess();
			}
		}
	}
}