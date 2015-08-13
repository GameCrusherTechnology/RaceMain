package gameconfig
{
	import flash.geom.Rectangle;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.textures.Scale9Textures;
	
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.PieceItemSpec;
	import model.item.OwnedItem;
	import model.item.RandomShopItem;
	import model.item.TreasureItem;
	import model.player.GamePlayer;
	import model.player.MonsterPlayer;
	import model.staticData.TopRatingData;
	import model.staticData.VipData;
	
	import starling.filters.ColorMatrixFilter;
	
	import view.bullet.Sword;
	import view.bullet.arrow;
	import view.bullet.attackBuff;
	import view.bullet.baoshe;
	import view.bullet.baoyan;
	import view.bullet.diyuhuo;
	import view.bullet.fireBullet;
	import view.bullet.fireball;
	import view.bullet.guangjian;
	import view.bullet.healthBuff;
	import view.bullet.huimielieyan;
	import view.bullet.huolian;
	import view.bullet.huoyanjian;
	import view.bullet.huoyu;
	import view.bullet.icebird;
	import view.bullet.jiguangjian;
	import view.bullet.lanyan;
	import view.bullet.liehuozhan;
	import view.bullet.lingjiaojian;
	import view.bullet.liuxingyu;
	import view.bullet.longjuanfeng;
	import view.bullet.purpleball;
	import view.bullet.qiuyan;
	import view.bullet.shield;
	import view.bullet.shujiguang;
	import view.bullet.xuanfengzhan;
	import view.bullet.zhangxinlei;
	import view.bullet.zhiyu;
	import view.compenent.BattleLoadingScreen;
	

	public class Configrations
	{
		arrow;
		Sword;
		attackBuff;
		healthBuff;
		zhiyu;
		
		
		purpleball;
		qiuyan;
		shield;
		longjuanfeng;
		lanyan;
		baoyan;
		
		
		xuanfengzhan;
		diyuhuo;
		guangjian;
		liehuozhan;
		shujiguang;
		
		
		baoshe;
		huoyanjian;
		jiguangjian;
		lingjiaojian;
		liuxingyu;
		
		fireBullet;
		fireball;
		zhangxinlei;
		huolian;
		huoyu;
		icebird;
		huimielieyan;

		public function Configrations()
		{
		}
		//配置
		public static var PLATFORM:String = "PC";
		public static var Language:String = "en";
		public static var VERSION:String = "1.0.0";
		public static var userID:String = "super_man_23";
		public static const GATEWAY:String = "http://localhost/HeroTowerServer/data/gateway.php";
//		public static const GATEWAY:String = "http://192.241.208.85/NewFarmServer/data/gateway.php";
//		public static const GATEWAY:String = "http://sunnyfarm.gamecrusher.net/NewFarmServer/data/gateway.php";
		
		//ad
		public static var AD_ids:Object={};
		//宠物 给予等级
		public static const PET_SEND_LEVEL:int = 1;
		
		
		public static var ViewPortWidth:Number;
		public static var ViewPortHeight:Number;
		public static var ViewScale:Number = 1;
		public static const CLICK_EPSILON:int = 50;
		
		//battle
		public static const  Ordinary_type:String = "Ordinary";
		public static const  Elite_type:String = "Elite";
		public static const  Battle_Energy_Cost:int = 5;
		
		//public AD
		public static var AD_BANNER:Boolean = false;
		
		//power
		public static const POWER_CYCLE:int = 300;
		//等级 经验值 换算
		
		public static function expToGrade(exp:Number):int{
			return int (Math.sqrt(exp/10));
		}
		public static function gradeToExp(grade:int):Number{
			return int(Math.pow(grade,2)*10);
		}
		
		public static function gradeToLove(grade:int):Number{
			var need:Number;
			need = Math.pow(grade+1,2)*10 - Math.pow(grade,2)*10;
			return need;
		}
		private static const vipMaxLevel:int  = 9;
		public static function expToVip(point:Number):int{
			return Math.min(vipMaxLevel,  (Math.sqrt(point/10)));
		}
		public static function vipToExp(grade:int):int{
			return int(Math.pow(grade,2)*10);
		}
		//viplist
		public static const VIPlist:Array =[
			
			new VipData({level:0,energyAddTotal:0,tradeMoneyCount:1,useEnergyCount:3,useCardCount:3,inviteFriendCount:1,pkAddCount:3}),
			new VipData({level:1,energyAddTotal:5,tradeMoneyCount:2,useEnergyCount:4,useCardCount:5,inviteFriendCount:1,pkAddCount:4}),
			new VipData({level:2,energyAddTotal:10,tradeMoneyCount:3,useEnergyCount:5,useCardCount:7,inviteFriendCount:1,pkAddCount:5}),
			new VipData({level:3,energyAddTotal:15,tradeMoneyCount:4,useEnergyCount:6,useCardCount:9,inviteFriendCount:2,pkAddCount:6}),
			new VipData({level:4,energyAddTotal:20,tradeMoneyCount:5,useEnergyCount:7,useCardCount:12,inviteFriendCount:3,pkAddCount:7}),
			new VipData({level:5,energyAddTotal:25,tradeMoneyCount:6,useEnergyCount:8,useCardCount:15,inviteFriendCount:4,pkAddCount:8}),
			new VipData({level:6,energyAddTotal:30,tradeMoneyCount:7,useEnergyCount:9,useCardCount:18,inviteFriendCount:5,pkAddCount:9}),
			new VipData({level:7,energyAddTotal:35,tradeMoneyCount:8,useEnergyCount:10,useCardCount:22,inviteFriendCount:6,pkAddCount:10}),
			new VipData({level:8,energyAddTotal:40,tradeMoneyCount:9,useEnergyCount:15,useCardCount:25,inviteFriendCount:7,pkAddCount:11}),
			new VipData({level:9,energyAddTotal:50,tradeMoneyCount:10,useEnergyCount:20,useCardCount:30,inviteFriendCount:8,pkAddCount:12})
			
		];
		
		//task 价格
		public static const treasures:Object ={
			"littleCoin":new TreasureItem({name:"littleCoin",number:10000,price:2,isGem:false,index:1,vip:10}),
			"middleCoin":new TreasureItem({name:"middleCoin",number:50000,price:10,isGem:false,index:2,vip:50}),
			"largeCoin":new TreasureItem({name:"largeCoin",number:100000,price:20,isGem:false,index:3,vip:100}),
			"littleGem":new TreasureItem({name:"littleGem",number:100,price:2,isGem:true,index:4,vip:10}),
			"middleGem":new TreasureItem({name:"middleGem",number:500,price:10,isGem:true,index:5,vip:50}),
			"largeGem":new TreasureItem({name:"largeGem",number:1000,price:20,isGem:true,index:6,vip:100})
		};
		
		
		public static function get isLocalTest():Boolean
		{
			return GATEWAY =="http://localhost/HeroTowerServer/data/gateway.php";
		}
		
		public static function get isCN():Boolean
		{
			return Configrations.Language == "zh-CN"||Configrations.Language =="zh-TW";
		}
		public static const Languages:Array  = ["en","zh-CN","de","ru","tr","zh-TW"];
		//loadingscene
		
		public static var BattleLoadingScene:BattleLoadingScreen;
		
		//panel texture
		private static var _WhiteSkin:Scale9Textures;
		public static function get WhiteSkinTexture():Scale9Textures
		{
			if(!_WhiteSkin){
				_WhiteSkin = new Scale9Textures(Game.assets.getTexture("WhiteSkin"),new Rectangle(2,2,60,60));
			}
			return _WhiteSkin;
		}
		
		private static var _PanelRenderSkinTexture:Scale9Textures;
		public static function get PanelRenderSkinTexture():Scale9Textures
		{
			if(!_PanelRenderSkinTexture){
				_PanelRenderSkinTexture = new Scale9Textures(Game.assets.getTexture("PanelRenderSkin"),new Rectangle(10,10,30,30));
			}
			return _PanelRenderSkinTexture;
		}
		
		private static var _BlueRenderSkinTexture:Scale9Textures;
		public static function get BlueRenderSkinTexture():Scale9Textures
		{
			if(!_BlueRenderSkinTexture){
				_BlueRenderSkinTexture = new Scale9Textures(Game.assets.getTexture("BPanelSkin"),new Rectangle(10,10,70,70));
			}
			return _BlueRenderSkinTexture;
		}
		
		private static var _simplePanelSkinTexture:Scale9Textures;
		public static function get SimplePanelSkinTexture():Scale9Textures
		{
			if(!_simplePanelSkinTexture){
				_simplePanelSkinTexture = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"),new Rectangle(10,10,30,30));
			}
			return _simplePanelSkinTexture;
		}
		
		private static var _PanelTitleSkinTexture:Scale9Textures;
		public static function get PanelTitleSkinTexture():Scale9Textures
		{
			if(!_PanelTitleSkinTexture){
				_PanelTitleSkinTexture = new Scale9Textures(Game.assets.getTexture("PanelTitle"),new Rectangle(15,14,70,20));
			}
			return _PanelTitleSkinTexture;
		}
		
		public static function get  grayscaleFilter():ColorMatrixFilter
		{
			var _grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter();
			_grayscaleFilter.adjustSaturation(-1);
			return _grayscaleFilter;
		}
		
		public static var ClansData:Array;
		
		public static var ShopItems:Array = [
			new RandomShopItem({'item_id':70000,'count':1,'beBought':false,'useGem':false}),
			new RandomShopItem({'item_id':70001,'count':1,'beBought':false,'useGem':true}),
			new RandomShopItem({'item_id':70002,'count':1,'beBought':false,'useGem':false}),
			new RandomShopItem({'item_id':70003,'count':1,'beBought':false,'useGem':false}),
			new RandomShopItem({'item_id':70004,'count':1,'beBought':true,'useGem':false}),
			new RandomShopItem({'item_id':70005,'count':2,'beBought':false,'useGem':false}),
			new RandomShopItem({'item_id':70006,'count':1,'beBought':false,'useGem':false}),
			new RandomShopItem({'item_id':70007,'count':1,'beBought':true,'useGem':false}),
			new RandomShopItem({'item_id':70008,'count':1,'beBought':false,'useGem':true}),
			new RandomShopItem({'item_id':70009,'count':1,'beBought':true,'useGem':false}),
			new RandomShopItem({'item_id':70000,'count':1,'beBought':false,'useGem':true}),
			new RandomShopItem({'item_id':70101,'count':2,'beBought':true,'useGem':false}),
			new RandomShopItem({'item_id':70102,'count':2,'beBought':false,'useGem':true}),
			new RandomShopItem({'item_id':70103,'count':1,'beBought':false,'useGem':false}),
			new RandomShopItem({'item_id':70104,'count':2,'beBought':true,'useGem':true}),
			new RandomShopItem({'item_id':70105,'count':2,'beBought':false,'useGem':false}),
			
		];
		
		public static var HeroCost:Array = [
			{"gem":10,"coin":100},
			{"gem":100000,"coin":100000}
		];
		
		//rating
		public static var TopHeroRatingList:TopRatingData;
		public static var TopClanRatingList:TopRatingData;
		
		//pkList
		public static var PKList:Array = [];
		public static var PKScoreReward:int = 10;
		public static function getRewards(star:int,isPvp:Boolean,rightPlayer:GamePlayer):Array
		{
			var rewardsL:Array = [];
			var item:OwnedItem;
			if(isPvp){
				rewardsL.push(new OwnedItem("score",star*PKScoreReward));
			}else if(rightPlayer is MonsterPlayer){
				var battleSpec:BattleItemSpec = (rightPlayer as MonsterPlayer).battleSpec;
				rewardsL.push(new OwnedItem("exp",battleSpec.rewardExp));
				if(star >1){
					rewardsL.push(new OwnedItem("coin",battleSpec.rewardCoin));
				}
				if(star > 2){
					rewardsL.push(new OwnedItem(battleSpec.getRewardItem(),1));
				}
				
			}
			return rewardsL;
		}
		
		public static function getComposeArr(hero:GamePlayer):Array
		{
			var itemArr:Array = [];
			var list:Array = hero.ownedItemlist;
			var item:OwnedItem;
			for each(item in list){
				if(item.itemSpec is PieceItemSpec){
					if(PieceItemSpec(item.itemSpec).type == "skill"){
						var needSkill:int = hero.pieceUpdateSkillCount(PieceItemSpec(item.itemSpec));
						if(needSkill <= item.count && needSkill >0){
							itemArr.push(item);
						}
					}else if(PieceItemSpec(item.itemSpec).type == "soldier"){
						var needSoldier:int = hero.pieceUpdateSoldierCount(PieceItemSpec(item.itemSpec));
						if(needSoldier <= item.count && needSoldier >0){
							itemArr.push(item);
						}
					}
				}
			}
			return itemArr;
		}
		public static var UpdateSkillCoin:Array =[100,500,1000,2000,4000,6000,8000,10000,15000,20000]; 
		public static var UpdateSoldierCoin:Array =[100,1000,5000,10000,20000];
		public static function InputTextFactory(target:TextInput , inputParameters:Object ):void
		{
			var editor:StageTextTextEditor = new StageTextTextEditor;
			editor.color = (inputParameters.color == undefined) ? editor.color:inputParameters.color;
			editor.fontSize = (inputParameters.fontSize == undefined) ? editor.fontSize:inputParameters.fontSize;
			//			editor.editable =  (inputParameters.editable == undefined) ? editor.editable:inputParameters.editable;
			target.maxChars = (inputParameters.maxChars == undefined) ? editor.maxChars:inputParameters.maxChars;
			editor.displayAsPassword = (inputParameters.displayAsPassword == undefined)?editor.displayAsPassword:inputParameters.displayAsPassword;
			target.textEditorFactory = function textEditor():ITextEditor{return editor};
			target.text  = inputParameters.text;
		}
		
		
	}
}