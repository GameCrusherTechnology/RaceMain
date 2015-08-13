package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.display.Image;
	
	import view.entity.GameEntity;
	
	public class fireBullet extends ArmObject
	{
		private var arrowSpeed:int = 10*BattleRule.cScale;
		private var range:int =500;
		public function fireBullet(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean=true)
		{
			armSurface = new Image(Game.assets.getTexture("fireBullet"));
			armSurface.scaleX = _isleft?BattleRule.cScale*0.3:-BattleRule.cScale*0.3;
			armSurface.scaleY = BattleRule.cScale;
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			addChild(armSurface);
			armSurface.x = _isleft?-armSurface.width/2:armSurface.width/2;
			
		}
		
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			curTarget = isLeft?rule.monsterVec[0]:rule.soldierVec[0];
			if(!curTarget){
				curTarget = enemyCastle;
			}
			if(curTarget){
				if(isLeft){
					x += arrowSpeed;
					if(x > curTarget.x){
						attack();
					}else if(x > (range*BattleRule.cScale + fromPoint.x))
					{
						dispose();
					}
				}else{
					x -= arrowSpeed;
					if(x < curTarget.x){
						attack();
					}else if(x < (fromPoint.x - range*BattleRule.cScale))
					{
						dispose();
					}
				}
			}else{
				dispose();
			}
			
		}
		
		override public function attack():void
		{
			if(curTarget){
				curTarget.beAttacked(hurt,Game.assets.getTexture("skillIcon/fireBullet"),"attack");
			}
			dispose();
		}
		
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
		
	}
}

