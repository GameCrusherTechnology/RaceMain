package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PageIndicator;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import view.render.ChapterRender;

	public class BattleWorldPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var chapterlist:List;
		private var _pageIndicator:PageIndicator;
		private var titleText:TextField;
		private var curType:String = Configrations.Ordinary_type;
		private var typeBut:Button;
		private var backBut:Button;
		
		public function BattleWorldPanel()
		{
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			scale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.5;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth*0.8;
			backSkin.height = panelheight*0.8;
			backSkin.x = panelwidth*0.1;
			backSkin.y = panelheight*0.1;
			
			var titleSkin:Scale9Image = new Scale9Image(Configrations.PanelTitleSkinTexture);
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.8;
			titleSkin.height = panelheight*0.08;
			titleSkin.x = panelwidth*0.1;
			titleSkin.y = panelheight*0.1;
			
			titleText = FieldController.createSingleLineDynamicField(panelwidth,titleSkin.height," ",0xffffff,35,true);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			configList();			
			
			
			_pageIndicator = new PageIndicator();
			var normalSymbolTexture:Texture   = Game.assets.getTexture("YPanelSkin");
			var selectedSymbolTexture:Texture = Game.assets.getTexture("BPanelSkin");
			
			_pageIndicator.normalSymbolFactory = function():Image
			{
				var ig:Image = new Image(normalSymbolTexture);
				ig.width = ig.height = 10;
				return ig;
			}
			_pageIndicator.selectedSymbolFactory = function():Image
			{
				var ig:Image =  new Image(selectedSymbolTexture);
				ig.width = ig.height = 10;
				return ig;
			}
			_pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			_pageIndicator.pageCount = 1;
			_pageIndicator.gap = 3;
			_pageIndicator.paddingTop = _pageIndicator.paddingRight = _pageIndicator.paddingBottom =
				_pageIndicator.paddingLeft = 6;
			_pageIndicator.width = panelwidth*0.7;
			_pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);
			addChild(_pageIndicator);
			_pageIndicator.y =  panelheight *0.8;
			_pageIndicator.pageCount = chapterlist.dataProvider.length;
			_pageIndicator.x = panelwidth*0.5 - _pageIndicator.width/2;
			_pageIndicator.validate();
			
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			typeBut = new Button();
			typeBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
			typeBut.label = LanguageController.getInstance().getString("Ordinary");
			typeBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			typeBut.paddingLeft = typeBut.paddingRight = 20*scale;
			typeBut.height = panelheight*0.08;
			addChild(typeBut);
			typeBut.validate();
			typeBut.x = panelwidth*0.8 - typeBut.width/2;
			typeBut.y = panelheight*0.1;
			typeBut.addEventListener(Event.TRIGGERED,onTriggerType);
			
			configTitle();
			configScrollButton();
		}
		private function configList():void
		{
			const listLayout1:TiledRowsLayout = new TiledRowsLayout();
			listLayout1.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout1.useSquareTiles = false;
			listLayout1.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout1.tileVerticalAlign = TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE;
			listLayout1.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout1.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
			listLayout1.manageVisibility = true;
			if(!chapterlist){
//				chapterlist.removeEventListener(Event.CHANGE,onchapterlistHandle);
//				chapterlist.removeEventListener(Event.SCROLL,onchapterlistHandle);
//				chapterlist.dispose();
//				chapterlist = null;
				
				chapterlist = new List();
				chapterlist.layout = listLayout1;
				chapterlist.dataProvider = getChapterListData();
				chapterlist.snapToPages = true;
				chapterlist.itemRendererFactory =function tileListItemRendererFactory():ChapterRender
				{
					var renderer:ChapterRender = new ChapterRender();
					renderer.width = panelwidth *0.65;
					renderer.height = panelheight *0.6;
					return renderer;
				}
				chapterlist.selectedIndex = 0;
				chapterlist.width =  panelwidth*0.8;
				chapterlist.height =  panelheight *0.6;
				chapterlist.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				chapterlist.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
				addChild(chapterlist);
				chapterlist.x = panelwidth*0.1;
				chapterlist.y = panelheight*0.2;
				chapterlist.addEventListener(Event.CHANGE,onchapterlistHandle);
				chapterlist.addEventListener(Event.SCROLL,onchapterlistHandle);
				
			}else{
				chapterlist.dataProvider = getChapterListData();
				chapterlist.validate();
			}
		}
		private function configTitle():void
		{
			var itemspec:ItemSpec = SpecController.instance.getItemSpec(String(int(chapterlist.selectedItem.id) *100));
			titleText.text = itemspec.cname;
		}
		private var leftButton:Button;
		private var rightButton:Button;
		private function configScrollButton():void
		{
			if(!leftButton){
				leftButton = new Button();
				leftButton.defaultSkin = new Image(Game.assets.getTexture("leftArrowIcon"));
				leftButton.width = leftButton.height = panelwidth *0.07;
				leftButton.name = "left";
				addChild(leftButton);
				leftButton.x = panelwidth*0.105;
				leftButton.y = panelheight*0.4;
				leftButton.addEventListener(Event.TRIGGERED,onTriggleScroll);
			}
			if(chapterlist.horizontalPageIndex == 0){
				leftButton.touchable = false;
				leftButton.isEnabled = false;
				leftButton.filter = Configrations.grayscaleFilter;
			}else{
				leftButton.touchable = true;
				leftButton.isEnabled = true;
				leftButton.filter = null;
			}
			if(!rightButton){
				rightButton = new Button();
				rightButton.defaultSkin = new Image(Game.assets.getTexture("rightArrowIcon"));
				rightButton.width = rightButton.height = panelwidth *0.07;
				addChild(rightButton);
				rightButton.x = panelwidth*0.895-rightButton.width;
				rightButton.y = panelheight*0.4;
				rightButton.addEventListener(Event.TRIGGERED,onTriggleScroll);
			}
			if(chapterlist.horizontalPageIndex == chapterlist.dataProvider.length-1){
				rightButton.touchable = false;
				rightButton.isEnabled = false;
				rightButton.filter = Configrations.grayscaleFilter;
			}else{
				rightButton.touchable = true;
				rightButton.isEnabled = true;
				rightButton.filter = null;
			}
		}
		private function getChapterListData():ListCollection
		{
			var bid:int = 201;
			var index:int = 0;
			var arr:Array = [];
			var spec:ItemSpec;
			if(curType == Configrations.Ordinary_type){
				while( index < 100){
					spec =  SpecController.instance.getItemSpec(String((bid+index)*100));
					if(spec){
						arr.push({id:bid+index,type:curType});
					}else{
						break;
					}
					index ++;
				}
			}else{
				while( index < 100){
					spec =  SpecController.instance.getItemSpec(String((bid+index)*100));
					if(spec){
						arr.push({id:bid+index,type:curType});
					}else{
						break;
					}
					index ++;
				}
			}
			return new ListCollection(arr);
		}
		protected function pageIndicator_changeHandler(event:Event):void
		{
			chapterlist.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this.chapterlist.pageThrowDuration);
		}
		private var curIndex:int = 0;
		private function onchapterlistHandle(e:Event):void
		{
			if(curIndex != chapterlist.horizontalPageIndex){
				curIndex = chapterlist.horizontalPageIndex;
				_pageIndicator.selectedIndex = chapterlist.horizontalPageIndex;
				chapterlist.selectedIndex = curIndex;
				configTitle();
				configScrollButton();
			}
		}
		private function onTriggleScroll(e:Event):void
		{
			var but:Button = e.target as Button;
			if(but){
				if(but.name == "left"){
					chapterlist.scrollToPageIndex(chapterlist.horizontalPageIndex-1, 0, this.chapterlist.pageThrowDuration);
				}else{
					chapterlist.scrollToPageIndex(chapterlist.horizontalPageIndex+1, 0, this.chapterlist.pageThrowDuration);
				}
			}
		}
		private function onTriggerType(e:Event):void
		{
			if(curType == Configrations.Ordinary_type){
				curType = Configrations.Elite_type;
				typeBut.label = LanguageController.getInstance().getString(Configrations.Elite_type);
			}else{
				curType = Configrations.Ordinary_type;
				typeBut.label = LanguageController.getInstance().getString(Configrations.Ordinary_type);
			}
			typeBut.validate();
			typeBut.x = panelwidth*0.8 - typeBut.width/2;
			configList();
			
		}
		private function onTriggerBack(e:Event):void
		{
			removeFromParent(true);
		}
		private function get player():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		
		override public function dispose():void
		{
			removeEventListener(FeathersEventType.INITIALIZE, initializeHandler);
			leftButton.removeEventListener(Event.TRIGGERED,onTriggleScroll);
			leftButton.removeFromParent(true);
			
			rightButton.removeEventListener(Event.TRIGGERED,onTriggleScroll);
			rightButton.removeFromParent(true);
			backBut.removeEventListener(Event.TRIGGERED,onTriggerBack);
			backBut.removeFromParent(true);
			
			typeBut.removeEventListener(Event.TRIGGERED,onTriggerType);
			typeBut.removeFromParent(true);
			
			chapterlist.removeEventListener(Event.CHANGE,onchapterlistHandle);
			chapterlist.removeEventListener(Event.SCROLL,onchapterlistHandle);
			chapterlist.removeFromParent(true);
			chapterlist = null;
			
			_pageIndicator.removeEventListener(Event.CHANGE, pageIndicator_changeHandler);
			_pageIndicator.removeFromParent(true);
			_pageIndicator = null;
			super.dispose();
		}
	}
}