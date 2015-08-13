package model.entity
{
	import model.gameSpec.SoldierItemSpec;
	import model.staticData.SkillData;

	public class SoldierItem extends EntityItem
	{
		
		public var skills:Array =[];
		public function SoldierItem(_data:Object)
		{
			super(_data);
			setSkill();
		}
		
		protected function setSkill():void
		{
			var skillArr:Array = (itemSpec as SoldierItemSpec).getSkills(level);
			var skillData:SkillData;
			var skillId:String;
			for each(skillId in skillArr){
				skillData = new SkillData(skillId,1);
				skills.push(skillData);
			}
			
		}
	}
}