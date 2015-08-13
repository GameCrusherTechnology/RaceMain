package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	import model.staticData.VipData;
	import model.staticData.VipListData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.compenent.GreenProgressBar;
	
	public class VipRender extends DefaultListItemRenderer
	{
		private var renderscale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		
		public function VipRender()
		{
			super();
			renderscale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var vipdata:VipData;
		private var itemList:List;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			vipdata = value as VipData;
			if(vipdata ){
				if(container){
					container.removeFromParent(true);
				}
				configLayout();
			}
		}
		
		
		
		private function configLayout():void
		{
			
			var hero:GamePlayer = GameController.instance.currentHero;
			var myLevel:int = hero.vipLevel;
			
			container = new Sprite;
			
			var skin:Image =  new Image(Game.assets.getTexture("SelectRenderSkin"));
			container.addChild(skin);
			skin.width =renderwidth;
			skin.height = renderHeight;
			
			
			
			var textSkin:Image = new Image(Game.assets.getTexture( "TitleTextSkin"));
			textSkin.width = renderwidth*0.8;
			textSkin.x = renderwidth*0.1;
			textSkin.y = renderHeight *0.05;
			textSkin.height = renderHeight*0.1;
			container.addChild( textSkin);
			
			
			var vipIcon:Image = new Image(Game.assets.getTexture("vipIcon"));
			vipIcon.width = vipIcon.height = renderHeight*0.15;
			container.addChild(vipIcon);
			vipIcon.x = renderwidth*0.1 ;
			
			var isCurLevel:Boolean = false;
			if(vipdata.level == hero.vipLevel){
				isCurLevel = true;
			}
			var nameText:TextField = FieldController.createNoFontField(400,renderHeight*0.1,"VIP ",isCurLevel?0xE03F1C:0xffffff,renderHeight*0.08);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild( nameText);
			nameText.x = renderwidth/2 - nameText.width/2;
			nameText.y = textSkin.y;
			
			var vl:Image = new Image(LanguageController.getInstance().getNumberTexture(vipdata.level,isCurLevel?LanguageController.NUMBERFONT_ORANGE:LanguageController.NUMBERFONT_DARKBLUE));
			vl.height = renderHeight*0.1;
			vl.scaleX = vl.scaleY;
			container.addChild(vl);
			vl.x = nameText.x+nameText.width;
			vl.y = nameText.y ;
			
			if(vipdata.level > 0){
				var progress:GreenProgressBar = new GreenProgressBar(renderwidth*0.6,renderHeight*0.06,2);
				container.addChild(progress);
				progress.x = renderwidth*0.2;
				progress.y = renderHeight*0.18;
				progress.progress = hero.vip/vipdata.totalExp;
				progress.comment = hero.vip + "/" + (vipdata.totalExp);
			}
			
			const listLayout1: VerticalLayout= new VerticalLayout();
			listLayout1.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout1.gap = renderHeight *0.02;
			
			itemList = new List();
			itemList.layout = listLayout1;
			itemList.dataProvider = getListData(isCurLevel);
			itemList.itemRendererFactory =function tileListItemRendererFactory():VipTextRender
			{
				var renderer:VipTextRender = new VipTextRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("ListRenderSkin"));
				renderer.width = renderwidth *0.9;
				renderer.height = renderHeight *0.1;
				return renderer;
			}
			itemList.width =  renderwidth*0.95;
			itemList.height =  renderHeight *0.7;
			container.addChild(itemList);
			itemList.x = renderwidth*0.025;
			itemList.y = renderHeight*0.25;
			
			
//			configText("energyAddTotal",String(vipdata.energyAddTotal),renderHeight*0.26);
//			configText("tradeMoneyCount",String(vipdata.tradeMoneyCount),renderHeight*0.32);
//			configText("useEnergyCount",String(vipdata.useEnergyCount),renderHeight*0.38);
//			configText("useCardCount",String(vipdata.useCardCount),renderHeight*0.44);
//			configText("inviteFriendCount",String(vipdata.inviteFriendCount),renderHeight*0.5);
//			configText("pkAddCount",String(vipdata.pkAddCount),renderHeight*0.56);
			addChild(container);
			
		}
		
		private function getListData(_isCurLevel:Boolean):ListCollection
		{
			var arr:Array = ["energyAddTotal","tradeMoneyCount","useEnergyCount","useCardCount","inviteFriendCount","pkAddCount"];
			var newArr:Array = [];
			var listdata:VipListData;
			for each(var str:String in arr){
				listdata = new VipListData({name:str,vipData:vipdata,isCurLevel:_isCurLevel});
				newArr.push(listdata);
			}
			return new ListCollection(newArr);
		}
		private function configText(name:String,count:String,y:Number):void
		{
			var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight*0.06,name + ": ",0x000000,renderHeight*0.05);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x = renderwidth *0.1;
			nameText.y = y;
			
			var countText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight*0.06,count,0x000000,renderHeight*0.05);
			countText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(countText);
			countText.x = nameText.x + nameText.width ;
			countText.y = y;
		}
		
		
	}
}
