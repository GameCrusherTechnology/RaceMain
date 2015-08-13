package service.command.user
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class CreatCharacterCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		public function CreatCharacterCommand(itemid:String,name:String,id:int,callBack:Function)
		{
			onSuccess =callBack;
			super(Command.CREATCHARACTER,onResult,{itemId:itemid,name:name,characterId:id})
		}
		private function onResult(result:Object):void
		{
			if(Command.isSuccess(result)){
				if(result["character"]){
					GameController.instance.localPlayer.user_characters.push(new GamePlayer(result["character"]));
				}
				if(result["change"]){
					if(result["change"]["coin"]){
						GameController.instance.localPlayer.changeCoin(result["change"]["coin"]);
					}
					if(result["change"]["gem"]){
						GameController.instance.localPlayer.changeGem(result["change"]["gem"]);
					}
				}
				onSuccess();
				
			}
		}
	}
}

