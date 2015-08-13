package view.render
{
	import controller.FieldController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.CharacterItemSpec;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class CharacterSelectRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		private var spec:CharacterItemSpec;
		public function CharacterSelectRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			super.data = value;
			if(value is CharacterItemSpec){
				spec = value as CharacterItemSpec;
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				configLayout();
			}
		}
		
		
		override public function invalidate(flag:String = INVALIDATION_FLAG_ALL):void
		{
			configSelectLayout(_isSelected);
			super.invalidate(flag);
		}
		private var selectSkin:Image;
		private var okIcon:Image;
		private function configSelectLayout(bool:Boolean):void
		{
			if(bool){
				if(!selectSkin){
					selectSkin = new Image(Game.assets.getTexture("SelectedFilter"));
					selectSkin.alpha = 0.3;
					selectSkin.width = renderwidth;
					selectSkin.height = renderHeight;
				}
				if(container && !selectSkin.parent){
					container.addChildAt( selectSkin,1);
				}
				
				if(!okIcon){
					okIcon = new Image(Game.assets.getTexture("ReOKICON"));
					okIcon.width = okIcon.height = renderHeight*0.2;
					okIcon.x = renderwidth/2 - okIcon.width/2;
					okIcon.y = renderHeight- okIcon.height;
				}
				if(container && !okIcon.parent){
					container.addChild( okIcon);
				}
				
			}else{
				if(selectSkin){
					selectSkin.removeFromParent();
				}
				if(okIcon){
					okIcon.removeFromParent();
				}
			}
			
		}
		private function configLayout():void
		{
			renderwidth = width;
			renderHeight = height;
			container = new Sprite;
			
			var textSkin:Image = new Image(Game.assets.getTexture( "TitleTextSkin"));
			textSkin.width = renderwidth*0.8;
			textSkin.x = renderwidth*0.1;
			container.addChild( textSkin);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,spec.cname,0xffffff,30,true);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild( nameText);
			nameText.y = renderHeight*0.1;
			
			textSkin.height = nameText.height*1.2;
			textSkin.y = nameText.y-nameText.height*0.1;
			
			var icon:Image = new Image(Game.assets.getTexture(spec.name + "HeadIcon"));
			icon.width = icon.height = Math.min(renderHeight*0.7,renderwidth*0.7);
			icon.x = renderwidth/2 - icon.width/2;
			icon.y = renderHeight/2 - icon.height/2;
			container.addChild( icon);
			
			addChild(container);
			
			
		}
	}
}


