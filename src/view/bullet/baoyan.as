package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;
	
	public class baoyan extends ArmObject
	{
		private const RANGE:int = 250;
		public function baoyan(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("baoyan"));
			armSurface.scaleX = _isleft?BattleRule.cScale:-BattleRule.cScale;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = _isleft?-armSurface.width/2:armSurface.width/2;
			armSurface.y = -armSurface.height*3/4;
			y = rule.boundRect.bottom;
			Starling.juggler.add(armSurface as MovieClip);
			armSurface.addEventListener(Event.COMPLETE,onEnterComplete);
		}
		
		private function onEnterComplete(e:Event):void
		{
			attack();
		}
		
		private function inRange(entity:GameEntity):Boolean
		{
			if(Math.abs(fromPoint.x - entity.x)< RANGE*BattleRule.cScale){
				return true
			}
			return false;
		}
		private function gethurt():int 
		{
			return Math.round(hurt*(1*level/10+1.5));
		}
		override public function attack():void
		{
			var targetSoldier:GameEntity ;
			var targets:Array;
			if(!isLeft){
				targets = rule.soldierVec;
			}else{
				targets = rule.monsterVec;
			}
			for each(targetSoldier in targets){
				if(inRange(targetSoldier)){
					targetSoldier.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/baoyan"));
				}
			}
			armSurface.removeEventListener(Event.COMPLETE,onEnterComplete);
			removeFromParent();
			Starling.juggler.remove(armSurface as MovieClip);
			super.dispose();
		}
		
	}
}
