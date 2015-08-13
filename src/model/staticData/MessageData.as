package model.staticData
{
	import gameconfig.LocalData;
	
	import model.player.GamePlayer;
	

	public class MessageData
	{
		public function MessageData(str:String)
		{
			//heroID||TIME||TYPE||MESSAGE
			
			if(str){
				var arr:Array = str.split("||");
				heroId = arr[0];
				updatetime = arr[1];
				type = arr[2];
				message = arr[3];
			}
		}
		
		public var heroId:String ;
		public var message:String;
		public var type:int;
		public var updatetime:Number;
		
		public function get curHero():GamePlayer
		{
			if(heroId){
				return LocalData.getLocalPlayer(heroId);
			}else{
				return null;
			}
		}
		
	}
}