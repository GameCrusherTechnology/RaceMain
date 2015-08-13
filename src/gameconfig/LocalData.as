package gameconfig
{
	import flash.net.SharedObject;
	
	import controller.GameController;
	
	import model.clan.ClanData;
	import model.clan.ClanMemberData;
	import model.player.GamePlayer;
	
	import service.command.clan.GetClanCommand;
	import service.command.hero.GetHerosInfoCommand;

	public class LocalData
	{
		public function LocalData()
		{
			
		}
		
		
		//players
		private static var _localPlayers:Object;
		public static function get localPlayers():Object
		{
			if(!_localPlayers){
				var data:SharedObject = SharedObject.getLocal("localPlayers");
				_localPlayers = data.data.object;
			}
			if(!_localPlayers){
				_localPlayers = {};
			}
			return _localPlayers;
		}
		
		public static var validatePlayerIds:Array = [];
		public static function validatePlayers():void
		{
			if(validatePlayerIds.length > 0){
				new GetHerosInfoCommand(validatePlayerIds,onGetPlayers);
				validatePlayerIds = [];
			}
		}
		public static function onGetPlayers(players:Array):void
		{
			var clanData:ClanData = GameController.instance.currentHero.clanData;
			for each(var obj:Object in players){
				localPlayers[obj['characteruid']] = {'hero':obj,'time':SystemDate.systemTimeS};
				if(clanData){
					for each(var memdata:ClanMemberData in clanData.memberVec){
						if(memdata.gameuid == obj['characteruid']){
							memdata.hero =  obj; 
							break;
						}
					}
				}
			}
			
			
			
			var data:SharedObject = SharedObject.getLocal("localPlayers");
			data.data.object = localPlayers;
			data.flush();
		}
		
		public static function getLocalPlayer(id:String , isTrueLy:Boolean = false):GamePlayer
		{
			var heroData:Object = localPlayers[id];
			if(!heroData){
				validatePlayerIds.push(id);
				if(isTrueLy){
					return null;
				}
				heroData = {hero:{characteruid:id}};
			}
			return new GamePlayer(heroData.hero);
		}
		
		//clan
		private static var _localClans:Object;
		public static function get localClans():Object
		{
			if(!_localPlayers){
				var data:SharedObject = SharedObject.getLocal("localClans");
				_localClans = data.data.object;
			}
			if(!_localClans){
				_localClans = {};
			}
			return _localClans;
		}
		
		public static function getLocalClan(id:String):ClanData
		{
			var clanData:Object = localClans[id];
			if(!clanData){
				validateClanIds.push(id);
				clanData = {clan:{data_id:id}};
			}
			return new ClanData(clanData.clan);
		}
		
		public static var validateClanIds:Array = [];
		public static function validateClans():void
		{
			if(validateClanIds.length > 0){
				new GetClanCommand(validateClanIds,onGetPlayers);
				validateClanIds = [];
			}
		}
		public static function onGetClans(clans:Array):void
		{
			if(clans.length>0){
				for each(var obj:Object in clans){
					if(obj && obj['data_id']){
						localClans[obj['data_id']] = {'clan':obj,'time':SystemDate.systemTimeS};
					}
				}
				
				var data:SharedObject = SharedObject.getLocal("localClans");
				data.data.object = localClans;
				data.flush();
			}
		}
		
		
		
		public static var lastRefreshMessageTime:Number=60*30;
		
		public static function canRefreshMessage():Boolean
		{
			if(lastRefreshMessageTime > 0){
				lastRefreshMessageTime --;
				return false;
			}else{
				lastRefreshMessageTime = 60*30;
				return true;
			}
		}
		
		public static function addMessages(mesArr:Array,clanId:String):Array
		{
			var data:SharedObject = SharedObject.getLocal("localClanMessages_"+clanId);
			var localMessages:Array = data.data.object;
			if(localMessages){
				var bool:Boolean;
				var newMesARR:Array = [];
				for each(var obj:String in mesArr){
					bool = false;
					for each(var obj1:String in localMessages){
						if(obj1 == obj){
							bool = true;
							break;
						}
					}
					if(!bool){
						newMesARR.push(obj);
					}
				}
				localMessages = localMessages.concat(newMesARR);
			}else{
				localMessages = mesArr;
			}
			if(localMessages.length > 20){
				localMessages = localMessages.slice(localMessages.length - 20,localMessages.length);
			}
			
			data.data.object = localMessages;
			data.flush();
			return localMessages;
		}
	}
}