package model.staticData
{
	public class VipListData
	{
		public function VipListData(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in VipListData: VipListData["+str+"]="+data[str]);
				}
			}
		}
		
		public var name:String;
		public var vipData:VipData;
		public var isCurLevel:Boolean;
		public function getData():String
		{
			return vipData[name];
		}
		
	}
}