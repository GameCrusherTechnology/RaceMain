package model.gameSpec
{
	import controller.SpecController;
	
	import model.CreatMonsterData;
	import model.item.OwnedItem;
	import model.staticData.EnemyData;
	
	import starling.textures.Texture;

	public class BattleItemSpec extends ItemSpec
	{
		public function BattleItemSpec(data:Object)
		{
			super(data);
		}
		
		
		public var rewardCoin:int = 10;
		
		public var rewardExp:int = 10;
		
		public var mapId:String="40000";
		
		public var baseMonster:String;
		public function getbaseMonsters():Array
		{
			var monsters:Array = [];
			var strArr:Array = baseMonster.split("|");
			var strArr1:Array;
			var str:String;
			var spec:SoldierItemSpec;
			for each(str in strArr){
				strArr1 = str.split(":");
				spec = SpecController.instance.getItemSpec(strArr1[0]) as SoldierItemSpec;
				monsters.push(new CreatMonsterData(spec,strArr1[1]));
			}
			return monsters;
		}
		
		public var supMonster:String;
		public function getSuperMonsters():Array
		{
			var monsters:Array = [];
			var strArr:Array = supMonster.split("|");
			var strArr1:Array;
			var str:String;
			var spec:SoldierItemSpec;
			var isBoss:Boolean  = false;
			for each(str in strArr){
				strArr1 = str.split(":");
				spec = SpecController.instance.getItemSpec(strArr1[1]) as SoldierItemSpec;
				monsters.push(new CreatMonsterData(spec,strArr1[2],strArr1[0]));
			}
			return monsters;
		}
		public function getSupId():String
		{
			return String(int(item_id)+100000);
		}
		public function getRewardItem():String
		{
			var rewardArr:Array = [];
			var strArr:Array = baseMonster.split("|");
			var str:String;
			var arr1:Array;
			for each(str in strArr){
				arr1 = str.split(":");
				rewardArr.push(arr1[0]);
			}
			
			strArr = supMonster.split("|");
			for each(str in strArr){
				arr1 = str.split(":");
				if(rewardArr.indexOf(arr1[1])<0){
					rewardArr.push(arr1[1]);
				}
			}
			var id:String = rewardArr[Math.floor(Math.random()*rewardArr.length)]
			return id;
		}
		public function getSupEnemyItems():Array
		{
			var enemyArr:Array = [];
			var strArr:Array = supMonster.split("|");
			var str:String;
			var arr1:Array;
			strArr = supMonster.split("|");
			for each(str in strArr){
				arr1 = str.split(":");
				if(enemyArr.indexOf(arr1[1])<0){
					enemyArr.push(new EnemyData(arr1[1],arr1[2],true,arr1[0]));
				}
			}
			return enemyArr;
		}
		
		
		public function getBaseEnemyItems():Array
		{
			var enemyArr:Array = [];
			var strArr:Array = baseMonster.split("|");
			var str:String;
			var arr1:Array;
			for each(str in strArr){
				arr1 = str.split(":");
				enemyArr.push(new EnemyData(arr1[0],arr1[1],false,0));
			}
			
			return enemyArr;
		}
		override public function get iconTexture():Texture
		{
			return Game.assets.getTexture("soldierIcon/" + name);
		}
		public function get standTexture():Texture
		{
			return Game.assets.getTexture("standIcon/" + name+"_stand");
		}
	}
}