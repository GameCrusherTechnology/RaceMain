package model.staticData
{
	import gameconfig.Configrations;

	public class VipData
	{
		public function VipData(data:Object = null)
		{
			if(data){
				for(var str:String in data){
					try{
						this[str] = data[str];
					}catch(e:Error){
						trace("FIELD DOSE NOT EXIST in VipData: VipData["+str+"]="+data[str]);
					}
				}
			}
		}
		
		public var level:int;
		public function get totalExp():int{
			return Configrations.vipToExp(level);
		}
		//召唤好友次数
		public var inviteFriendCount:int;
		public function get totalinviteFriendCount():int
		{
			return inviteFriendCount + 1;
		}
		//砖石换金币次数
		public var tradeMoneyCount:int;
		//使用体力药水次数
		public var useEnergyCount:int;
		//使用一次性过关卡次数
		public var useCardCount:int;
		//增加体力上限
		public var energyAddTotal:int;
		//每日竞技场次数
		public var pkAddCount:int;
	}
}