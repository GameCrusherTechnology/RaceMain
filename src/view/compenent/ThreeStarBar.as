package view.compenent
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;

	public class ThreeStarBar extends Sprite
	{
		private var texture:Texture;
		private var texture1:Texture;
		private var barW:Number;
		private var curScore:int = -1;
		public function ThreeStarBar(score:int,w:Number)
		{
			barW = w;
			texture = Game.assets.getTexture("ProgressStarIcon");
			texture1 = Game.assets.getTexture("BattleStarIcon");
			setPoint(score);
		}
		
		public function setPoint(p:int):void
		{
			if(p!= curScore){
				curScore = p;
				removeChildren();
				var index:int;
				while(index < p){
					var starIcon:Image = new Image(texture);
					addChild(starIcon);
					starIcon.width = barW/3;
					starIcon.height = barW/3;
					
					starIcon.x = index*barW/3;
					index++;
				}
				var grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter();
				grayscaleFilter.adjustSaturation(-1);
				while(index < 3){
					var starIcon1:Image = new Image(texture1);
					starIcon1.filter = grayscaleFilter; 
					addChild(starIcon1);
					starIcon1.width = barW/3;
					starIcon1.height = barW/3;
					
					starIcon1.x = index*barW/3;
					index++;
				}
			}
		}
			
		override public function dispose():void
		{
			texture.dispose();
			texture1.dispose();
			super.dispose();
		}
	}
}