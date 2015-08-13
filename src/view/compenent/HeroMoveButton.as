package view.compenent
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import view.entity.HeroEntity;
	
	public class HeroMoveButton extends Sprite
	{
		private var side:Number;
		private var moveLeft:Boolean;
		private var hero:HeroEntity;
		public function HeroMoveButton(_hero:HeroEntity,move:Boolean,_side:Number)
		{
			moveLeft = move;
			side = _side;
			hero = _hero;
			
			var back:Image = new Image(Game.assets.getTexture("BPanelSkin"));
			back.width = back.height = side;
			addChild(back);
			
			var icon:Image = new Image(Game.assets.getTexture(moveLeft?"leftArrowIcon":"rightArrowIcon"));
			icon.width = icon.height = side*0.8;
			addChild(icon);
			icon.x = icon.y = side*0.1;
			
			addEventListener(TouchEvent.TOUCH,onSkillTouched);
		}
		private function onSkillTouched(e:TouchEvent):void
		{
			if(hero && !hero.isDead){
				var touch:Touch = e.getTouch(this,TouchPhase.BEGAN);
				if(touch){
					trace("touch begin");
				}else{
					touch = e.getTouch(this,TouchPhase.ENDED);	
					if(touch){
						trace("touch end");
					}
				}
			}
		}
		
	}
}
