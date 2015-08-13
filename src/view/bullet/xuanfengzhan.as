package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;

	public class xuanfengzhan extends ArmObject
	{
		private const RANGE:int = 200;
		public function xuanfengzhan(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("xuanfengzhan"));
			armSurface.scaleX = _isleft?BattleRule.cScale*0.8:-BattleRule.cScale*0.8;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = _isleft?-armSurface.width/2:armSurface.width/2;
			armSurface.y = -armSurface.height/2;
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
			return Math.round(hurt*(2*level/10+1));
		}
		override public function attack():void
		{
			var targetSoldier:GameEntity ;
			if(!isLeft){
				targetSoldier = rule.soldierVec[0];
			}else{
				targetSoldier = rule.monsterVec[0];
			}
			if(targetSoldier && inRange(targetSoldier)){
				targetSoldier.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/xuanfengzhan"));
			}
			armSurface.removeEventListener(Event.COMPLETE,onEnterComplete);
			removeFromParent();
			Starling.juggler.remove(armSurface as MovieClip);
			super.dispose();
		}
		
	}
}
