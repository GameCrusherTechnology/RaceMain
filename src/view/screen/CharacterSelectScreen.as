package view.screen
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import service.command.hero.HeroLoginCommand;
	
	import starling.display.Image;
	import starling.events.Event;
	
	import view.panel.CharacterCreatPanel;
	import view.render.CharacterChooseRender;

	public class CharacterSelectScreen extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var scale:Number;
		private var list:List;
		private var confirmPanel:Button;
		public function CharacterSelectScreen()
		{
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			scale = Configrations.ViewScale;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth;
			backSkin.height = panelheight;
			
			const listLayout: HorizontalLayout= new HorizontalLayout();
			listLayout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.gap = panelwidth*0.02;
			
			
			list = new List();
			list.layout = listLayout;
			list.dataProvider = getListCoarr();
			list.itemRendererFactory =function tileListItemRendererFactory():CharacterChooseRender
			{
				var renderer:CharacterChooseRender = new CharacterChooseRender();
				renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
				renderer.width = panelwidth *0.2;
				renderer.height = panelheight *0.4;
				return renderer;
			}
			list.width =  panelwidth*0.7;
			list.height =  panelheight *0.45;
			this.addChild(list);
			list.x = panelwidth*0.15;
			list.y = panelheight*0.2;
			list.addEventListener(Event.CHANGE,onListChangeHandle);
			
			if(player.user_characters.length<=0){
				showCreatPanel();
			}
		}
		
		private function showCreatPanel():void
		{
			creatPanel =new CharacterCreatPanel();
			DialogController.instance.showPanel(creatPanel);
			creatPanel.addEventListener(Event.CLOSE,onCreatClose);
		}
		private var creatPanel:CharacterCreatPanel;
		private function onCreatClose(e:Event):void
		{
			refresh();
			creatPanel.removeEventListener(Event.CLOSE,onCreatClose);
			creatPanel = null;
		}
		public function refresh():void
		{
			list.dataProvider = getListCoarr();
			list.validate();
		}
		
		private function getListCoarr():ListCollection
		{
			var arr:Array = player.user_characters.concat();
			if(Configrations.HeroCost.length >arr.length){
				arr.push("creat");
			}
			return new ListCollection(arr);
		}
		
		private var isLogining:Boolean;
			
		private function onListChangeHandle(e:Event):void
		{
			if(!isLogining){
				if(list.selectedItem is GamePlayer){
					new HeroLoginCommand((list.selectedItem as GamePlayer),onLogin);
					isLogining = true;
					
				}else if(list.selectedItem == "creat"){
					showCreatPanel();
				}
				list.selectedIndex = -1;
			}
		}
		private function onLogin():void
		{
			isLogining = false;
			this.removeFromParent(true);
		}
		private function get player():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}