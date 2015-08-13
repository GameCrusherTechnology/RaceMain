package model.entity
{
	import flash.utils.getDefinitionByName;
	
	import controller.SpecController;
	
	import model.gameSpec.EntityItemSpec;
	
	import view.bullet.Sword;

	public class EntityItem
	{
		
		public function EntityItem(data:Object)
		{
			var str:String;
			for(str in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in Item: EntityItem["+str+"]="+data[str]);
				}
			}
			setEntity();
		}
		protected function setEntity():void
		{
			itemSpec = SpecController.instance.getItemSpec(item_id) as EntityItemSpec;
			if(itemSpec){
				life = totalLife = itemSpec.baseLife + itemSpec.lifeUp*level;
				if(itemSpec){
					armClass = getDefinitionByName("view.bullet."+itemSpec.armCls) as Class;
				}
				
				attckPoint = itemSpec.baseAttack + level*itemSpec.attackUp;
				
				speed = itemSpec.speed;
				range = itemSpec.range;
			}
			
		}
		
		public var item_id:String;
		public var itemSpec:EntityItemSpec;
		
		
		public var pos_x:Number = 0;
		public var pos_y:Number = 0;
		
		public var speed:Number = 10;
		public var range:int = 20;
		
		public var attckPoint:Number = 20;
		public var life:Number = 0;
		
		public var totalLife:Number = 1;
		public var level:int =0 ;
		
		
		public function get isDead():Boolean
		{
			return life <= 0;
		}
		
		public var armClass:Class = Sword;
		
		protected var ownedskills:Array =[];
		protected var usedskills:Array =[];
	}
}