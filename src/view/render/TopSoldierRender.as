package view.render
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.CreatMonsterData;
	import model.gameSpec.ItemSpec;
	
	import starling.core.RenderSupport;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class TopSoldierRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		public function TopSoldierRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var creatData:CreatMonsterData;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			creatData = value as CreatMonsterData;
			if(creatData){
				if(container){
					container.removeFromParent(true);
				}
				configContainer();
			}
		}
		
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			super.render(support,parentAlpha);
			if(creatData && creatData.creatCD>0){
				configCDpart();
			}
		}
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			
			
			var itemspec:ItemSpec = creatData.itemSpec;
			if(itemspec){
				var icon:Image = new Image(itemspec.iconTexture);
				var s:Number =  Math.min(renderwidth*0.8/icon.width,renderHeight*0.8/icon.height) ;
				icon.scaleY = icon.scaleX = s;
				container.addChild(icon);
				icon.x = renderwidth*0.5 - icon.width/2;
				icon.y = renderHeight*0.5 - icon.height/2;
			}
			
		}
		private var cdIcon:Image;
		private function configCDpart():void
		{
			if(!cdIcon){
				cdIcon = new Image(Game.assets.getTexture("DPanelSkin"));
				cdIcon.width = renderwidth;
				cdIcon.alpha = 0.5;
				
			}
			if(container){
				container.addChild(cdIcon);
			}
			
			cdIcon.height = renderHeight * creatData.cdProgress;
			cdIcon.y = renderHeight - cdIcon.height;
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
