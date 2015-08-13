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
	
	public class PackageItemRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function PackageItemRender()
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
			if(itemspec){
				var icon:Image = new Image(itemspec.iconTexture);
				var s:Number =  Math.min(renderwidth*0.6/icon.width,renderHeight*0.6/icon.height) ;
				icon.scaleY = icon.scaleX = s;
				container.addChild(icon);
				icon.x = renderwidth*0.5 - icon.width/2;
				icon.y = renderHeight*0.5 - icon.height/2;
				if(itemspec is PieceItemSpec){
					var pieceIcon:Image = new Image(Game.assets.getTexture("RankIcon"));
					pieceIcon.width = icon.width/2;
					pieceIcon.scaleY = pieceIcon.scaleX;
					container.addChild(pieceIcon);
					pieceIcon.x = icon.x ;
					pieceIcon.y = icon.y ;
				}
				var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,itemspec.cname,0x000000,25);
				nameText.autoSize = TextFieldAutoSize.VERTICAL;
				container.addChild(nameText);
				nameText.y =  5*scale;
				
				
				var spSkin:Image = new Image(Game.assets.getTexture("TitleTextSkin"));
				container.addChild(spSkin);
				var textSp:Sprite = new Sprite;
				container.addChild(textSp);
				if(itemspec is PieceItemSpec){
					
					var needCount:int;
					var canCompose:Boolean;
					
					if(PieceItemSpec(itemspec).type == "skill"){
						needCount = hero.pieceUpdateSkillCount(PieceItemSpec(itemspec));
					}else{
						needCount = hero.pieceUpdateSoldierCount(PieceItemSpec(itemspec));
					}
					if(needCount == 0){
						canCompose = false;
					}else{
						if(ownedItem.count >= needCount){
							canCompose = true;
						}else{
							canCompose = false;
						}
					}
					var countText1:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,String(ownedItem.count),canCompose?0x00ff00:0xff0000,25);
					countText1.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					textSp.addChild(countText1);
					var countText2:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,"/" ,0xffffff,25);
					countText2.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					textSp.addChild(countText2);
					countText2.x = countText1.width;
					var countText3:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight, needCount == 0 ?"MAX":String(needCount),0xffffff,25);
					countText3.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
					textSp.addChild(countText3);
					countText3.x = countText2.x + countText2.width;
					
				}else{
					var countText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,String(ownedItem.count),0xffffff,25);
					countText.autoSize = TextFieldAutoSize.VERTICAL;
					textSp.addChild(countText);
				}
				
				spSkin.width = renderwidth*0.8;
				spSkin.height = textSp.height + 4*scale;
				spSkin.x = renderwidth*0.1;
				spSkin.y = renderHeight - spSkin.height - 5*scale;
				textSp.y = spSkin.y + 2*scale;
				textSp.x = renderwidth/2 - textSp.width/2;
			}
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

