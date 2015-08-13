package view.render
{
	import controller.FieldController;
	import controller.SpecController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	import model.gameSpec.PieceItemSpec;
	import model.gameSpec.SkillItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.item.OwnedItem;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class BattleRewardRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		private var rewardItem:OwnedItem;
		public function BattleRewardRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			rewardItem = value as OwnedItem;
			if(rewardItem){
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
			
			var itemspec:ItemSpec = rewardItem.itemSpec;
			if(itemspec){
				var icon:Image = new Image(itemspec.iconTexture);
				var s:Number =  Math.min(renderwidth*0.8/icon.width,renderHeight*0.8/icon.height);
				icon.scaleX = icon.scaleY = s;
				icon.x = renderwidth/2 - icon.width/2;
				icon.y = renderHeight/2 - icon.height/2;
				container.addChild( icon);
				addChild(container);
				if(itemspec is SoldierItemSpec || itemspec is SkillItemSpec){
					var pieceIcon:Image = new Image(Game.assets.getTexture("RankIcon"));
					pieceIcon.width = icon.width/2;
					pieceIcon.scaleY = pieceIcon.scaleX;
					container.addChild(pieceIcon);
					pieceIcon.x = icon.x ;
					pieceIcon.y = renderHeight - pieceIcon.height ;
				}
				
				
				var text:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,rewardItem.count<=0?"×?":"×"+rewardItem.count ,0x000000,25,true);
				text.hAlign = HAlign.RIGHT;
				text.vAlign = VAlign.BOTTOM;
				container.addChild(text);
			}
		}
	}
	
}

