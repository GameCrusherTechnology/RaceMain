package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;

	public class zhangxinlei extends ArmObject
	{
		private var speed:int = 5*BattleRule.cScale;
		public function zhangxinlei(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("zhangxinlei"));
			armSurface.scaleX = armSurface.scaleY = BattleRule.cScale/3;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height/2;
			Starling.juggler.add(armSurface as MovieClip);
		}
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			curTarget = isLeft?rule.monsterVec[0]:rule.soldierVec[0];
			if(curTarget){
				if(isLeft){
					x += speed;
					if(x > curTarget.x){
						attack();
					}
				}else{
					x -= speed;
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
			return Math.round(hurt*(0.5*level/10+1.5));
		}
		override public function attack():void
		{
			if(curTarget){
				curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/zhangxinlei"));
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


