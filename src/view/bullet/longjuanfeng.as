package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.SoldierEntity;
	
	public class longjuanfeng extends ArmObject
	{
		private var speed:int = 5*BattleRule.cScale;
		private var endP:Number = 0;
		private var eLength:int = 1000*BattleRule.cScale;
		private var entitys:Array = [];
		public function longjuanfeng(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("longjuanfeng"));
			armSurface.scaleX = armSurface.scaleY = BattleRule.cScale*0.6;
			endP = _isleft?(_fromPoint.x+eLength):(_fromPoint.x - eLength);
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height;
			Starling.juggler.add(armSurface as MovieClip);
			
			y = rule.boundRect.bottom + armSurface.height/8;
		}
		private var curTarget:GameEntity;
		override public function refresh():void
		{
			var targets:Array = isLeft?rule.monsterVec:rule.soldierVec;
			var entity:GameEntity;
			if(isLeft){
				x += speed;
				if(x > endP){
					end();
				}else {
					for each(entity in targets){
						if(entity.x <= x && entitys.indexOf(entity)<0){
							curTarget = entity ;
							entitys.push(entity);
							attack();
							break;
						}
					}
				}
			}else{
				x -= speed;
				if(x < endP){
					end();
				}else{
					for each(entity in targets){
						if(entity.x >= x && entitys.indexOf(entity)<0){
							curTarget = entity ;
							entitys.push(entity);
							attack();
							break;
						}
					}
				}
			}
		}
		private function gethurt():int 
		{
			return Math.round(hurt*(1*level/10+1.5));
		}
		private function end():void
		{
			removeFromParent(true);
			Starling.juggler.remove(armSurface as MovieClip);
			entitys = [];
			curTarget = null;
			super.dispose();
		}
		override public function attack():void
		{
			if(curTarget is SoldierEntity){
				curTarget.beAttacked(gethurt(),Game.assets.getTexture("skillIcon/longjuanfeng"));
				armSurface.alpha = armSurface.alpha*0.8;
			}
		}
		
	}
}

