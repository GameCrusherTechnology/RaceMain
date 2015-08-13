package view.render
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.SpecController;
	
	import feathers.controls.List;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.TiledRowsLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.battle.BattleItem;
	import model.gameSpec.BattleItemSpec;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import view.panel.BattleInfoPanel;

	public class ChapterRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function ChapterRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var chapterNum:int;
		private var battletype:String;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value){
				chapterNum = int(value.id);
				battletype = value.type;
				if(container){
					container.removeFromParent(true);
				}
				
				configContainer();
			}
		}
		
		private var chapterInfolist:List;
		private var skinTexture:Texture;
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			
			const listLayout1: TiledRowsLayout= new TiledRowsLayout();
			listLayout1.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.paddingTop =listLayout1.paddingBottom= 20*scale;
			listLayout1.gap = 10*scale;
			chapterInfolist = new List();
			
			skinTexture = Game.assets.getTexture("WhiteSkin");
			var listSkin:Scale9Image =  new Scale9Image(new Scale9Textures(skinTexture,new Rectangle(2,2,60,60)));
			listSkin.alpha = 0.5;
			chapterInfolist.backgroundSkin =listSkin;
			chapterInfolist.layout = listLayout1;
			chapterInfolist.dataProvider = getChapterInfoListData();
			chapterInfolist.itemRendererFactory =function tileListItemRendererFactory():ChapterInfoRender
			{
				var renderer:ChapterInfoRender = new ChapterInfoRender();
				renderer.width = renderwidth *0.2;
				renderer.height = renderwidth *0.2;
				return renderer;
			}
			chapterInfolist.width =  renderwidth;
			chapterInfolist.height =  renderHeight;
			chapterInfolist.verticalScrollPolicy = List.SCROLL_POLICY_ON;
			chapterInfolist.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			container.addChild(chapterInfolist);
			chapterInfolist.addEventListener(Event.CHANGE,onchapterinfolistHandle);
		}
		
		private function getChapterInfoListData():ListCollection
		{
			var arr:Array = [];
			var index:int = 0;
			var spec:BattleItemSpec;
			while(index<100){
				spec = SpecController.instance.getItemSpec(String(chapterNum*100 + index)) as BattleItemSpec;
				if(spec){
					arr.push(new BattleItem({item:spec,type:battletype}));
				}else{
					break;
				}
				index++;
			}
			return new ListCollection(arr);
		}
		
		private function onchapterinfolistHandle(e:Event):void
		{
			var item:BattleItem = chapterInfolist.selectedItem as BattleItem;
			if(item){
				var spec:BattleItemSpec =item.item;
				if(item.beReady && spec){
					DialogController.instance.showPanel(new BattleInfoPanel(spec,item.type));
				}
				chapterInfolist.selectedIndex = -1;
			}
		}
		override public function dispose():void
		{
			if(skinTexture){
				skinTexture.dispose();
				skinTexture = null;
			}
			if(chapterInfolist){
				chapterInfolist.removeEventListener(Event.CHANGE,onchapterinfolistHandle);
				chapterInfolist.removeFromParent(true);
				chapterInfolist = null;
			}
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			super.dispose();
		}
	}
}