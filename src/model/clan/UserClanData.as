package model.clan
{
	

	public class UserClanData
	{
		public function UserClanData(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("ClanData DOSE NOT EXIST in UserClanData: UserClanData["+str+"]="+data[str]);
				}
			}
		}
		public var gameuid:int;
		public var clan_id:int;
		public var bossTime:int;
		
		public var contribution:int;
		public var signTime:int;
		
	}
}

