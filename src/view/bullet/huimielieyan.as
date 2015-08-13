package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import view.entity.GameEntity;
	
	public class huimielieyan extends ArmObject
	{
		private const RANGE:int = 250;
		public function huimielieyan(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("huimielieyan"));
			armSurface.scaleX = _isleft?BattleRule.cScale:-BattleRule.cScale;
			armSurface.scaleY = BattleRule.cScale;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = _isleft?-armSurface.width/2:armSurface.width/2;
			armSurface.y = -armSurface.height;
			y = rule.boundRect.bottom + armSurface.height*0.2;
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
			var tween:Tween;
			if(!isLeft){
				targets = rule.soldierVec;
			}else{
				targets = rule.monsterVec;
			}
			for each(targetSoldier in targets){
				if(inRange(targetSoldier)){
					targetSoldier.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/huimielieyan"));
					
					tween = new Tween(targetSoldier,0.5);
					if(isLeft){
						tween.moveTo(targetSoldier.x + 100*BattleRule.cScale,targetSoldier.y);
					}else{
						tween.moveTo(targetSoldier.x - 100*BattleRule.cScale,targetSoldier.y);
					}
					tween.onComplete = function():void{
						Starling.juggler.remove(tween);
					};
					Starling.juggler.add(tween);
				}
			}
			armSurface.removeEventListener(Event.COMPLETE,onEnterComplete);
			removeFromParent();
			Starling.juggler.remove(armSurface as MovieClip);
			super.dispose();
		}
		
	}
}

