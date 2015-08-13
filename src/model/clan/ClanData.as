package model.clan
{
	import gameconfig.Configrations;
	import gameconfig.LocalData;
	import gameconfig.SystemDate;
	
	import model.player.GamePlayer;
	import model.staticData.MessageData;

	public class ClanData
	{
		public function ClanData(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("ClanData DOSE NOT EXIST in ClanData: ClanData["+str+"]="+data[str]);
				}
			}
			config();
		}
		
		public var data_id:String;
		public var name:String = "----";
		public var adminId:int;
		
		public var level:int;
		
		public var userClanData:UserClanData;
		private function set clanUser(obj:Object):void
		{
			userClanData = new UserClanData(obj);
		}
		
		
		public function get clanRank():int
		{
			return Configrations.TopClanRatingList.getIndex(data_id);
		}
		public function get listMemberVec():Array
		{
			memberVec.sortOn("index",Array.DESCENDING);
			return memberVec;
		}
		public var memberVec:Array = [];
		public function get memberCount():int
		{
			if(members){
				return members.split(",").length + 1;
			}else{
				return 1;
			}
		}
		private var members:String;
		private var  membersArr:Array =[];
		
		private var _adminHero:GamePlayer;
		public function get adminHero():GamePlayer{
			if(!_adminHero){
				_adminHero = new GamePlayer({"characteruid":adminId});
			}
			return _adminHero;
		}
		private function set admin(obj:Object):void
		{
			_adminHero = new GamePlayer(obj);
		}
		
		public function getMemberArrExceptUser(heroId:String):Array
		{
			var newarr:Array = [];
			for each(var data:ClanMemberData in memberVec){
				if(data.gameuid != heroId){
					newarr.push(data);
				}
			}
			return newarr;
		}
		public function get totalMember():int
		{
			return 20 + 10*level;
		}
		
		public var clanMessage:String;
		
		public function validateMembers():void
		{
			var localPlayer:Object;
			for each(var clanMember:ClanMemberData in memberVec){
				localPlayer = LocalData.localPlayers[clanMember.gameuid];
				if(localPlayer && ((SystemDate.systemTimeS - int(localPlayer['time'])) <= 24*3600) ){
					clanMember.hero = localPlayer['hero'];
				}else{
					LocalData.validatePlayerIds.push(clanMember.gameuid);
				}
			}
			LocalData.validatePlayers();
		}
		
		
		public var clanTalk:Array = [];
		public var talk:Array = [];
		
		public function addMessages(arr:Array):void
		{
			//heroID||TIME||TYPE||MESSAGE
			var localTalk:Array = LocalData.addMessages(arr,data_id);
			clanTalk = [];
			for each(var str:String in localTalk){
				clanTalk.push(new MessageData(str));
			}
			clanTalk.sortOn("updatetime",Array.DESCENDING);
		}
		private var boss:String;
		public function config():void
		{
			addMessages(talk);
			
			
			for each(var obj:Object in membersArr){
				memberVec.push(new ClanMemberData(obj,String(adminId)));
			}
			memberVec.sortOn("index",Array.DESCENDING);
		}
	}
}