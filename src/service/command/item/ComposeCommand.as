package service.command.item
{
	import controller.DialogController;
	import controller.GameController;
	
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	import view.panel.WarnnigTipPanel;
	
	public class ComposeCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		private var id:String;
		private var composeid:String;
		private var needCount:int;
		private var needCoin:int;
		public function ComposeCommand(_pieceItemId:String,_composeId:String,_needCount:int,_needCoin:int,callBack:Function)
		{
			onSuccess =callBack;
			id = _pieceItemId;
			composeid = _composeId;
			needCoin = _needCoin;
			needCount = _needCount;
			super(Command.COMPOSEITEM,onResult,{pieceItemId:_pieceItemId});
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				var player:GameUser = GameController.instance.localPlayer;
				player.coin -= needCoin;
				
				var hero:GamePlayer = GameController.instance.currentHero;
				hero.addItem(composeid,1);
				hero.addItem(id,-needCount);
				
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("upgradeSuc")));
				
				onSuccess();
			}
		}
	}
}

