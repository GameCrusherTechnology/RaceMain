package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	import model.gameSpec.PieceItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class ComposeItemRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function ComposeItemRender()
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
			
			var hero:GamePlayer = GameController.instance.currentHero;
			var itemspec:ItemSpec = ownedItem.itemSpec;
			var icon:Image = new Image(itemspec.iconTexture);
			var s:Number =  Math.min(renderwidth*0.6/icon.width,renderHeight*0.6/icon.height) ;
			icon.scaleY = icon.scaleX = s;
			container.addChild(icon);
			icon.x = renderwidth*0.5 - icon.width/2;
			icon.y = renderHeight*0.5 - icon.height/2;
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,itemspec.cname,0x000000,25);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(nameText);
			nameText.y =  5*scale;
			
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
