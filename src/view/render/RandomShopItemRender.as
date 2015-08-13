package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.item.RandomShopItem;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class RandomShopItemRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function RandomShopItemRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var item:RandomShopItem;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value){
				item = value as RandomShopItem;
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
			
			var icon:Image = new Image(item.itemSpec.iconTexture);
			var s:Number =  Math.min(renderwidth*0.6/icon.width,renderHeight*0.6/icon.height) ;
			icon.scaleY = icon.scaleX = s;
			container.addChild(icon);
			icon.x = renderwidth*0.5 - icon.width/2;
			icon.y = renderHeight*0.5 - icon.height/2;
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,item.itemSpec.cname,0x000000,25);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(nameText);
			nameText.y =  5*scale;
			
			var countIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			countIcon.width = countIcon.height = 50*scale;
			container.addChild(countIcon);
			countIcon.x =  renderwidth*0.9 - countIcon.width;
			countIcon.y = renderHeight*0.5 - countIcon.height/2;
			var countText:TextField = FieldController.createSingleLineDynamicField(countIcon.width,countIcon.height,String(item.count),0x000000,25);
			container.addChild(countText);
			countText.x = countIcon.x;
			countText.y = countIcon.y;
			
			var spContainer:Sprite = new Sprite;
			var spSkin:Image = new Image(Game.assets.getTexture("TitleTextSkin"));
			spContainer.addChild(spSkin);
			
			if(item.beBought){
				var buylable:TextField = FieldController.createSingleLineDynamicField(200,renderHeight *0.15,LanguageController.getInstance().getString("Bought"),0xffffff,20,true);
				buylable.autoSize = TextFieldAutoSize.HORIZONTAL;
				spContainer.addChild(buylable);
				buylable.x = 10*scale;
				buylable.y = 2*scale;
				spSkin.width =  buylable.width + 20*scale;
				
				var grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter();
				grayscaleFilter.adjustSaturation(-1);
				filter = grayscaleFilter; 
			}else{
				var canBuy:Boolean = true;
				var iconImage:Image;
				var cost:int;
				if(item.useGem){
					iconImage = new Image(Game.assets.getTexture("GemIcon"));
					cost = item.cost;
					if(user.gem < cost){
						canBuy = false;
					}
				}else{
					iconImage = new Image(Game.assets.getTexture("CoinIcon"));
					cost = item.cost;
					if(user.coin < cost){
						canBuy = false;
					}
				}
				iconImage.width = iconImage.height = renderHeight *0.15;
				spContainer.addChild(iconImage);
				iconImage.x = 5*scale;
				var lable:TextField = FieldController.createSingleLineDynamicField(200,renderHeight *0.15,String(cost),canBuy?0xffffff:0xff0000,20,true);
				lable.autoSize = TextFieldAutoSize.HORIZONTAL;
				spContainer.addChild(lable);
				lable.x = iconImage.width + 5*scale;
				iconImage.y = lable.y = 2*scale;
				spSkin.width = iconImage.width + lable.width + 15*scale;
			}
			spSkin.height = renderHeight *0.15 + 5*scale;
			container.addChild(spContainer);
			spContainer.x = renderwidth/2 - spContainer.width/2;
			spContainer.y = renderHeight*0.75;
			
			
		}
		
		private function get user():GameUser
		{
			return GameController.instance.localPlayer;
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

