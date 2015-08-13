package model.staticData
{
	
	
	public class VipUsedData
	{
		public function VipUsedData(data:Object = null)
		{
			if(data){
				for(var str:String in data){
					try{
						this[str] = data[str];
					}catch(e:Error){
						trace("FIELD DOSE NOT EXIST in VipUsedData: VipUsedData["+str+"]="+data[str]);
					}
				}
			}
		}
		
		public var time:int;
		//召唤好友次数
		public var inviteFriendCount:int;
		//砖石换金币次数
		public var tradeMoneyCount:int;
		//使用体力药水次数
		public var useEnergyCount:int;
		//使用一次性过关卡次数
		public var useCardCount:int;
		//每日竞技场次数
		public var pkAddCount:int;
	}
}

