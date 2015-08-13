package model.player
{
	import controller.GameController;
	import controller.SpecController;
	
	import gameconfig.Configrations;
	import gameconfig.SystemDate;
	
	import model.clan.ClanBossData;
	import model.clan.ClanData;
	import model.entity.HeroItem;
	import model.gameSpec.CharacterItemSpec;
	import model.gameSpec.ItemSpec;
	import model.gameSpec.PieceItemSpec;
	import model.gameSpec.SkillItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.item.OwnedItem;
	import model.staticData.RatingData;
	import model.staticData.VipData;
	import model.staticData.VipUsedData;

	public class GamePlayer
	{
		public function GamePlayer(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in GamePlayer: GameHero["+str+"]="+data[str]);
				}
			}
		}
		public function refreshData(data:Object):void
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in GameHero: GameHero["+str+"]="+data[str]);
				}
			}
		}
		public var name:String = "Hero";
		public var characteruid:String = "1000";
		
		private var exp:int = 0;
		public function get curExp():int
		{
			return exp;
		}
		public function addExp(a:int):void
		{
			var lastL:int = level;
			exp+=a;
			if(level > lastL){
				GameController.instance.levelUp();
			}
		}
		
		
		public var item_id:String = "10000";
		
		private var _ratedata:RatingData;
		public function get rateData():RatingData {
			if(!_ratedata){
				_ratedata = new RatingData({id:characteruid});
			}
			return _ratedata;
		}
		public function set rateData(data:RatingData):void
		{
			_ratedata = data;
		}
		private function set heroRate(obj:Object):void
		{
			rateData = new RatingData(obj);
		}
		
		public var heroRateTime:int;
		public var clanRateTime:int;
		public function get heroRank():int
		{
			return Configrations.TopHeroRatingList.getIndex(characteruid);
		}
		public var power:int;
		public function get totalPower():int
		{
			var vipObject:VipData = Configrations.VIPlist[vipLevel];
			return 80+level + vipObject.energyAddTotal;
		}
		public var powertime:int;
		public function get curPower():int
		{
			var p:int;
			if(power>=totalPower){
				p =  power;
			}else{
				p = power + Math.floor((SystemDate.systemTimeS - powertime)/Configrations.POWER_CYCLE);
				p = Math.min(p,totalPower);
			}
			return p;
		}
		public function getLeftPowerCycleTime():int
		{
			return Configrations.POWER_CYCLE - (SystemDate.systemTimeS - powertime)%Configrations.POWER_CYCLE;
		}
			
			
		public var vip:int ;
		public function changeVip(changeNum:int):void
		{
			vip += changeNum;
			if(GameController.instance.curUIScene){
				GameController.instance.curUIScene.refreshHeadUI();
			}
		}
		public function get vipLevel():int
		{
			return Configrations.expToVip(vip);
		}
		
		//day count
		public var dayCountData:VipUsedData = new VipUsedData(null);
		private function set vipData(data:Object):void
		{
			dayCountData = new VipUsedData(data);
		}
		
		public function get level():int{
			return Configrations.expToGrade(exp);
		}
		
		public function getHeroItem():HeroItem
		{
			return new HeroItem({
				item_id:item_id,
				level:level,
				usedskills:skillList,
				ownedskills:ownedSkilllist
				
			});
		}
		private function getNextBattle(id:int):String
		{
			var newId:String = String(id+1);
			var spec:ItemSpec  = SpecController.instance.getItemSpec(newId);
			if(spec){
				return spec.item_id;
			}else{
				newId = String((int(int(id)/100)+1)*100);
				spec  = SpecController.instance.getItemSpec(newId);
				if(spec){
					return spec.item_id;
				}else{
					return null;
				}
			}
		}
		public var lastOrdinaryBattleId:int ;
		public var lastEliteBattleId:int;
		public function getLastId(type:String):String
		{
			var Id:String;
			
			if(type == Configrations.Ordinary_type){
				if(lastOrdinaryBattleId ==0){
					Id = "20100";
				}else{
					Id = getNextBattle(lastOrdinaryBattleId);
				}
			}else{
				if(lastEliteBattleId ==0){
					Id = "120100";
				}else{
					Id = getNextBattle(lastEliteBattleId);
				}
			}
			return Id;
		}
		
		
		//items
		public var ownedSoldierlist:Array = [];
		public var ownedSkilllist:Array = [];
		public var ownedItemlist:Array = [];
		public var ownedBattleList:Array = [];
		private function set items(arr:Array):void
		{
			var ownedItem:OwnedItem;
			var type:int;
			for(var index:int = 0;index<arr.length;index++){
				ownedItem = new OwnedItem(arr[index]["item_id"],arr[index]["count"]);
				type = int(ownedItem.item_id)/10000;
				if( type == 5){
					ownedSoldierlist.push(ownedItem);
				}else if(type == 3){
					ownedSkilllist.push(ownedItem);
				}else if(type == 2){
					if(ownedItem.count>0){
						lastOrdinaryBattleId = Math.max(lastOrdinaryBattleId,int(ownedItem.item_id));
					}
					ownedBattleList.push(ownedItem);
				}else if(type == 12){
					if(ownedItem.count>0){
						lastEliteBattleId = Math.max(lastEliteBattleId,int(ownedItem.item_id));
					}
					ownedBattleList.push(ownedItem);
				}else{
					ownedItemlist.push(ownedItem);
				}
			}
		}
		
		public function getItem(id:String):OwnedItem
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in ownedItemlist){
				if(ownedItem.item_id == id){
					return ownedItem;
				}
			}
			return new OwnedItem(id,0);
		}
		public function getSkillItem(id:String):OwnedItem
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in ownedSkilllist){
				if(ownedItem.item_id == id){
					return ownedItem;
				}
			}
			return new OwnedItem(id,0);
		}
		public function getSoldierItem(id:String):OwnedItem
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in ownedSoldierlist){
				if(ownedItem.item_id == id){
					return ownedItem;
				}
			}
			return new OwnedItem(id,0);
		}
		
		public function getBattleItem(id:String):OwnedItem
		{
			var ownedItem:OwnedItem;
			for each(ownedItem in ownedBattleList){
				if(ownedItem.item_id == id){
					return ownedItem;
				}
			}
			return new OwnedItem(id,0);
		}
		public function addItem(itemid:String,count:int):Boolean
		{
			var type:int = int(itemid)/10000;
			var list:Array ;
			var ownedItem:OwnedItem;
			if( type == 5){
				list = ownedSoldierlist;
			}else if(type == 3){
				list = ownedSkilllist;
			}else if(type == 2||type == 12){
				list =ownedBattleList;
			}else{
				list = ownedItemlist;
			}
			for each(ownedItem in list){
				if(ownedItem.item_id == itemid){
					ownedItem.count += count;
					return true;
				}
			}
			list.push(new OwnedItem(itemid,count));
			return false;
		}
		
		public function addBattleItem(itemid:String,count:int,type:String):void
		{
			var newId:String = (type ==Configrations.Ordinary_type)?itemid:("1"+itemid);
			var ownedI:OwnedItem = getBattleItem(newId);
			if(count >ownedI.count ){
				addItem(newId,count-ownedI.count);
				if(type == Configrations.Ordinary_type){
					lastOrdinaryBattleId = Math.max(lastOrdinaryBattleId,int(newId));
				}else{
					lastEliteBattleId = Math.max(lastEliteBattleId,int(newId));
				}
			}
		}
		//soldier LIst
		public var soldierList:Array = [];
		private function set soldiers(str:String):void
		{
			if(str){
				soldierList = str.split(":");
			}
		}
		
		public var soldierUpdate:String;
		
		public function pieceUpdateSoldierCount(pieceItemSpec:PieceItemSpec):int
		{
			var soldierId:String = pieceItemSpec.boundItem;
			var soldierSpec:SoldierItemSpec = SpecController.instance.getItemSpec(soldierId) as SoldierItemSpec;
			var soldierItem:OwnedItem = getSoldierItem(soldierId);
			var soldierL:int;
			if(soldierItem){
				soldierL = soldierItem.count;
			}
			var upArr:Array = soldierSpec.upCount.split(",");
			if(soldierL >= upArr.length){
				return 0;
			}else{
				var needCount:int = upArr[soldierL];
				return needCount;
			}
		}
		
		//skill
		public var skillList:Array = [];
		private function set skills(str:String):void
		{
			if(str){
				skillList = str.split(":");
			}
		}
		
		public function pieceUpdateSkillCount(pieceItemSpec:PieceItemSpec):int
		{
			var skillId:String = pieceItemSpec.boundItem;
			var skillSpec:SkillItemSpec = SpecController.instance.getItemSpec(skillId) as SkillItemSpec;
			var skillItem:OwnedItem = getSkillItem(skillId);
			var skillL:int;
			if(skillItem){
				skillL = skillItem.count;
			}
			var upArr:Array = skillSpec.upCount.split(",");
			if(skillL >= upArr.length){
				return 0;
			}else{
				var needCount:int = upArr[skillL];
				return needCount;
			}
		}
		
		//clan
		public function set clan(obj:Object):void{
			clanData = new ClanData(obj);
			clanData.validateMembers();
		}
		
		public var clanData:ClanData;
		
		public var BossId:String;
		public var BossTime:int;
		public function set bossData(data:Object):void
		{
			BossId = data['BossId'];
			BossTime = data['Date'];
		}
		
		public function set clanRate(obj:Object):void{
			_curBossDate = new ClanBossData(obj);
		}
		
		public function get clanBossDate():ClanBossData
		{
			if(!_curBossDate || _curBossDate.date != BossTime){
				_curBossDate = new ClanBossData({'date':BossTime});
			}
			return _curBossDate;
		}
		
		public function set clanBossDate(date:ClanBossData):void
		{
			_curBossDate = date;
		}
		private var _curBossDate:ClanBossData;
		
		public function get isClanAdmin():Boolean
		{
			if(!clanData){
				return false;
			}else{
				return int(characteruid) == clanData.adminId;
			}
		}
		
		private var _characterSpec:CharacterItemSpec;
		public function get characterSpec():CharacterItemSpec
		{
			if(!_characterSpec){
				_characterSpec = SpecController.instance.getItemSpec(item_id) as CharacterItemSpec;
			}
			return _characterSpec;
		}
	}
}