package view.compenent
{
	import controller.FieldController;
	
	import feathers.controls.Button;
	
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;

	public class SceneButton extends Button
	{
		private var filterSkin:Image;
		public function SceneButton(_name:String,skinCls:String,sx:Number,sy:Number)
		{
			
			filterSkin  =  new Image(Game.assets.getTexture(skinCls));
			filterSkin.scaleX = sx;
			filterSkin.scaleY = sy;
			filterSkin.filter = BlurFilter.createGlow(0xffff00, 2, 2.5);
			defaultSkin = filterSkin;
			name = _name;
			filterSkin.alpha = 0;
			
			var textSkin:Image = new Image(Game.assets.getTexture("BlackSkin"));
			textSkin.alpha = 0.8;
			addChild(textSkin);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(filterSkin.width,50,LanguageController.getInstance().getString(_name),0xffffff,20,true);
			nameText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(nameText);
			nameText.x = filterSkin.width/2-nameText.width/2;
			nameText.y = filterSkin.height -nameText.height/2 ;
			
			textSkin.width = nameText.width + 30*sx;
			textSkin.height = nameText.height + 5*sy;
			textSkin.x = nameText.x - 20*sx;
			textSkin.y = nameText.y - 2*sy;
			
			var textIcon :Image = new Image(Game.assets.getTexture("TableIcon"));
			addChild(textIcon);
			textIcon.width = textIcon.height = textSkin.height*1.5
			textIcon.x = textSkin.x - textIcon.width/2;
			textIcon.y = textSkin.y - textSkin.height*0.2;
		}
		
		public function showFilter():void
		{
			filterSkin.alpha = 0.8;
		}
		
		public function removeFilter():void
		{
			filterSkin.alpha = 0;
		}
	}
}