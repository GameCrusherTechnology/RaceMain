package model.gameSpec
{
	import starling.textures.Texture;

	public class SoldierItemSpec extends EntityItemSpec
	{
		public function SoldierItemSpec(data:Object)
		{
			super(data);
		}
		
		public var lock:int = 0;
		
		override public function get iconTexture():Texture
		{
			return Game.assets.getTexture("soldierIcon/" + name);
		}
		
		public function get standTexture():Texture
		{
			return Game.assets.getTexture("standIcon/" + name+"_stand");
		}
		
		private var skillArr:Array = [];
		public function set curSkill(s:String):void
		{
			var skillarr:Array = s.split(";");
			if(skillarr.length>0){
				for each(var str:String in skillarr){
					skillArr.push(str);
				}
			}
		}
		public function getSkills(level:int):Array
		{
			var returnArr:Array = [];
			var str:String ;
			var arr:Array ;
			for each(str in skillArr){
				arr = str.split(":");
				if(int(arr[0])<level){
					returnArr.push(arr[1]);
				}
			}
			return returnArr;
		}
	}
}