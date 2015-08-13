package model.staticData
{
	import gameconfig.LocalData;
	
	import model.player.GamePlayer;

	public class RatingData
	{
		public function RatingData(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in RatingData: RatingData["+str+"]="+data[str]);
				}
			}
		}
		
		public var id:String;
		public var rate:int;
		public var score:int;
		
		private var _owner:GamePlayer;
		public function get owner():GamePlayer
		{
			if(!_owner){
					var hero:GamePlayer =  LocalData.getLocalPlayer(id);
					if(hero.name != "Hero"){
						_owner = hero;
					}
					return  hero;
			}else{
				return _owner;
			}
			
		}
		
	}
}