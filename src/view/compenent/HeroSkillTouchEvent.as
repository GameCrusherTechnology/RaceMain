package view.compenent
{
	import model.gameSpec.SkillItemSpec;
	
	import starling.events.Event;

	public class HeroSkillTouchEvent extends Event
	{
		public static const trigger:String = "SkillTrigger";
		public var skill:SkillItemSpec;
		public function HeroSkillTouchEvent(skillId:SkillItemSpec)
		{
			skill = skillId;
			super(trigger);
		}
	}
}