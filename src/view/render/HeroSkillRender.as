package view.render
{
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.ItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class HeroSkillRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function HeroSkillRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var itemid:String;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value){
				itemid = String(value);
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
			var itemspec:ItemSpec = SpecController.instance.getItemSpec(itemid);
			var skillItem:OwnedItem = hero.getSkillItem(itemid);
			if(itemspec){
				var icon:Image = new Image(itemspec.iconTexture);
				var s:Number =  Math.min(renderwidth*0.8/icon.width,renderHeight*0.8/icon.height) ;
				icon.scaleY = icon.scaleX = s;
				container.addChild(icon);
				icon.x = renderwidth*0.5 - icon.width/2 ;
				icon.y = renderHeight*0.1 ;
				
				var spSkin:Image = new Image(Game.assets.getTexture("TitleTextSkin"));
				container.addChild(spSkin);
				var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,itemspec.cname,0xffffff,20);
				nameText.autoSize = TextFieldAutoSize.VERTICAL;
				container.addChild(nameText);
				nameText.y =  6*scale;
				
				spSkin.width = renderwidth*0.8;
				spSkin.height = nameText.height + 4*scale;
				spSkin.x = renderwidth*0.1;
				spSkin.y = 5*scale;
				
				var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
				expIcon.width = expIcon.height = 30*scale;
				container.addChild(expIcon);
				expIcon.x = renderwidth - expIcon.width - 5*scale;
				expIcon.y = renderHeight - expIcon.height - 5*scale;
				
				var expText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,expIcon.height,String(skillItem.count),0x000000,15,true);
				container.addChild(expText);
				expText.x = expIcon.x;
				expText.y = expIcon.y;
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

