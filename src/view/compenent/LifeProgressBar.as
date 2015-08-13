package view.compenent
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class LifeProgressBar extends Sprite
	{
		private var lifeProgress:Image;
		private var barWidth:Number;
		public function LifeProgressBar(w:Number,h:Number=0)
		{
			barWidth = w;
			var skin:Image = new Image(Game.assets.getTexture("ProgressBarBlack"));
			skin.width = w;
			if(h>0){
				skin.height= h;
			}else{
				skin.scaleY = skin.scaleX;
			}
			addChild(skin);
			
			lifeProgress = new Image(Game.assets.getTexture("ProgressBar"));
			lifeProgress.width = w;
			lifeProgress.height= h;
			addChild(lifeProgress);
		}
		
		public function showProgress(p:Number):void
		{
			if(p > 1){
				p = 1;
			}else if(p<0){
				p = 0;
			}
			lifeProgress.width = barWidth*p;
			
		}
	}
}