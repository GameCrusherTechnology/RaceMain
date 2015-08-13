package view.render
{
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.player.GamePlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	public class HeroChooseRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		private var character:GamePlayer;
		private var isCreat:Boolean = false;
		public function HeroChooseRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value ){
				
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
				}
				
				if(value is GamePlayer){
					character = value as GamePlayer;
					isCreat = false;
					configHeroLayout();
				}else{
					isCreat = true;
					configNewLayout();
				}
			}
		}
		
		
		
		private function configHeroLayout():void
		{
			container = new Sprite;
			
			var textSkin:Image = new Image(Game.assets.getTexture( "TitleTextSkin"));
			textSkin.width = renderwidth*0.8;
			textSkin.x = renderwidth*0.1;
			container.addChild( textSkin);
			
			var nameText:TextField = FieldController.createNoFontField(400,400,character.name,0xffffff,renderHeight*0.1);
			nameText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			container.addChild( nameText);
			nameText.x = renderwidth/2 - nameText.width/2;
			nameText.y = renderHeight*0.05;
			
			textSkin.height = nameText.height*1.2;
			textSkin.y = nameText.y-nameText.height*0.1;
			
			
			var icon:Image = new Image(Game.assets.getTexture(character.characterSpec.name + "HeadIcon"));
			icon.width = icon.height = Math.min(renderHeight*0.7,renderwidth*0.7);
			icon.x = renderwidth/2 - icon.width/2;
			icon.y = renderHeight/2 - icon.height/2;
			container.addChild( icon);
			
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = 50*scale;
			container.addChild(expIcon);
			expIcon.x = icon.x + icon.width - expIcon.width/3*2;
			expIcon.y = icon.y +icon.height - expIcon.height/3*2;
			
			var expText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,expIcon.height,String(character.level),0x000000,15,true);
			container.addChild(expText);
			expText.x = expIcon.x;
			expText.y = expIcon.y;
			
			addChild(container);
			
			if(character.characteruid != GameController.instance.currentHero.characteruid){
				var creatButton:Button = new Button();
				creatButton.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
				creatButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
				creatButton.label = LanguageController.getInstance().getString("select");
				creatButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				creatButton.paddingLeft =creatButton.paddingRight =  20;
				creatButton.paddingTop = creatButton.paddingBottom =  5;
				container.addChild(creatButton);
				creatButton.validate();
				creatButton.x = renderwidth/2 - creatButton.width/2;
				creatButton.y = renderHeight -creatButton.height- renderHeight*0.05;
			}
		}
		
		
		private function configNewLayout():void
		{
			container = new Sprite;
			
			var icon:Image = new Image(Game.assets.getTexture("NewHeroIcon"));
			icon.scaleX = icon.scaleY = scale;
			icon.x = renderwidth/2 - icon.width/2;
			icon.y = renderHeight*0.25;
			container.addChild( icon);
			
			addChild(container);
			
			var creatButton:Button = new Button();
			creatButton.defaultSkin = new Image(Game.assets.getTexture("R_button"));
			creatButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
			creatButton.label = LanguageController.getInstance().getString("creat");
			creatButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			creatButton.paddingLeft =creatButton.paddingRight =  20;
			creatButton.paddingTop =creatButton.paddingBottom =  5;
			addChild(creatButton);
			creatButton.validate();
			creatButton.x = renderwidth/2 - creatButton.width/2;
			creatButton.y = renderHeight -creatButton.height -  renderHeight*0.05;
			
			
		}
	}
}
