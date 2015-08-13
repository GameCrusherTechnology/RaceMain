package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	
	public class huoyanjian extends ArmObject
	{
		private var arrowSpeed:int = 15*BattleRule.cScale;
		private var fireTime:int ;
		private var fireCount:int = 5;
		public function huoyanjian(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("huoyanjian"));
			armSurface.scaleX = _isleft?BattleRule.cScale*0.3:-BattleRule.cScale*0.3;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = _isleft?-armSurface.width:armSurface.width;
			armSurface.y = -armSurface.height/2;
			Starling.juggler.add(armSurface as MovieClip);
			
			x = _isleft?(_fromPoint.x + armSurface.width/2):(_fromPoint.x - armSurface.width/2);
			
		}
		
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			if(fireTime>1){
				fireTime --;
			}else if(fireTime==1){
				if(fireCount>0){
					if(curTarget && !curTarget.isDead){
						curTarget.beAttacked(getFirehurt(),Game.assets.getTexture("skillIcon/huoyanjian"));
					}
					fireTime = 30;
					fireCount--;
				}else{
					curTarget.removeBuffed("fire");
					dispose();
				}
			}else{
				curTarget = isLeft?rule.monsterVec[0]:rule.soldierVec[0];
				if(curTarget){
					if(isLeft){
						x += arrowSpeed;
						if(x > curTarget.x){
							attack();
						}
					}else{
						x -= arrowSpeed;
						if(x < curTarget.x){
							attack();
						}
					}
				}
			}
			
		}
		private function getFirehurt():int 
		{
			return Math.round(hurt*(level/10+1)/3);
		}
		private function gethurt():int 
		{
			return Math.round(hurt*(level/10+1));
		}
		private function get timeArr():Array 
		{
			return [100,100,100,120,120,120,150,150,150];
		}
		
		override public function attack():void
		{
			curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/huoyanjian"));
			curTarget.beBuffed("fire");
			
			fireTime = 30;
			Starling.juggler.remove(armSurface as MovieClip);
			armSurface.removeFromParent(true);
		}
		
	}
}

