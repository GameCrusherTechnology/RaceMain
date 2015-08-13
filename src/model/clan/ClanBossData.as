package model.clan
{
	import gameconfig.LocalData;

	public class ClanBossData
	{
		public function ClanBossData(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("ClanData DOSE NOT EXIST in ClanBossDate: ClanBossDate["+str+"]="+data[str]);
				}
			}
		}
		public var id:String;
		public var date:int;
		public var level:int;
		public var kills:int;
		public var rate:int;
		
		private var _owner:ClanData;
		public function get owner():ClanData
		{
			if(!_owner){
				var clan:ClanData =  LocalData.getLocalClan(id);
				if(clan.adminId != 0){
					_owner = clan;
				}
				return  clan;
			}else{
				return _owner;
			}
			
		}
	}
}