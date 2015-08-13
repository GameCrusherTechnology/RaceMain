package view.compenent{
    import flash.display.BitmapData;
    import flash.display.Shape;
    
    import controller.FieldController;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class GreenProgressBar extends Sprite {

        public static const LEFT_TO_RIGHT:String = "leftToRight";
        public static const RIGHT_TO_LEFT:String = "rightToLeft";

		protected var bar_width:int = 200;
		protected var bar_height:int = 40;
		
        protected var m_nProgress:Number;
        protected var m_nBorderWidth:Number;
        protected var m_nBorderColor:uint;
        protected var m_cBar:Image;
		private var m_cBarBitmap:BitmapData;
		private var m_cBarSp:Shape;
        protected var m_cDirection:String;
		protected var m_cComment:TextField;
		protected var barColor:uint = 0x7EE000;
		protected var barbgColor:uint = 691968;
		protected var barIcon:Image;
		protected var iconText:TextField;
		
        public function GreenProgressBar(_barWidth:int , _barHeight:int, _borderW:Number=5, _borderColor:uint=0x000000,_barColor:uint = 0x7EE000,_barbgColor:uint = 0xFFFA5D){
            bar_width = _barWidth;
            bar_height = _barHeight;
            m_nBorderWidth = _borderW;
            m_nBorderColor = _borderColor;
			barColor = _barColor;
			barbgColor = _barbgColor;
			
			var sp1:Shape = new Shape();
			sp1.graphics.lineStyle(_borderW, _borderColor, 1, true);//0xFFFF33
			sp1.graphics.beginFill(_barbgColor, 0.2);
			sp1.graphics.drawRoundRect(0, 0, _barWidth, _barHeight, _barHeight/2,_barHeight/2);
			sp1.cacheAsBitmap = true;
			m_cBarBitmap = new BitmapData(_barWidth,_barHeight,true,0);
			m_cBarBitmap.draw(sp1);
			var image:Image = new Image(Texture.fromBitmapData(m_cBarBitmap));
			addChild(image);
			
			m_cBar = new Image(Texture.fromBitmapData(m_cBarBitmap));
			addChild(m_cBar);

			var sp2:Shape = new Shape();
			sp2.graphics.beginFill(0xffffff, 0.5);
			sp2.graphics.drawRoundRect(_borderW*2, _borderW, _barWidth-_borderW*4, _barHeight/2-_borderW, _barHeight/2,_barHeight/2);
			sp2.cacheAsBitmap = true;
			m_cBarBitmap = new BitmapData(_barWidth,_barHeight,true,0);
			m_cBarBitmap.draw(sp2);
			var image1:Image = new Image(Texture.fromBitmapData(m_cBarBitmap));
			addChild(image1);
			image1
			
			m_cBarSp = new Shape();
			m_cBarSp.cacheAsBitmap = true;
			
			m_nProgress = 0;
            fillDirection = LEFT_TO_RIGHT;
        }
		
		protected function showIcon(texture:Texture):void
		{
			barIcon = new Image(texture);
			addChild(barIcon);
			barIcon.width = barIcon.height = bar_height+20;
			
			iconText = FieldController.createSingleLineDynamicField( barIcon.width, barIcon.height,"", 0x000000, 25);
			iconText.bold = true;
			addChild(iconText);
			
			if(m_cDirection == RIGHT_TO_LEFT){
				barIcon.y = -10;
				barIcon.x = bar_width-barIcon.width/2;
			}else{
				barIcon.y = -10;
				barIcon.x = -barIcon.width/2;
			}
			iconText.x = barIcon.x;iconText.y =barIcon.y;
		}
        public function set fillDirection(_arg1:String):void{
            m_cDirection = _arg1;
            updateGraphics();
        }
        private function updateGraphics():void{
			m_cBarSp.graphics.clear();
			m_cBarSp.graphics.beginFill(barColor,1);
            switch (m_cDirection){
                case RIGHT_TO_LEFT:
					m_cBarSp.graphics.drawRoundRect(m_nBorderWidth+(bar_width-m_nBorderWidth*2) *(1- m_nProgress), m_nBorderWidth, ((bar_width-m_nBorderWidth*2) * m_nProgress), bar_height-m_nBorderWidth*2,10,10);
                    break;
                case LEFT_TO_RIGHT:
					m_cBarSp.graphics.drawRoundRect(m_nBorderWidth, m_nBorderWidth, (bar_width * m_nProgress-m_nBorderWidth*2), bar_height-m_nBorderWidth*2,10,10);
                    break;
            };
			m_cBarSp.graphics.endFill();
			m_cBarBitmap = new BitmapData(bar_width,bar_height,true,0);
			m_cBarBitmap.draw(m_cBarSp);
			if(m_cBar.texture){
				m_cBar.texture.dispose();
			}
			m_cBar.texture = Texture.fromBitmapData(m_cBarBitmap);
        }
        public function set progress(_arg1:Number):void{
            m_nProgress = Math.min(_arg1, 1);
            m_nProgress = Math.max(m_nProgress, 0);
            updateGraphics();
        }
		
        public function get progress():Number{
            return (m_nProgress);
        }
		
		public function set comment(_arg1:String):void{
			if(!m_cComment){
				m_cComment = FieldController.createSingleLineDynamicField(bar_width,bar_height,_arg1, 0x000000, Math.round(bar_height*0.8));
				m_cComment.bold = true;
				m_cComment.x = bar_width/2 - m_cComment.width/2;
				m_cComment.y = - m_cComment.height/2 + m_cComment.height/2 ;
				addChild(m_cComment);
			}else{
				m_cComment.text = _arg1;
			}
		}
		
		public function set iconStr(_arg1:String):void{
			iconText.text = _arg1;
		}
		
    }
}