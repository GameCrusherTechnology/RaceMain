package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	
	public class jiguangjian extends ArmObject
	{
		private var arrowSpeed:int = 10*BattleRule.cScale;
		public function jiguangjian(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean=true)
		{
			armSurface = new MovieClip(Game.assets.getTextures("jiguangjian"));
			armSurface.scaleX = _isleft?BattleRule.cScale/3:-BattleRule.cScale/3;
			armSurface.scaleY = BattleRule.cScale/3;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = _isleft?-armSurface.width:armSurface.width;
			Starling.juggler.add(armSurface as MovieClip);
			
			x = _isleft?(fromPoint.x + armSurface.width):(fromPoint.x - armSurface.width);
			
		}
		
		private var curTarget:GameEntity;
		override public function refresh():void
		{
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
			}else{
				dispose();
			}
			
		}
		private function gethurt():int 
		{
			return Math.round(hurt*(2*level/10+2));
		}
		override public function attack():void
		{
			if(curTarget){
				curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/jiguangjian"));
			}
			dispose();
		}
		
		override public function dispose():void
		{
			Starling.juggler.remove(armSurface as MovieClip);
			removeFromParent();
			super.dispose();
		}
		
	}
}

