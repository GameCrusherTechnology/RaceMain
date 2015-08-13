package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;
	
	public class lanyan extends ArmObject
	{
		private const RANGE:int = 250;
		private const lengTh:int = 200;
		public function lanyan(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("lanyan"));
			armSurface.scaleX = _isleft?BattleRule.cScale*0.8:-BattleRule.cScale*0.8;
			armSurface.scaleY = BattleRule.cScale*0.8;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			x = _isleft?(fromPoint.x + lengTh*BattleRule.cScale):(fromPoint.x - lengTh*BattleRule.cScale);
			y = rule.boundRect.bottom + armSurface.height/6 ;
			addChild(armSurface);
			armSurface.x = _isleft?-armSurface.width/2:armSurface.width/2;
			armSurface.y = -armSurface.height;
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
					targetSoldier.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/lanyan"));
				}
			}
			armSurface.removeEventListener(Event.COMPLETE,onEnterComplete);
			removeFromParent();
			Starling.juggler.remove(armSurface as MovieClip);
			super.dispose();
		}
		
	}
}

