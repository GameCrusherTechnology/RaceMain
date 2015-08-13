package view.render
{
	import controller.FieldController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.gameSpec.SoldierItemSpec;
	import model.staticData.EnemyData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class BattleEnemyRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		private var enemyData:EnemyData;
		public function BattleEnemyRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			enemyData = value as EnemyData;
			super.data = value;
			if(enemyData){
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				configLayout();
			}
		}
		override public function invalidate(flag:String = INVALIDATION_FLAG_ALL):void
		{
			super.invalidate(flag);
		}
		private function configLayout():void
		{
			renderwidth = width;
			renderHeight = height;
			container = new Sprite;
			addChild(container);
			var itemspec:SoldierItemSpec = enemyData.soldierSpec;
			if(itemspec){
				
				var skin:Image ;
				if(enemyData.isSuper){
					skin= new Image(Game.assets.getTexture("PanelRenderSkin"));
				}else{
					skin= new Image(Game.assets.getTexture("PanelBackSkin"));
				}
				skin.width = renderwidth;
				skin.height = renderHeight;
				container.addChild( skin);
				
				var icon:Image = new Image(itemspec.iconTexture);
				var s:Number =  Math.min(renderwidth*0.8/icon.width,renderHeight*0.8/icon.height);
				icon.scaleX = icon.scaleY = s;
				icon.x = renderwidth/2 - icon.width/2;
				icon.y = renderHeight/2 - icon.height/2;
				container.addChild( icon);
				
				
				var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
				container.addChild(expIcon);
				expIcon.width = expIcon.height = renderwidth*0.4;
				expIcon.x = renderwidth*0.6;
				expIcon.y = renderHeight - expIcon.height;
				
				
				var leveltext:TextField = FieldController.createSingleLineDynamicField(expIcon.width,expIcon.height,String(enemyData.level) ,0x000000,expIcon.height*0.8,true);
				container.addChild(leveltext);
				leveltext.x = expIcon.x;
				leveltext.y = expIcon.y;
			}
		}
	}
	
}
