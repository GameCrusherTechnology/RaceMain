package model.gameSpec
{
	public class EntityItemSpec extends ItemSpec
	{
		public function EntityItemSpec(data:Object)
		{
			super(data);
		}
		
		public var speed:Number = 2;
		public var recycle:int = 100;
		public var range:int =10;
		
		public var baseLife:Number = 1;
		public var lifeUp:Number = 1;
		
		public var attackCycle:int = 100;
		public var baseAttack:Number = 20;
		public var attackUp:Number = 20;
		
		public var armCls:String = "Sword";
		
		
		public var boundItem:String;
		public var upCount:String;
		
		public var 	runx:Number=0;
		public var	runy:Number=0;
		public var	attackx:Number = 0;
		public var 	attacky:Number=0;
		public var 	standx:Number=0;
		public var 	standy:Number=0;
		public var 	rectw:Number=100;
		public var 	recty:Number=100;
		
	}
}