package controller{
    import flash.text.TextFormat;
    
    import gameconfig.Configrations;
    
    import starling.text.TextField;

    public class FieldController {

		public static function get  FONT_FAMILY():String
		{
			if(Configrations.Language== "zh-CN"){
				return "CN_FONT_0";
			}else if(Configrations.Language =="zh-TW"){
				return "TW_FONT_0";
			}else{
				return "myFonts_0";
			}
		}
		
		
        public static function createSingleLineDynamicField(width:Number,height:Number,txt:String, _color:uint, _size:Number,_bold:Boolean = true):TextField{
			var _local4:TextField;
			var size:int = Math.round(_size*Configrations.ViewScale);
			_local4 = new TextField(width,height,txt,FONT_FAMILY,size,_color,_bold);
			_local4.touchable = false;
            return (_local4);
        }
		public static function createNoFontField(width:Number,height:Number,txt:String, _color:uint, _size:Number):TextField{
			var size:int = Math.round(_size*Configrations.ViewScale);
			var _local4:TextField = new TextField(width,height,txt);
			_local4.bold = true;
			_local4.touchable = false;
			_local4.color = _color;
			_local4.fontSize = size;
			return (_local4);
		}
		
//		public static function creatGillTextField(width:Number,height:Number,txt:String, _color:uint, _size:Number,_bold:Boolean = false):TextField
//		{
//			var _local4:TextField;
//			var size:int = Math.round(_size*Configrations.ViewScale);
//			_local4 = new TextField(width,height,txt,"JokermanFont_0",size,_color,_bold);
//			_local4.touchable = false;
//			return (_local4);
//		}
//		
		

    }
}