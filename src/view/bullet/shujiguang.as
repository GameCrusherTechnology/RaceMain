package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;
	import view.entity.SoldierEntity;
	
	public class shujiguang extends ArmObject
	{
		private var hurtTargets:Array=[];
		public function shujiguang(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("shujiguang"));
			armSurface.scaleX = _isleft?BattleRule.cScale:-BattleRule.cScale;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = isLeft?-armSurface.width/2:armSurface.width/2;
			armSurface.y = -armSurface.height;
			y = rule.boundRect.bottom + armSurface.height*0.2;
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
			
		}
		private function onAdd(e:Event):void
		{
			findTarget();
			Starling.juggler.add(armSurface as MovieClip);
			armSurface.addEventListener(Event.COMPLETE,onEnterComplete);
		}
		private function onEnterComplete(e:Event):void
		{
			attack();
			findTarget();
		}
		
		private function gethurt():int 
		{
			return Math.round(hurt*(1*level/10+1));
		}
		private function findTarget():void
		{
			var targetSoldier:GameEntity ;
			var targets:Array;
			curTarget = null;
			if(!isLeft){
				targets = rule.soldierVec;
			}else{
				targets = rule.monsterVec;
			}
			for (var i:int = 0;i<targets.length;i++){
				targetSoldier = targets[i] ;
				if(targetSoldier is SoldierEntity && hurtTargets.indexOf(targetSoldier)<=-1){
					curTarget = targetSoldier;
					x = targetSoldier.x;
					hurtTargets.push(targetSoldier);
					break;
				}
			}
			if(!curTarget){
				dispose();
			}
		}
		
		private var curTarget:GameEntity;
		override public function attack():void
		{
			if(curTarget){
				curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/shujiguang"));
			}
		}
		
		override public function dispose():void
		{
			hurtTargets = [];
			armSurface.removeEventListener(Event.COMPLETE,onEnterComplete);
			removeFromParent();
			Starling.juggler.remove(armSurface as MovieClip);
			super.dispose();
		}
		
	}
}

