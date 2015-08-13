package model.gameSpec
{
	import flash.utils.getDefinitionByName;
	
	import starling.textures.Texture;

	public class SkillItemSpec extends EntityItemSpec
	{
		public function SkillItemSpec(data:Object)
		{
			super(data);
			
		}
		override public function get iconTexture():Texture
		{
			return Game.assets.getTexture("skillIcon/" + name);
		}
		
		public function get skillCls():Class
		{
			return getDefinitionByName("view.bullet."+name) as Class;
		}
		
		public var buffName:String;
	}
}