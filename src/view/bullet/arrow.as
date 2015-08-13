package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.display.Image;
	
	import view.entity.GameEntity;

	public class arrow extends ArmObject
	{
		private var arrowSpeed:int = 20*BattleRule.cScale;
		public function arrow(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean=true)
		{
			armSurface = new Image(Game.assets.getTexture("SimpleArrow"));
			armSurface.scaleX = _isleft?BattleRule.cScale*0.5:-BattleRule.cScale*0.5;
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
		
		override public function attack():void
		{
			if(curTarget){
				curTarget.beAttacked(hurt,Game.assets.getTexture("skillIcon/arrow"),"attack");
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