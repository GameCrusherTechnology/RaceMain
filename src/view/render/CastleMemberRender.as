package view.render
{
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.entity.SoldierData;
	import model.gameSpec.ItemSpec;
	import model.gameSpec.SoldierItemSpec;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	public class CastleMemberRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function CastleMemberRender()
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
			var itemspec:SoldierItemSpec = SpecController.instance.getItemSpec(itemid) as SoldierItemSpec;
			if(itemspec){
				var spSkin:Image = new Image(Game.assets.getTexture("TitleTextSkin"));
				container.addChild(spSkin);
				var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight*0.15,itemspec.cname,0xffffff,renderHeight*0.12);
				nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(nameText);
				nameText.y =  renderHeight*0.05;
				nameText.x =  renderwidth/2 - nameText.width/2;
				
				spSkin.width = nameText.width + 10*scale;
				spSkin.height = renderHeight*0.15;
				spSkin.x = renderwidth/2 - spSkin.width/2;
				spSkin.y = renderHeight*0.05;
				
				var curLevel:int = hero.getSoldierItem(itemspec.item_id).count;
				var soldierData:SoldierData = new SoldierData(itemspec, curLevel);
				var icon:Image = new Image(itemspec.iconTexture);
				var s:Number =  Math.min(renderwidth*0.65/icon.width,renderHeight*0.65/icon.height) ;
				icon.scaleY = icon.scaleX = s;
				container.addChild(icon);
				icon.x = renderwidth*0.35 - icon.width/2 ;
				icon.y = renderHeight*0.23 ;
				
				var lvIcon:Image = new Image(Game.assets.getTexture("expIcon"));
				lvIcon.width = lvIcon.height = renderwidth*0.2;
				container.addChild(lvIcon);
				lvIcon.x = icon.x;
				lvIcon.y = icon.y;
				
				var lvText:TextField = FieldController.createSingleLineDynamicField(lvIcon.width,lvIcon.height,String(curLevel),0x000000,25);
				container.addChild(lvText);
				lvText.x = lvIcon.x;
				lvText.y = lvIcon.y;
				
				var aicon:Image = new Image(Game.assets.getTexture("AttackTipIcon"));
				aicon.width = aicon.height = renderHeight*0.15;
				container.addChild(aicon);
				aicon.x = icon.x + icon.width + 2*scale ;
				aicon.y = icon.y  ;
				
				var aText:TextField = FieldController.createSingleLineDynamicField(renderwidth*0.5,aicon.height,String(soldierData.attackPoint),0xff6666,aicon.height*0.8);
				aText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(aText);
				aText.x = aicon.x + aicon.width + 2*scale ;
				aText.y = aicon.y  ;
				
				
				var hicon:Image = new Image(Game.assets.getTexture("HealthTipIcon"));
				hicon.width = hicon.height = aicon.height;
				container.addChild(hicon);
				hicon.x = aicon.x ;
				hicon.y = aicon.y + aicon.height + 2*scale ;
				
				var hText:TextField = FieldController.createSingleLineDynamicField(renderwidth*0.5,hicon.height,String(soldierData.healthPoint),0x2317D0,hicon.height*0.8);
				hText.hAlign = HAlign.LEFT;
				container.addChild(hText);
				hText.x = hicon.x + hicon.width + 2*scale ;
				hText.y = hicon.y  ;
				
				var asicon:Image = new Image(Game.assets.getTexture("AttackSpeedIcon"));
				asicon.width = asicon.height = aicon.height;
				container.addChild(asicon);
				asicon.x = aicon.x ;
				asicon.y = hicon.y + hicon.height + 2*scale ;
				
				var asText:TextField = FieldController.createSingleLineDynamicField(renderwidth*0.5,asicon.height,String(soldierData.attackSpeedT),0x33ff33,asicon.height*0.8);
				asText.hAlign = HAlign.LEFT;
				container.addChild(asText);
				asText.x = asicon.x + asicon.width + 2*scale;
				asText.y = asicon.y  ;
				
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


