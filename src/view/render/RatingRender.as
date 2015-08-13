package view.render
{
	import controller.FieldController;
	import controller.GameController;
	import controller.SpecController;
	
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import gameconfig.Configrations;
	
	import model.clan.ClanBossData;
	import model.clan.ClanData;
	import model.gameSpec.ItemSpec;
	import model.player.GamePlayer;
	import model.staticData.RatingData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class RatingRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function RatingRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var rateData:Object;
		override public function set data(value:Object):void
		{
			super.data = rateData = value;
			if(rateData){
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
					container = null;
				}
				configLayout();
			}
		}
		private function configLayout():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			
			var icon:Image = new Image(Game.assets.getTexture("expIcon"));
			icon.width = icon.height = renderheight*0.8;
			container.addChild(icon);
			icon.x = 0;
			icon.y = renderheight*0.1;
			
			var rateText:TextField = FieldController.createSingleLineDynamicField(icon.width,icon.height,String(rateData.rate),0x000000,renderheight*0.5,true);
			container.addChild(rateText);
			rateText.x = icon.x;
			rateText.y = icon.y;
			
			if(rateData is ClanBossData){
				var clanData:ClanData = (rateData as ClanBossData).owner as ClanData;
				
				var clanicon:Image= new Image(Game.assets.getTexture("ClanIcon"));
				clanicon.height = renderheight*0.8;
				clanicon.scaleX = clanicon.scaleY;
				clanicon.x = renderheight*0.8;
				clanicon.y = renderheight*0.1;
				container.addChild(clanicon);
				
				var nameText:TextField = FieldController.createNoFontField(renderwidth,renderheight,clanData.name,0x000000,renderheight*0.5);
				nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(nameText);
				nameText.x = clanicon.x+ clanicon.width;
				
				var idText:TextField = FieldController.createNoFontField(renderwidth,renderheight,String(clanData.data_id),0xFF00FF,renderheight*0.5);
				idText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(idText);
				idText.x = renderwidth*0.4 ;
				
				var bossSpec:ItemSpec = SpecController.instance.getItemSpec(GameController.instance.currentHero.BossId);
				if(bossSpec){
					var bossicon:Image= new Image(bossSpec.iconTexture);
					bossicon.height = renderheight*0.8;
					bossicon.scaleX = bossicon.scaleY;
					bossicon.x = renderwidth*0.6;
					bossicon.y = renderheight*0.1;
					container.addChild(bossicon);
				}
				
				var levelText:TextField = FieldController.createNoFontField(renderwidth,renderheight,""+(rateData as ClanBossData).level,0x0000FF,renderheight*0.4);
				levelText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(levelText);
				levelText.x = renderwidth*0.75 ;
				
				var killText:TextField = FieldController.createNoFontField(renderwidth,renderheight,""+(rateData as ClanBossData).kills,0x0000FF,renderheight*0.4);
				killText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(killText);
				killText.x = renderwidth*0.9 ;
				
			} else{
				var heroData:GamePlayer = rateData.owner as GamePlayer;
				
				var heroicon:Image= new Image(Game.assets.getTexture(heroData.characterSpec.name+"HeadIcon"));
				heroicon.height = renderheight*0.8;
				heroicon.scaleX = heroicon.scaleY;
				heroicon.x = renderheight*0.8;
				heroicon.y = renderheight*0.1;
				container.addChild(heroicon);
				
				var heronameText:TextField = FieldController.createNoFontField(renderwidth,renderheight,heroData.name,0x000000,renderheight*0.5);
				heronameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(heronameText);
				heronameText.x = heroicon.x+ heroicon.width;
				
				var lvText:TextField = FieldController.createNoFontField(renderwidth,renderheight,"LV"+heroData.level,0xFF00FF,renderheight*0.5);
				lvText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(lvText);
				lvText.x = renderwidth*0.4 ;
				
				var clanNmae:String;
				if(heroData.clanData){
					clanNmae = clanData.name;
				}else{
					clanNmae = "------";
				}
				var clanNameText:TextField = FieldController.createNoFontField(renderwidth,renderheight,clanNmae,0x000000,renderheight*0.5);
				clanNameText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(clanNameText);
				clanNameText.x = renderwidth*0.55 ;
				
				var scoreText:TextField = FieldController.createNoFontField(renderwidth,renderheight,""+rateData.score,0x0000FF,renderheight*0.4);
				scoreText.autoSize = TextFieldAutoSize.HORIZONTAL;
				container.addChild(scoreText);
				scoreText.x = renderwidth*0.8 ;
			}
			
			
		}
	}
}
