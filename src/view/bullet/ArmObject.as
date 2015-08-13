package view.bullet
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	import view.entity.GameEntity;

	public class ArmObject extends Sprite
	{
		protected var armSurface:Image;
		protected var hurt:int = 1;
		protected var fromPoint:Point;
		protected var isLeft:Boolean;
		protected var rule:BattleRule;
		protected var level:int;
		public function ArmObject(_rule:BattleRule,_fromPoint:Point,_hurtV:int,_level:int,_isLeft:Boolean)
		{
			rule = _rule;
			level = _level;
			fromPoint = _fromPoint;
			hurt = _hurtV;
			isLeft = _isLeft;
			x = fromPoint.x;
			y = fromPoint.y;
		}
		
		public function refresh():void
		{
			
		}
		public function attack():void
		{
			
		}
		protected function get enemyCastle():GameEntity
		{
			if(isLeft){
				return rule.enemyCastleEntity;
			}else {
				return rule.homeCastleEntity;
			}
		}
		override public function dispose():void
		{
			rule.removeArm(this);
			if(armSurface){
				armSurface.removeFromParent(true);
			}
			removeFromParent();
			super.dispose();
		}
		
	}
}