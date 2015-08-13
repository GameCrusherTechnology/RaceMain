package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.item.TreasureItem;
	import model.player.GameUser;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class TreasureItemRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function TreasureItemRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var item:TreasureItem;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value){
				item = value as TreasureItem;
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
			
			var textSkin:Image = new Image(Game.assets.getTexture( "TitleTextSkin"));
			textSkin.width = renderwidth*0.8;
			textSkin.x = renderwidth*0.1;
			textSkin.y = renderHeight *0.02;
			textSkin.height = renderHeight*0.15;
			container.addChild( textSkin);
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight*0.15,LanguageController.getInstance().getString(item.name),0xffffff,renderHeight*0.1);
			container.addChild(nameText);
			nameText.y =  textSkin.y;
			
			var vipText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight*0.1,"×"+String(item.vip),0x000000,renderHeight*0.08);
			vipText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(vipText);
			vipText.x = renderwidth*0.95 -vipText.width  ;
			vipText.y = renderHeight*0.2;
			
			var vipIcon:Image = new Image(Game.assets.getTexture("vipIcon"));
			vipIcon.width = vipIcon.height = renderHeight*0.1;
			container.addChild(vipIcon);
			vipIcon.x = vipText.x -  vipIcon.width;
			vipIcon.y = renderHeight*0.2;
			
			
			var icon:Image = new Image(Game.assets.getTexture(item.name));
			var s:Number =  Math.min(renderwidth*0.5/icon.width,renderHeight*0.5/icon.height) ;
			icon.scaleY = icon.scaleX = s;
			container.addChild(icon);
			icon.x = renderwidth*0.5 - icon.width/2;
			icon.y = renderHeight*0.25 ;
			
			
			
			var countText:TextField = FieldController.createSingleLineDynamicField(200,renderHeight*0.12,"×"+String(item.number),0x000000,renderHeight*0.1);
			countText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(countText);
			countText.x = renderwidth*0.5 - countText.width/2;
			countText.y = renderHeight*0.7;
			
			
			var shopBut:Button = new Button();
			shopBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			shopBut.label = item.suffer + " "+item.price;
			shopBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, renderHeight*0.1, 0x000000);
			shopBut.paddingLeft = shopBut.paddingRight = 20*scale;
			shopBut.height = renderHeight*0.15;
			container.addChild(shopBut);
			shopBut.validate();
			shopBut.x = renderwidth*0.5 - shopBut.width/2;
			shopBut.y = renderHeight - shopBut.height ;
			
			
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

