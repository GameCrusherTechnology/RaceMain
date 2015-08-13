package view.panel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.PanelScreen;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import starling.display.Image;
	import starling.display.graphics.Graphic;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	public class GuidePanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var mes:String;
		private var pos:Point;
		private var recW:Number;
		private var recH:Number;
		private var curStep:int;
		private var isConfirm:Boolean;
		public function GuidePanel(step:int,message:String,_pos:Point,w:Number,h:Number,_isConfirm:Boolean = false)
		{
			curStep = step;
			mes = message;
			pos = _pos;
			recW = w;
			recH = h;
			isConfirm = _isConfirm;
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			
			if(isConfirm){
				var confirmBut:Button = new Button();
				confirmBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
				confirmBut.label = LanguageController.getInstance().getString("confirm");
				confirmBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, panelheight*0.05, 0x000000);
				confirmBut.paddingLeft = confirmBut.paddingRight = 20*panelScale;
				confirmBut.paddingBottom = confirmBut.paddingTop = 20*panelScale;
				addChild(confirmBut);
				confirmBut.validate();
				recW = confirmBut.width;
				recH = confirmBut.height;
			}
			
			
			var mcShape:Shape = new Shape();
			mcShape.graphics.lineStyle();//
			mcShape.graphics.beginFill(0x000000, 0.5);
			mcShape.cacheAsBitmap = true;
			
			mcShape.graphics.drawRect(0,0,panelwidth,pos.y);
			mcShape.graphics.drawRect(0,pos.y,pos.x - recW/2,recH);
			mcShape.graphics.drawRect(pos.x + recW/2,pos.y,panelwidth - pos.x - recW/2,recH);
			mcShape.graphics.drawRect(0, pos.y + recH,panelwidth,panelheight - pos.y - recH);
			
			var m_cBarBitmap :BitmapData = new BitmapData(panelwidth,panelheight,true,0);
			m_cBarBitmap.draw(mcShape);
			
			
			var back:Image = new Image(Texture.fromBitmapData(m_cBarBitmap));
			addChild(back);
			
			
			var speechSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("speechBackSkin"),new Rectangle(30,10,160,80)));
			addChild(speechSkin);
			
			var speechText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.5,panelheight,mes,0x000000,panelheight*0.06);
			speechText.autoSize = TextFieldAutoSize.VERTICAL;
			addChild(speechText);
			
			speechSkin.width = speechText.width + panelwidth*0.1 + 20;
			speechSkin.height = speechText.height + panelheight*0.05;
			
			
			
			var guideIcon:Image = new Image (Game.assets.getTexture("GuideIcon"));
			guideIcon.height = panelheight*0.15;
			guideIcon.scaleX = guideIcon.scaleY;
			addChild(guideIcon);
			
			var arrowIcon:Image = new Image(Game.assets.getTexture("leftArrowIcon"));
			arrowIcon.width = arrowIcon.height = panelheight*0.1;
			addChild(arrowIcon);
			
			var h:Number = speechSkin.height + arrowIcon.height;
			
			
			var but:Button = new Button();
			var p:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("guideRectangle"),new Rectangle(5,5,90,90)));
			p.width = recW;
			p.height = recH;
			but.defaultSkin = p;
			but.addEventListener(Event.TRIGGERED,onTriggered);
			addChild(but);
			but.validate();
			
			
			if(pos.y > (h +panelheight*0.1) ){
				
				arrowIcon.rotation = deg2rad(-90);
				arrowIcon.x = pos.x - arrowIcon.width/2;
				arrowIcon.y = pos.y  ;
				
				speechSkin.x = Math.max(Math.min(pos.x -  speechSkin.width/3,panelwidth -  speechSkin.width),guideIcon.width);
				speechSkin.y = arrowIcon.y - speechSkin.height - arrowIcon.height;
				
				but.x = pos.x - but.width/2;
				but.y = pos.y;
				
			}else{
				arrowIcon.rotation = deg2rad(90);
				arrowIcon.x = pos.x + arrowIcon.width/2;
				arrowIcon.y = pos.y + but.height;
				
				speechSkin.x = Math.max(Math.min(pos.x -  speechSkin.width/3,panelwidth -  speechSkin.width),guideIcon.width);
				speechSkin.y = arrowIcon.y + arrowIcon.height;
				
				but.x = pos.x - but.width/2;
				but.y = pos.y ;
			}
			
			
			
			
			speechText.x = speechSkin.x + 20 + panelwidth*0.05;
			speechText.y = speechSkin.y + speechSkin.height/2 - speechText.height/2;
			
			guideIcon.x = speechSkin.x - guideIcon.width;
			guideIcon.y = speechSkin.y + speechSkin.height/2 - guideIcon.height/2;
			
			if(isConfirm){
				confirmBut.x = but.x;
				confirmBut.y = but.y;
			}
		}
		
		private function onTriggered(e:Event):void
		{
			removeFromParent(true);
			
			GameController.instance.beginGuide(curStep+1);
			
		}
	}
}