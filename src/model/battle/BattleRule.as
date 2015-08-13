package model.battle
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.GameController;
	import controller.SpecController;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.entity.BossCastleItem;
	import model.entity.CastleItem;
	import model.entity.HeroItem;
	import model.entity.MonsterCastleItem;
	import model.entity.SoldierItem;
	import model.gameSpec.BattleItemSpec;
	import model.gameSpec.SkillItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.item.OwnedItem;
	import model.player.BossPlayer;
	import model.player.GamePlayer;
	import model.player.MonsterPlayer;
	
	import service.command.battle.GetBattleRewards;
	import service.command.battle.GetPKBattleReward;
	
	import view.bullet.ArmObject;
	import view.entity.AutoHeroEntity;
	import view.entity.BossHomeEntity;
	import view.entity.CastleEntity;
	import view.entity.GameEntity;
	import view.entity.HeroEntity;
	import view.entity.MonsterHomeEntity;
	import view.entity.SoldierEntity;
	import view.panel.BattleResultPanel;
	import view.screen.BattleScene;

	public class BattleRule
	{
		public var homeCastleEntity:CastleEntity;
		public var enemyCastleEntity:GameEntity;
		
		public var soldierVec:Array;
		public var monsterVec:Array;
		
		private var armsArr:Array = [];
		
		private var curScene:BattleScene;
		
		public var curHeroEntity:HeroEntity;
		
		private var isSuperBattle:Boolean;
		
		public var LeftPlayer:GamePlayer;
		public var RightPlayer:GamePlayer;
		private var helpHero:GamePlayer;
		public var boundRect:Rectangle;
		
		private var battleStar:int = 3;
		private var battleMaxTime:int =10*30;
		
		public static var cScale:Number;
		
		public function BattleRule(scene:BattleScene,bound:Rectangle,s:Number,Lplayer:GamePlayer,Rplayer:GamePlayer,_helpHero:GamePlayer=null,isSuper:Boolean = false)
		{
			curScene = scene;
			boundRect = bound;
			LeftPlayer = Lplayer;
			RightPlayer = Rplayer;
			isSuperBattle = isSuper;
			helpHero = _helpHero;
			
			cScale  = s*0.8;
			soldierVec = [];
			monsterVec = [];
			
			initArms();
		}
		
		public function beginBattle():void
		{
			
			homeCastleEntity = new CastleEntity(new CastleItem({item_id:"60000",pos_x:50*cScale,pos_y:boundRect.bottom}),this,GameController.instance.currentHero,true);
			curScene.addEntity(homeCastleEntity);
			
			if(isPvp){
				enemyCastleEntity = new CastleEntity(new CastleItem({item_id:"60000",pos_x:boundRect.right-50*cScale,pos_y:boundRect.bottom}),this,RightPlayer,false);
				curScene.addEntity(enemyCastleEntity);
				(enemyCastleEntity as CastleEntity).configHero();
			}else if(RightPlayer is MonsterPlayer){
				enemyCastleEntity = new MonsterHomeEntity(new MonsterCastleItem({item_id:"60000",battle_id:(RightPlayer as MonsterPlayer).battleSpec.item_id,pos_x:boundRect.right-50*cScale,pos_y:boundRect.bottom}),this);
				curScene.addEntity(enemyCastleEntity);
			}else if(RightPlayer is BossPlayer){
				enemyCastleEntity = new BossHomeEntity(new BossCastleItem({item_id:"60000",pos_x:boundRect.right-50*cScale,pos_y:boundRect.bottom}),this,(RightPlayer as BossPlayer));
				curScene.addEntity(enemyCastleEntity);
			}
			
			homeCastleEntity.configHero();
			
			isBattling = true;
			battleCount = 0;
			
		}
		private var isBattling:Boolean = false;
		private var rewards:Array = [];
		public function endGame(isWin:Boolean):void
		{
			isBattling = false;
			if(!isPvp && !isWin){
				battleStar = 0;
			}
			
			rewards = Configrations.getRewards(battleStar,isPvp,RightPlayer);
			if(!isPvp){
				if(RightPlayer is MonsterPlayer){
					new GetBattleRewards((RightPlayer as MonsterPlayer).battleSpec.item_id,(RightPlayer as MonsterPlayer).battleType,rewards,battleStar,onGetCommanded);
				}else if(RightPlayer is BossPlayer){
					
				}
			}else{
				new GetPKBattleReward((RightPlayer as GamePlayer).characteruid,battleStar,onGetCommanded);
			}
		}
		
		private function onGetCommanded():void
		{
			DialogController.instance.showPanel(new BattleResultPanel(battleStar,rewards));
			for each(var ownedItem:OwnedItem in rewards){
				if(ownedItem.item_id == "coin"){
					GameController.instance.localPlayer.changeCoin(ownedItem.count);
				}
				else if(ownedItem.item_id == "gem"){
					GameController.instance.localPlayer.changeGem(ownedItem.count);
				}else if(ownedItem.item_id == "exp"){
					LeftPlayer.addExp( ownedItem.count);
				}
				else if(ownedItem.item_id == "score"){
					LeftPlayer.rateData.score += ownedItem.count;
				}else{
					LeftPlayer.addItem(ownedItem.item_id,ownedItem.count);
				}
			}
			if(!isPvp){
				if(RightPlayer is MonsterPlayer){
					LeftPlayer.addBattleItem((RightPlayer as MonsterPlayer).battleSpec.item_id,battleStar,(RightPlayer as MonsterPlayer).battleType);
				}
			}
		}
		public var battleCount:int;
		public function validate():void
		{
			if(isBattling){
				battleCount++;
				var entity:GameEntity;
				for each(entity in soldierVec){
					entity.validate();
				}
				for each(entity in monsterVec){
					entity.validate();
				}
				homeCastleEntity.validate();
				enemyCastleEntity.validate();
				
				var arm:ArmObject;
				for each(arm in armsArr){
					arm.refresh();
				}
				
				monsterVec.sortOn("x",Array.NUMERIC);
				soldierVec.sortOn("x",Array.DESCENDING|Array.NUMERIC);
			}else{
				curScene.endBattle(battleStar);
			}
			if(battleCount == battleMaxTime){
				reduceStar("time");
			}
		}
		
		public function getAllTextures():Object
		{
			var soldierArr:Array = [];
			var skillArr:Array = [];
			var obj:Object;
			if(LeftPlayer){
				obj = getTextureFromPlayer(LeftPlayer);
				soldierArr = soldierArr.concat(obj['soldier']);
				skillArr = skillArr.concat(obj['skill']);
			}
			
			if(helpHero){
				obj = getTextureFromPlayer(helpHero);
				soldierArr = soldierArr.concat(obj['soldier']);
				skillArr = skillArr.concat(obj['skill']);
			}
			if(isPvp){
				obj = getTextureFromPlayer(RightPlayer);
				soldierArr = soldierArr.concat(obj['soldier']);
				skillArr = skillArr.concat(obj['skill']);
			}else{
				if(RightPlayer is MonsterPlayer){
					if((RightPlayer as MonsterPlayer).battleSpec){
						obj = getTextureFromBattle((RightPlayer as MonsterPlayer).battleSpec);
						soldierArr = soldierArr.concat(obj['soldier']);
						skillArr = skillArr.concat(obj['skill']);
					}
				}else if(RightPlayer is BossPlayer){
					if((RightPlayer as BossPlayer).bossSpec){
						obj = getTextureFromSoldier((RightPlayer as BossPlayer).bossSpec);
						soldierArr = soldierArr.concat(obj['soldier']);
						skillArr = skillArr.concat(obj['skill']);
					}
				}
			}
			
			
			for(var i:int=0,newSoldier:Array=[];i<soldierArr.length;i++){
				if(newSoldier.indexOf(soldierArr[i])==-1){
					newSoldier.push(soldierArr[i])  
				}
			}
			
			for(var j:int=0,newSkill:Array=[];j<skillArr.length;j++){
				if(newSkill.indexOf(skillArr[j])==-1){
					newSkill.push(skillArr[j])  
				}
			}
			
			
			return {"soldier":newSoldier,"skill":newSkill};
		}
		private function getTextureFromPlayer(player:GamePlayer):Object
		{
			var id:String;
			var soldierSpec:SoldierItemSpec;
			var soldierLevel:int;
			var textureArr:Array = [];
			var skillArr:Array = [];
			var soldierSkillArr:Array = [];
			var skillId:String;
			var skillSpec:SkillItemSpec;
			
			textureArr.push(player.characterSpec.name);
			
			for each(id in player.skillList){
				skillSpec = SpecController.instance.getItemSpec(id) as SkillItemSpec;
				if(skillSpec){
					skillArr.push(skillSpec.name);
					if(skillSpec.buffName){
						skillArr.push(skillSpec.buffName);
					}
				}
			}
			
			for each(id in player.soldierList){
				soldierSpec = SpecController.instance.getItemSpec(id) as SoldierItemSpec;
				if(soldierSpec){
					textureArr.push(soldierSpec.name);
					soldierLevel = player.getSoldierItem(id).count;
					soldierSkillArr = soldierSpec.getSkills(soldierLevel);
					for each(skillId in soldierSkillArr){
						skillSpec = SpecController.instance.getItemSpec(skillId) as SkillItemSpec;
						if(skillSpec){
							skillArr.push(skillSpec.name);
							if(skillSpec.buffName){
								skillArr.push(skillSpec.buffName);
							}
						}
						
					}
				}
			}
			return {"soldier":textureArr,"skill":skillArr};
		}
		
		private function getTextureFromBattle(battleStep:BattleItemSpec):Object
		{
			var soldierSpec:SoldierItemSpec;
			var soldierLevel:int;
			var textureArr:Array = [];
			var skillArr:Array = [];
			var soldierSkillArr:Array = [];
			var skillId:String;
			var skillSpec:SkillItemSpec;
			
			var strArr:Array = battleStep.supMonster.split("|");
			var strArr1:Array;
			var str:String;
			for each(str in strArr){
				strArr1 = str.split(":");
				soldierSpec = SpecController.instance.getItemSpec(strArr1[1]) as SoldierItemSpec;
				
				textureArr.push(soldierSpec.name);
				soldierLevel = strArr1[2];
				soldierSkillArr = soldierSpec.getSkills(soldierLevel);
				for each(skillId in soldierSkillArr){
					skillSpec = SpecController.instance.getItemSpec(skillId) as SkillItemSpec;
					if(skillSpec){
						skillArr.push(skillSpec.name);
					}
				}
			}
			strArr = battleStep.baseMonster.split("|");
			for each(str in strArr){
				strArr1 = str.split(":");
				soldierSpec = SpecController.instance.getItemSpec(strArr1[0]) as SoldierItemSpec;
				
				textureArr.push(soldierSpec.name);
				soldierLevel = 1;
				soldierSkillArr = soldierSpec.getSkills(soldierLevel);
				for each(skillId in soldierSkillArr){
					skillSpec = SpecController.instance.getItemSpec(skillId) as SkillItemSpec;
					if(skillSpec){
						skillArr.push(skillSpec.name);
					}
				}
			}
			return {"soldier":textureArr,"skill":skillArr};
		}
		
		private function getTextureFromSoldier(spec:SoldierItemSpec):Object
		{
			var textureArr:Array = [];
			var skillArr:Array = [];
			var soldierSkillArr:Array = [];
			var skillId:String;
			var skillSpec:SkillItemSpec;
			
			textureArr = [spec.name];
			
			soldierSkillArr = spec.getSkills(100);
			for each(skillId in soldierSkillArr){
				skillSpec = SpecController.instance.getItemSpec(skillId) as SkillItemSpec;
				if(skillSpec){
					skillArr.push(skillSpec.name);
				}
			}
			
			return {"soldier":textureArr,"skill":skillArr};
		}
		
		
		public var hasSelectedHero:Boolean = false;
		
		public function releaseHero():void
		{
			hasSelectedHero = false;
			var pX:Number ; 
			if(monsterVec.length > 0){
				pX = (monsterVec[0] as GameEntity).x - 5;
			}else{
				pX = enemyCastleEntity.x - 5;
			}
			curHeroEntity.x = Math.max(Math.min(curHeroEntity.x ,pX,enemyCastleEntity.x),homeCastleEntity.x);
			curHeroEntity.y = boundRect.bottom;
			
			curHeroEntity.setIn();
			soldierVec.push(curHeroEntity);
		}
		
		public function addHeroEntity(hero:HeroEntity,isleft:Boolean):void
		{
			if(isleft){
				soldierVec.push(hero);
			}else{
				monsterVec.push(hero);
			}
			curScene.addEntity(hero);
		}
		
		public function addSoldierEntity(item:SoldierItem):void
		{
			var entity:SoldierEntity = new SoldierEntity(item,this,true);
			soldierVec.push(entity);
			curScene.addEntity(entity);
		}
		
		public function addMonsterEntity(item:SoldierItem):void
		{
			var entity:SoldierEntity = new SoldierEntity(item,this,false);
			monsterVec.push(entity);
			curScene.addEntity(entity);
		}
		public function heroDead():void
		{
			removeEntity(curHeroEntity);
			reduceStar("hero");
			if(helpHero){
				var heroItem:HeroItem = helpHero.getHeroItem();
				heroItem.pos_x = homeCastleEntity.x;
				heroItem.pos_y = homeCastleEntity.y;
				var helpHeroEntity:AutoHeroEntity = new AutoHeroEntity(heroItem,this,true);
				curScene.addEntity(helpHeroEntity);
				soldierVec.push(helpHeroEntity);
			}
		}
		private function reduceStar(type:String):void
		{
			battleStar --;
			curScene.starbar.setPoint(battleStar);
			if(type == "hero"){
				curScene.showTip(LanguageController.getInstance().getString("herodeadtip"));
			}else if(type == "time"){
				curScene.showTip(LanguageController.getInstance().getString("timeisouttip"));
			}
			
		}
		public function removeEntity(entity:GameEntity):void
		{
			removeEntityFromList(entity);
			curScene.removeEntity(entity);
		}
		public function removeEntityFromList(entity:GameEntity):void
		{
			if(soldierVec.indexOf(entity) > -1 ){
				soldierVec.splice(soldierVec.indexOf(entity),1);
			}else if(monsterVec.indexOf(entity) > -1 ){
				monsterVec.splice(monsterVec.indexOf(entity),1);
			}
		}
		
		//arm
		public function initArms():void
		{
			clearArms();
			
		}
		public function addArm(arm:ArmObject):void
		{
			curScene.armLayer.addChild(arm);
			armsArr.push(arm);
		}
		public function removeArm(arm:ArmObject):void
		{
			if(armsArr.indexOf(arm) >= 0){
				armsArr.splice(armsArr.indexOf(arm),1);
			}
		}
		
		private function clearArms():void
		{
			var arm:ArmObject;
			for each(arm in armsArr){
				arm.dispose();
			}
			armsArr = [];
		}
		
		public function get isPvp():Boolean
		{
			return !(RightPlayer is MonsterPlayer) && !(RightPlayer is BossPlayer);
		}
	}
}