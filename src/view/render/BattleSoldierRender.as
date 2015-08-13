package view.render
{
	import flash.net.Socket;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class BattleSoldierRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		private var itemSpec:ItemSpec;
		public function BattleSoldierRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = itemSpec = value as ItemSpec;
			if(itemSpec){
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
			super.invalidate(flag);
		}
		private var selectSkin:Image;
		private var okIcon:Image;
		private function configLayout():void
		{
			renderwidth = width;
			renderHeight = height;
			container = new Sprite;
			addChild(container);
			var player:GamePlayer = GameController.instance.currentHero;
			var icon:Image = new Image(itemSpec.iconTexture);
			var s:Number =  Math.min(renderwidth*0.7/icon.width,renderHeight*0.7/icon.height);
			icon.scaleX = icon.scaleY = s;
			icon.x = renderwidth/2 - icon.width/2;
			icon.y = renderHeight/2 - icon.height/2;
			container.addChild( icon);
			
			var levelIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			levelIcon.width = renderwidth/3;
			levelIcon.scaleY = levelIcon.scaleX;
			container.addChild( levelIcon);
			levelIcon.x = renderwidth - levelIcon.width;
			levelIcon.y = renderHeight- levelIcon.height;
			var item:OwnedItem;
			
			if(itemSpec is SoldierItemSpec){
				item = player.getSoldierItem(itemSpec.item_id);
			}else{
				item = player.getSkillItem(itemSpec.item_id);
			}
			var levelText:TextField = FieldController.createSingleLineDynamicField(levelIcon.width,levelIcon.height,String(item.count),0x000000,20,true);
			container.addChild( levelText);
			levelText.x = levelIcon.x;
			levelText.y = levelIcon.y;
		}
	}
	
}

