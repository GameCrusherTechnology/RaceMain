package model.gameSpec
{
	import starling.textures.Texture;

	public class PieceItemSpec extends EntityItemSpec
	{
		public function PieceItemSpec(data:Object)
		{
			super(data);
		}
		
		public var type:String;
		
		override public function get iconTexture():Texture
		{
			if(type == "skill"){
				return Game.assets.getTexture("skillIcon/" + name);
			}else if(type == "soldier"){
				return Game.assets.getTexture("soldierIcon/" + name);
			}
			return Game.assets.getTexture( name+"Icon");
		}
	}
}

