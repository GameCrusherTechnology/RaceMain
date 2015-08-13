package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	
	import view.entity.GameEntity;
	import view.entity.SoldierEntity;
	
	public class icebird extends ArmObject
	{
		private var speed:int = 8*BattleRule.cScale;
		private var endP:Number = 0;
		private var eLength:int = 1000*BattleRule.cScale;
		private var entitys:Array = [];
		private var curHurt:int;
		public function icebird(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isleft:Boolean)
		{
			armSurface = new MovieClip(Game.assets.getTextures("icebird"));
			armSurface.scaleX = _isleft?BattleRule.cScale*0.8:-BattleRule.cScale*0.8;
			armSurface.scaleY = BattleRule.cScale*0.8;
			endP = _isleft?(_fromPoint.x+eLength):(_fromPoint.x - eLength);
			super(_rule,_fromPoint,_hurtV,_level,_isleft);
			
			addChild(armSurface);
			armSurface.x = -armSurface.width/2;
			armSurface.y = -armSurface.height;
			Starling.juggler.add(armSurface as MovieClip);
			curHurt = Math.round(hurt*(1*level/10+2));
			
			y = rule.boundRect.bottom + armSurface.height/5;
			
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
				curTarget.beAttacked(curHurt,Game.assets.getTexture("skillIcon/icebird"));
				armSurface.scaleX = armSurface.scaleX*0.8;
				armSurface.scaleY = armSurface.scaleY*0.8;
				armSurface.alpha = armSurface.alpha*0.8;
				curHurt = Math.round(curHurt*0.8);
			}
		}
		
	}
}
