package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	
	public class guangjian extends ArmObject
	{
		private var arrowSpeed:int = 15*BattleRule.cScale;
		private var thunderTime:int;
		public function guangjian(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("guangjian"));
			armSurface.scaleX = _isleft?BattleRule.cScale*0.5:-BattleRule.cScale*0.5;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = _isleft?-armSurface.width/2:armSurface.width/2;
			armSurface.y = -armSurface.height/2;
			Starling.juggler.add(armSurface as MovieClip);
		}
		
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			if(thunderTime>1){
				thunderTime --;
			}else if(thunderTime==1){
				curTarget.removeBuffed("thunder");
				dispose();
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
			curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/guangjian"));
			curTarget.beBuffed("thunder");
			
			thunderTime = timeArr[level];
			Starling.juggler.remove(armSurface as MovieClip);
			armSurface.removeFromParent(true);
		}
		
	}
}
