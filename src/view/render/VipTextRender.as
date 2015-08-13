package view.render
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.PieceItemSpec;
	import model.player.GamePlayer;
	import model.staticData.VipListData;
	import model.staticData.VipUsedData;
	
	import service.command.item.AddEnergyCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	
	import view.panel.ComposePanel;
	
	public class VipTextRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function VipTextRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var viplistData:VipListData;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			viplistData = value as VipListData;
			if(viplistData){
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
			
			
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth*0.6,renderHeight,LanguageController.getInstance().getString(viplistData.name)+"xxxxxxxxxxxxxxxxxxxx",0x000000,renderHeight*0.5);
			nameText.hAlign = HAlign.LEFT;
			container.addChild(nameText);
			nameText.x = renderwidth *0.02;
			
			
			if(viplistData.isCurLevel && (viplistData.name !=="energyAddTotal")){
				var curUseData:VipUsedData = GameController.instance.currentHero.dayCountData;
				
				var countText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,curUseData[viplistData.name],0xff0000,renderHeight*0.8);
				countText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(countText);
				countText.x = renderwidth*0.75 ;
				
				var countText1:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,"/"+viplistData.getData(),0x0000ff,renderHeight*0.8);
				countText1.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(countText1);
				countText1.x = countText.x + countText.width ;
				
				
			}else{
				var countText2:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,viplistData.getData(),0x000000,renderHeight*0.8);
				countText2.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(countText2);
				countText2.x = renderwidth*0.78 ;
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

