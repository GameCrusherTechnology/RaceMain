package view.compenent
{
	import controller.FieldController;
	
	import gameconfig.Configrations;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;

	public class HurtTip extends Sprite
	{
		private var container:Sprite;
		public function HurtTip(iconTexture:Texture,hurt:int,isleft:Boolean,type:String="skill")
		{
			container = new Sprite;
			addChild(container);
			var backSkin:Image = new Image(Game.assets.getTexture("WhiteSkin"));
			backSkin.alpha = 0.5;
			container.addChild(backSkin);
			var tHeight:Number = 20*Configrations.ViewScale;
			var color:uint ;
			if(type){
				switch (type){
					case "attack":
						color = 0x000000;
						break;
					case "skill":
						tHeight =1.5*tHeight;
						color = 0x3FE233;
					break;
					case "health":
						tHeight =1.5*tHeight;
						color = 0x48E266;
						break;
					
				}
			}
			var icon:Image = new Image(iconTexture);
			icon.width = icon.height = tHeight;
			container.addChild(icon);
			
			var text:TextField = FieldController.createSingleLineDynamicField(200,tHeight,"x"+hurt,color,tHeight*0.8,true);
			text.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(text);
			text.x = icon.width + 5*Configrations.ViewScale;
			backSkin.height = tHeight;
			backSkin.width = container.width;
			container.x = -container.width/2;
			
			var t:Tween = new Tween(container,1);
			if(isleft){
				t.moveTo(-container.width, - 30);
			}else{
				t.moveTo(container.width/2, - 30);
			}
			t.onComplete = function():void{
				Starling.juggler.remove(t);
				removeFromParent(true);
			};
			Starling.juggler.add(t);
		}
	}
}