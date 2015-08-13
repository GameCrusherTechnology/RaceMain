package model.clan
{
	import model.player.GamePlayer;

	public class ClanMemberData
	{
		public function ClanMemberData(data:Object,_adminId:String)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("ClanMemberData DOSE NOT EXIST in ClanMemberData: ClanMemberData["+str+"]="+data[str]);
				}
			}
			adminId = _adminId;
		}
		
		public var adminId:String;
		public var gameuid:String;
		public var clan_id:int;
		public var signTime:int;
		public var bossTime:int;
		public var contribution:int;
		public function get index():int
		{
			return heroData.level;
		}
		private var _herodata:GamePlayer;
		public function get heroData():GamePlayer{
			if(!_herodata){
				_herodata = new GamePlayer({});
			}
			return _herodata;
		}
		public function set hero(data:Object):void
		{
			_herodata = new GamePlayer(data);
		}
		
	}
}