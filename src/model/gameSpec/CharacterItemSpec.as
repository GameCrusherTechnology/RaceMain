package model.gameSpec
{
	import starling.textures.Texture;
	
	public class CharacterItemSpec extends SoldierItemSpec
	{
		public function CharacterItemSpec(data:Object)
		{
			super(data);
		}
		
		override public function get iconTexture():Texture
		{
			return Game.assets.getTexture(name+"Icon");
		}
	}
}