package view.entity
{
	
	import flash.geom.Point;
	
	import gameconfig.EntityState;
	
	import model.battle.BattleRule;
	import model.entity.SoldierItem;
	import model.staticData.SkillData;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;

	public class SoldierEntity extends GameEntity
	{
		protected var state:String;
		public function SoldierEntity(_item:SoldierItem,rule:BattleRule,_isLeft:Boolean)
		{
			super(_item,rule,_isLeft);
			scaleX = scaleY =  BattleRule.cScale ;
		}
		
		override protected function creatSurface():void
		{
			showState(EntityState.WALK);
			checkSkill();
		}
		
		
		protected function showState(_state:String,animotion:Boolean = true):void
		{
			if(state != _state){
				state = _state;
				
				playAnimotion(state);
			}else if(_state == EntityState.ATTACK && animotion){
				(surface as MovieClip).currentFrame = 0;
				(surface as MovieClip).play();
			}
		}
		protected function playAnimotion(_state:String):void
		{
			if(surface){
				surface.removeFromParent(true);
				Starling.juggler.remove(surface as MovieClip);
			}
			surface = new MovieClip(Game.assets.getTextures(item.itemSpec.name+"_"+_state),12);
			
			var px:Number = 0;
			var py:Number = 0;
			switch(_state){
				case EntityState.WALK:
					px = item.itemSpec.runx;
					py = item.itemSpec.runy;
					break;
				case EntityState.ATTACK:
					(surface as MovieClip).loop = false;
					px = item.itemSpec.attackx;
					py = item.itemSpec.attacky;
					break;
				case EntityState.STAND:
					px = item.itemSpec.standx;
					py = item.itemSpec.standy;
					break;
				
			}
			
			if(isLeft){
				surface.x = -px;
				surface.y = -py;
			}else{
				surface.scaleX = - 1;
				surface.x = px;
				surface.y = -py;
			}
			addChild(surface);
			Starling.juggler.add(surface as MovieClip);
			
		}
		
		private var curTarget:GameEntity;
		protected var curSkill:SkillData;
		override public function validate():void
		{
			attackCD --;
			if(!curTarget ||curTarget.isDead ){
				curTarget = findTarget();
			}
			if(!curTarget){
				if(canMove){
					walk();
				}
			}else{
				if(attackCD <=0){
					if(canAttack){
						attack();
					}
				}else{
					showState(EntityState.ATTACK,false);
					
				}
			}
			validateSkill();
		}
		
		protected function findTarget():GameEntity
		{
			var entity:GameEntity;
			if(enemyVec.length>=1){
				entity = enemyVec[0];
			}else{
				if(isLeft){
					entity = battleRule.enemyCastleEntity;
				}else{
					entity = battleRule.homeCastleEntity;
				}	
			}
			if(inRange(entity.x)){
				return entity;
			}else{
				return null;
			}
			
		}
		private function get enemyVec():Array
		{
			return isLeft?battleRule.monsterVec:battleRule.soldierVec;
		}
		protected function walk():void
		{
			showState(EntityState.WALK);
			var sx:Number = isLeft?soldierItem.speed:-soldierItem.speed;
			x +=(sx*BattleRule.cScale);
		}
		
		public function move(p:Point):void
		{
			x = x+p.x;
			y = y+p.y;
		}
		
		private var attackCD:int ;
		protected function attack():void
		{
			showState(EntityState.ATTACK);
			attackCD = soldierItem.itemSpec.attackCycle;
			
			if(curSkill && curSkill.canUse()){
				battleRule.addArm(new curSkill.skillCls(battleRule,new Point(x,y - item.itemSpec.recty/2),getCurAttackPoint(),curSkill.level,isLeft));
				curSkill.useTime = 0;
				curSkill = null;
			}else{
				battleRule.addArm(new item.armClass(battleRule,new Point(x,y - item.itemSpec.recty/2),getCurAttackPoint(),1,isLeft));
			}
			curTarget = null;
		}
		override public function beAttacked(hurt:Number, texture:Texture, type:String="skill"):void
		{
			super.beAttacked(hurt,texture,type);
			checkSkill();
		}
		protected function checkSkill():void
		{
			if(!curSkill || !curSkill.canUse()){
				
				if(item.life <= item.totalLife && (item as SoldierItem).skills.length>0)
				{
					for each(var skillData:SkillData in (item as SoldierItem).skills)
					{
						if(skillData.canUse()){
							curSkill = skillData;
							break;
						}
					}
				}
			}
		}
		private function validateSkill():void
		{
			for each(var skillData:SkillData in (item as SoldierItem).skills)
			{
				skillData.useTime ++;
			}
		}
		protected function useSkill():void
		{
			
		}
		protected function inRange(targetX:Number):Boolean
		{
			if(curSkill){
				return Math.abs(targetX-x) <  curSkill.skillSpec.range*BattleRule.cScale;
			}else{
				return Math.abs(targetX-x) < soldierItem.range*BattleRule.cScale;
			}
		}
		
		protected function get soldierItem():SoldierItem
		{
			return item as SoldierItem;
		}
		
	}
}