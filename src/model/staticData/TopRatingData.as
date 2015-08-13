package model.staticData
{
	import model.clan.ClanBossData;

	public class TopRatingData
	{
		public function TopRatingData(_time:int,dataArr:Array,isHero:Boolean = true)
		{
			time = _time;
			
			var obj:Object;
			for(var i:int = 0;i<dataArr.length;i++){
				if(isHero){
					obj = new RatingData(dataArr[i]);
					(obj as RatingData).rate = i+1;
				}else{
					obj = new ClanBossData(dataArr[i]);
					(obj as ClanBossData).rate = i+1;
				}
				topArr.push(obj);
				
			}
		}
		
		public var time:int;
		public var topArr:Array = [];
		
		public function getIndex(id:String):int
		{
			for (var i:int = 0;i<topArr.length;i++){
				if(topArr[i].id == id){
					return i+1;
				}
			}
			return 0;
		}
	}
}