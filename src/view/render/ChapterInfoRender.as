package view.render
{
	import controller.GameController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.battle.BattleItem;
	import model.gameSpec.BattleItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import view.compenent.ThreeStarBar;

	public class ChapterInfoRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public var itemspec:BattleItemSpec;
		public var battleType:String;
		public function ChapterInfoRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var battleItem:BattleItem;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			battleItem = value as BattleItem;
			if(value ){
				itemspec = battleItem.item;
				battleType = battleItem.type;
				if(container){
					container.removeFromParent(true);
				}
				configLayout();
			}
			super.data = battleItem;
		}
		private var skintexture:Texture;
		private var countTexture:Texture;
		private var countTexture1:Texture;
		override public function invalidate(flag:String = INVALIDATION_FLAG_ALL):void
		{
			super.invalidate(flag);
		}
		private function configLayout():void
		{
			renderwidth = width;
			renderHeight = height;
			container = new Sprite;
			
			var newId:String = (battleType == Configrations.Ordinary_type)?itemspec.item_id:itemspec.getSupId();
			var battleData:OwnedItem = player.getBattleItem(newId);
			
			var checkStar:int = battleData.count;
			
			var skinCls:String = "DPanelSkin";
			if(checkStar >0){
				skinCls = "BPanelSkin";
			}else if(newId == player.getLastId(battleType)){
				skinCls = "RPanelSkin";
			}
			
			skintexture = Game.assets.getTexture(skinCls);
			var skin:Image = new Image(skintexture);
			skin.width = renderwidth;
			skin.height = renderHeight;
			container.addChild( skin);
			
			var icon:Image = new Image(itemspec.standTexture);
			var s:Number = Math.min(renderwidth*0.6/icon.width,renderHeight*0.6/icon.height);
			icon.scaleX = icon.scaleY = s;
			container.addChild(icon);
			icon.x = renderwidth/2 - icon.width/2;
			icon.y = renderHeight/2-icon.height/2;
			
			
			var index1:int = (int(itemspec.item_id)+1)%10;
			countTexture = LanguageController.getInstance().getNumberTexture(index1,LanguageController.NUMBERFONT_ORANGE);
			var countIcon:Image = new Image(countTexture);
			countIcon.width = renderwidth*0.4;
			countIcon.height=renderHeight*0.4;
			container.addChild( countIcon);
			countIcon.x = renderwidth*0.3;
			countIcon.y = renderHeight*0.2;
			var index2:int = int((int(itemspec.item_id)+1)%100 /10);
			if(index2>0){
				countTexture1=LanguageController.getInstance().getNumberTexture(index2,LanguageController.NUMBERFONT_ORANGE);
				var countIcon1:Image = new Image(countTexture1);
				countIcon1.width = renderwidth*0.3;
				countIcon1.height=renderHeight*0.4;
				container.addChild( countIcon1);
				
				countIcon.width = renderwidth*0.3;
				countIcon.x = renderwidth*0.5;
				countIcon1.x = renderwidth*0.2;
				countIcon1.y = renderHeight*0.2;
				
			}
			
			var bar:ThreeStarBar;
			if(checkStar >0){
				bar = new ThreeStarBar(checkStar,renderwidth*0.8);
			}else if(newId == player.getLastId(battleType)){
				bar = new ThreeStarBar(0,renderwidth*0.8);
			}else{
				battleItem.beReady = false;
			}
			if(bar){
				container.addChild(bar);
				bar.x = renderwidth*0.1;
				bar.y = renderHeight*0.6;
			}
			addChild(container);
			
			
		}
		
		private function get player():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		
		override public function dispose():void
		{
			if(skintexture){
				skintexture.dispose();
				skintexture = null;
			}
			if(countTexture){
				countTexture.dispose();
				countTexture = null;
			}
			if(countTexture1){
				countTexture1.dispose();
				countTexture1 = null;
			}
			
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			
			super.dispose();
		}
	}
				
}