package model.staticData
{
	import controller.SpecController;
	
	import model.gameSpec.SkillItemSpec;

	public class SkillData
	{
		public var skillSpec:SkillItemSpec;
		public var useTime:int;
		private var skillId:String ;
		public var level:int;
		
		public function SkillData(id:String,_level:int)
		{
			skillId = id;
			level = _level;
			skillSpec = SpecController.instance.getItemSpec(skillId) as SkillItemSpec;
		}
		
		public function canUse():Boolean
		{
			return useTime>= skillSpec.recycle;
		}
		
		public function get skillCls():Class
		{
			return skillSpec.skillCls;
		}
	}
}