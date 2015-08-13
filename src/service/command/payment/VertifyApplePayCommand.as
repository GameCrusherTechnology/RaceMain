package service.command.payment
{
	import controller.DialogController;
	import controller.GameController;
	
	import gameconfig.LanguageController;
	
	import model.item.OwnedItem;
	import model.player.GameUser;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	import view.panel.PaymentRewardsPanel;
	import view.panel.WarnnigTipPanel;

	public class VertifyApplePayCommand extends AbstractCommand
	{
		private var onBackHandle:Function;
		private var transaction:*;
		public function VertifyApplePayCommand(keyS:String,callBack:Function,t:*)
		{
			onBackHandle =callBack;
			transaction = t;
			super(Command.APPLEPAY,onResult,{key:keyS})
		}
		
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result.gem){
					var player:GameUser = GameController.instance.localPlayer;
					var addGem:int = result.gem - player.gem;
					player.changeGem(addGem);
					
					if(result.item){
						player.addItem(new OwnedItem(result.item.id,result.item.count));
					}
					if(result.items){
						for each(var obj:Object in result.items){
							if(obj.id == "coin"){
								player.addCoin(obj.count);
							}else if(obj.id == "exp"){
								player.addExp(obj.count);
							}else{
								player.addItem(new OwnedItem(obj.id,obj.count));
							}
						}
						DialogController.instance.showPanel(new PaymentRewardsPanel(addGem,result.items));
					}else{
						DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("buyTip01")));
					}
				}
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningPay01")));
			}
			onBackHandle(transaction);
		}
	}
}