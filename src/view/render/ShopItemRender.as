package view.render
{
	import controller.FieldController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.item.OwnedItem;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class ShopItemRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function ShopItemRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var ownedItem:OwnedItem;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value){
				ownedItem = value as OwnedItem;
				if(container){
					container.removeFromParent(true);
				}
				
				configContainer();
			}
		}
		
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			
			var icon:Image = new Image(ownedItem.itemSpec.iconTexture);
			icon.width = renderwidth*0.6;
			icon.scaleY = icon.scaleX;
			container.addChild(icon);
			icon.x = renderwidth*0.1;
			icon.y = renderHeight*0.1;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,ownedItem.itemSpec.cname,0x000000,15);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(nameText);
			nameText.y = renderHeight - nameText.height - 5*scale;
			
		}
		
		override public function dispose():void
		{
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			super.dispose();
		}
	}
}

