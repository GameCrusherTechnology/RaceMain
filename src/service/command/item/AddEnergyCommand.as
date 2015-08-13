package service.command.item
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;

	public class AddEnergyCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function AddEnergyCommand(_itemid:String,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.ADDENERGY,onResult,{itemId:_itemid});
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				var hero:GamePlayer = GameController.instance.currentHero;
				if(result.power){
					hero.power = result.power;
				}
				if(result.powertime){
					hero.powertime = result.powertime;
				}
				if(result.item_id){
					hero.addItem(result.item_id,-1);
				}
				GameController.instance.curUIScene.refresh();
				onSuccess();
			}
		}
	}
}