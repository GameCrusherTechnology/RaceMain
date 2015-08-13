package view.render
{
	import controller.FieldController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.item.OwnedItem;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	
	public class RewardListRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function RewardListRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var ownedItem:OwnedItem;
		private var isshowing:Boolean;
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
			
			var texture:Texture;
			if(ownedItem.item_id == "exp"){
				texture = Game.assets.getTexture("expIcon");
			}else if(ownedItem.item_id == "coin"){
				texture = Game.assets.getTexture("CoinIcon");
			}else if(ownedItem.item_id == "score"){
				texture = Game.assets.getTexture("BattleScoreIcon");
			}else{
				texture = ownedItem.itemSpec.iconTexture;
			}
			
			var icon:Image = new Image(texture);
			icon.width = renderwidth*0.5;
			icon.scaleY = icon.scaleX;
			container.addChild(icon);
			icon.x = renderwidth*0.25;
			icon.y = renderHeight*0.2;
			
			var countText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,"×" + ownedItem.count,0x000000,25);
			countText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(countText);
			countText.y = icon.y + icon.height;
			
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
