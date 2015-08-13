package model.gameSpec
{
	import gameconfig.LanguageController;
	
	import starling.textures.Texture;

	public class ItemSpec
	{
		public function ItemSpec(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in ItemSpec: ItemSpec["+str+"]="+data[str]);
				}
			}
			
		}
		public var group_id:String;
		public var item_id:String;
		public var name:String;
		public var coin:int = 1000;
		public var gem:int = 10;
		public var level:int;
		
		public var message:String;
		public function get cname():String
		{
			var str:String =  LanguageController.getInstance().getString(name);
			if(!str || str==""){
				str = name;
			}
			return str;
		}
		
		public function get iconTexture():Texture
		{
			return Game.assets.getTexture(name+"Icon");
		}
	}
}