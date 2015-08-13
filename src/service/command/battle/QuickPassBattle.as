package service.command.battle
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class QuickPassBattle extends AbstractCommand
	{
		private var onSuccess:Function;
		public function QuickPassBattle(specid:String,type:String,rewards:Array,callBack:Function)
		{
			onSuccess = callBack;
			super(Command.QuickPass,onHandler,{specId:specid,battletype:type,battlerewards:rewards})
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

