package service.command.payment
{
	import controller.DialogController;
	import controller.GameController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.item.TreasureItem;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	import view.panel.WarnnigTipPanel;
	
	public class VertifyGooglePayCommand extends AbstractCommand
	{
		private var onBack:Function;
		private var onError:Function;
		public function VertifyGooglePayCommand(param:Object,callBack:Function,onerror:Function)
		{
			onBack =callBack;
			onError = onerror;
			super(Command.GOOGLEPAY,onResult,param)
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.boughtName){
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("PaymentTip01")));
					var treaItem:TreasureItem = Configrations.treasures[result.boughtName];
					if(treaItem){
						if(treaItem.isGem){
							GameController.instance.localPlayer.changeGem(treaItem.number);
						}else{
							GameController.instance.localPlayer.changeCoin(treaItem.number);
						}
						if(GameController.instance.currentHero){
							GameController.instance.currentHero.changeVip(treaItem["vip"]);
						}
					}
				}else{
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningPay01")));
				}
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningPay01")));
				onError();
			}
		}
	}
}

