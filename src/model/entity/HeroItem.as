package model.entity
{
	import model.gameSpec.SoldierItemSpec;
	import model.item.OwnedItem;
	import model.staticData.SkillData;

	public class HeroItem extends SoldierItem
	{
		public function HeroItem(_data:Object)
		{
			super(_data);
		}
		
		override protected function setSkill():void
		{
			var skillData:SkillData;
			var skillId:String;
			var level:int = 1;
			var item:OwnedItem;
			for each(skillId in usedskills){
				for each(item in ownedskills){
					if(item.item_id == skillId){
						level = item.count;
						break;
					}
				}
				skillData = new SkillData(skillId,level);
				skills.push(skillData);
			}
		}
		
	}
}