package view.render
{
	import controller.FieldController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Sprite;
	import starling.text.TextField;

	public class ChapterButtonRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function ChapterButtonRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value ){
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				
				var text:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,LanguageController.getInstance().getString("chapter")+ value as String,0x000000,35,true);
				addChild(text);
			}
		}
		
		
		
	}
}