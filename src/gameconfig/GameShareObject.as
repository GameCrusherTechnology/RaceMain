package gameconfig
{
	import flash.net.SharedObject;
	
	import logic.rules.player.Player;
	
	import model.player.GameUser;

	public class GameShareObject
	{
		private static const LOCALPLAYER:String = "localplayer";
		private static const GAMEDATA:String = "gamedata";
		private static const TIMEREDUCE:String = "timereduce";
		public function GameShareObject()
		{
			
		}
		public static function saveLocalPlayerObject(data:Object):void
		{
			var shareo:SharedObject = SharedObject.getLocal(LOCALPLAYER,"/");
			var obj:Object = shareo.data.obj;
			if(obj){
				for(var o:String in data){
					obj[o] = data[o];
				}
			}else{
				obj = data;
			}
			shareo.data.obj = obj;
			shareo.flush();
		}
		public static function saveLocalPlayer(player:GameUser):void
		{
//			var data:Object = playtoObj(player);
//			var shareo:SharedObject = SharedObject.getLocal(LOCALPLAYER,"/");
//			shareo.data.obj = data;
//			shareo.flush();
		}
//		private static function playtoObj(player:GamePlayer):Object
//		{
//			return {name:player.name,gameuid:player.gameuid,blueGemsNum:player.blueGemsNum,
//				exp:player.exp,power:player.power,powertime:player.powertime,
//				vip:player.vip,powerEntity:player.powerEntity,spinEntity:player.spinEntity,cue:player.cue,
//				won:player.won,winning:player.winning,title:player.title,titleStep:player.titleStep};
//		}
		public static function getLocalPlayer():Object
		{
			var shareo:SharedObject = SharedObject.getLocal(LOCALPLAYER,"/");
			return shareo.data.obj;
		}
		
		public static function saveGameData(data:Object):void
		{
			var shareo:SharedObject = SharedObject.getLocal(GAMEDATA,"/");
			shareo.data.obj = data;
			shareo.flush();
		}
		
		public static function getGameData():Object
		{
			var shareo:SharedObject = SharedObject.getLocal(GAMEDATA,"/");
			return shareo.data.obj;
		}
		
		public static function saveSystemTimeR(data:Number):void
		{
			var shareo:SharedObject = SharedObject.getLocal(TIMEREDUCE,"/");
			shareo.data.obj = data;
			shareo.flush();
		}
		
		public static function getSystemTimeR():Number
		{
			var shareo:SharedObject = SharedObject.getLocal(TIMEREDUCE,"/");
			return shareo.data.obj;
		}
	}
}