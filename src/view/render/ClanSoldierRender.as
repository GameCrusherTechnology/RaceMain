package view.render
{
	import controller.FieldController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.clan.ClanMemberData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class ClanSoldierRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function ClanSoldierRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var memberData:ClanMemberData;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value){
				memberData = value as ClanMemberData;
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
			
			var icon:Image = new Image(Game.assets.getTexture(memberData.heroData.characterSpec.name+"Icon"));
			icon.width = renderwidth*0.8;
			icon.scaleY = icon.scaleX;
			container.addChild(icon);
			icon.x = renderwidth*0.1;
			icon.y = renderHeight*0.1;
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = 30*scale;
			container.addChild(expIcon);
			expIcon.x = 5*scale;
			expIcon.y = 5*scale;
			
			var expText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,expIcon.height,String(memberData.heroData.level),0x000000,15,true);
			container.addChild(expText);
			expText.x = expIcon.x;
			expText.y = expIcon.y;
			
			var nameText:TextField = FieldController.createNoFontField(renderwidth,renderHeight,memberData.heroData.name,0x000000,15);
			nameText.autoSize = TextFieldAutoSize.VERTICAL;
			container.addChild(nameText);
			nameText.y = renderHeight - nameText.height - 5*scale;
			
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

