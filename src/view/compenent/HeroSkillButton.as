package view.compenent
{
	import model.gameSpec.SkillItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class HeroSkillButton extends Sprite
	{
		public var skillspec:SkillItemSpec;
		private var skillCD:int = 0;
		private var totalCD:int;
		private var backmode:Image;
		private var side:Number;
		public function HeroSkillButton(skillSpec:SkillItemSpec,_side:Number,_totalCD:int)
		{
			side = _side;
			skillspec = skillSpec;
			totalCD = _totalCD;
			var back:Image = new Image(Game.assets.getTexture("DPanelSkin"));
			back.width = back.height = side;
			addChild(back);
			
			backmode = new Image(Game.assets.getTexture("BPanelSkin"));
			backmode.width = backmode.height = side;
			addChild(backmode);
			
			var icon:Image = new Image(skillSpec.iconTexture);
			icon.width = icon.height = side*0.8;
			addChild(icon);
			icon.x = icon.y = side*0.1;
			
			touchable = false;
			addEventListener(TouchEvent.TOUCH,onSkillTouched);
		}
		private var isBegin:Boolean = false;
		private function onSkillTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.BEGAN);
			if(touch){
				isBegin = true;
			}
			
			touch = e.getTouch(this,TouchPhase.ENDED);	
			if(touch){
				if(isBegin){
					//do trigger
					doSkill();
				}
			}
			
		}
		
		private function doSkill():void
		{
			removeEvent();
			skillCD = 0;
			dispatchEvent(new HeroSkillTouchEvent(skillspec));
		}
		
		public function validate():void
		{
			if(skillCD<=totalCD){
				showcd();
				if(skillCD == totalCD){
					addEvenet(); 
				}
			}
			skillCD++;
		}
		
		private function addEvenet():void
		{
			touchable = true;
		}
		private function removeEvent():void
		{
			touchable = false;
		}
		public function showcd():void
		{
			backmode.height = side*(skillCD/totalCD);
			backmode.y = side - backmode.height;
		}
		
	}
}