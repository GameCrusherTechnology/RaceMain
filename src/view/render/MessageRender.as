package view.render
{
	import flash.geom.Rectangle;
	
	import controller.FieldController;
	
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.display.Scale9Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	import gameconfig.SystemDate;
	
	import model.player.GamePlayer;
	import model.staticData.MessageData;
	
	import service.command.clan.SendClanMessage;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.VAlign;
	
	public class MessageRender extends DefaultListItemRenderer
	{
		private var scale:Number;
		public function MessageRender()
		{
			super();
			scale = Configrations.ViewScale;
		}
		
		private var container:Sprite;
		private var mesData:MessageData;
		override public function set data(value:Object):void
		{
			if(value){
				super.data = mesData = value as MessageData;
				if(container){
					if(container.parent){
						container.parent.removeChild(container);
					}
					container = null;
				}
				if(mesData.heroId){
					configLayout();
				}else{
					configLayout1();
				}
			}
		}
		private function configLayout():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			var playerData:GamePlayer = mesData.curHero; 
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20,20,24,24));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			var icon:Image= new Image(Game.assets.getTexture(playerData.characterSpec.name+"HeadIcon"));
			icon.height = renderheight*0.8;
			icon.scaleX = icon.scaleY;
			icon.x = 10*scale;
			icon.y = renderheight*0.1;
			container.addChild(icon);
			
			var iconRight:Number = icon.x + icon.width + 10*scale;
			
			
			var nameText:TextField = FieldController.createNoFontField(renderwidth,renderheight*0.35,playerData.name,0x000000,renderheight*0.3);
			nameText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(nameText);
			nameText.x = iconRight;
			nameText.y = icon.y ;
			
			var mes:String ;
//			if(mesData.type == Configrations.MESSTYPE_ROBBER){
//				mes = SpecController.instance.getItemSpec("100001").cname+ " "+LanguageController.getInstance().getString("InterceptTip")+" "+LanguageController.getInstance().getString("coin")+":"+mesData.message;
//			}else{
				mes = mesData.message;
//			}
			var titleText:TextField = FieldController.createNoFontField(renderwidth-iconRight,renderheight *0.5,mes,0x000000,renderheight*0.2);
			container.addChild(titleText);
			titleText.vAlign = VAlign.TOP;
			titleText.x = iconRight;
			titleText.y = renderheight *0.5 ;
			
			var leftTimeStr:String = "("+SystemDate.getTimeLeftString(SystemDate.systemTimeS - mesData.updatetime) +" "+ LanguageController.getInstance().getString("ago")+")";
			var timeText:TextField = FieldController.createSingleLineDynamicField(renderwidth ,renderheight *0.3,leftTimeStr,0x000000,renderheight *0.25,true);
			timeText.autoSize = TextFieldAutoSize.HORIZONTAL;
			container.addChild(timeText);
			timeText.x = renderwidth - timeText.width -5 *scale;
			timeText.y =  renderheight *0.1 ;
			
		}
		
		private function configLayout1():void
		{
			var renderwidth:Number = width;
			var renderheight:Number = height;
			
			container = new Sprite;
			addChild(container);
			
			var skintextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("PanelBackSkin"), new Rectangle(20,20,24,24));
			var skin:Scale9Image = new Scale9Image(skintextures);
			container.addChild(skin);
			skin.width = renderwidth;
			skin.height = renderheight;
			
			
			var postBut:Button = new Button();
			postBut.label = LanguageController.getInstance().getString("send");
			postBut.addEventListener(Event.TRIGGERED,onTriggeredSend);
			postBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
			postBut.defaultLabelProperties.textFormat  =  new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			postBut.paddingLeft =postBut.paddingRight =  20*scale;
			postBut.paddingTop =postBut.paddingBottom =  5*scale;
			container.addChild(postBut);
			postBut.validate();
			postBut.x = renderwidth - postBut.width-10*scale;
			postBut.y =  renderheight/2 - postBut.height/2;
			
			_input = new TextInput();
			var _inputSkinTextures:Scale9Textures = new Scale9Textures(Game.assets.getTexture("simplePanelSkin"), new Rectangle(20, 20, 20, 20));
			_input.backgroundSkin = new Scale9Image(_inputSkinTextures);
			_input.paddingLeft = 10;
			_input.width = postBut.x - renderwidth*0.05 - 10*scale;
			_input.height = renderheight*0.8;
			Factory(_input,{color:0x000000,fontSize:renderheight*0.6,maxChars:30,text:"",displayAsPassword:false});
			container.addChild(_input);
			_input.y = renderheight/2 - _input.height/2;
			_input.x = renderwidth*0.05;
			
		}
		
		private function Factory(target:TextInput , inputParameters:Object ):void
		{
			var editor:StageTextTextEditor = new StageTextTextEditor;
			editor.color = (inputParameters.color == undefined) ? editor.color:inputParameters.color;
			editor.fontSize = (inputParameters.fontSize == undefined) ? editor.fontSize:inputParameters.fontSize;
			target.maxChars = (inputParameters.maxChars == undefined) ? editor.maxChars:inputParameters.maxChars;
			editor.displayAsPassword = (inputParameters.displayAsPassword == undefined)?editor.displayAsPassword:inputParameters.displayAsPassword;
			target.textEditorFactory = function textEditor():ITextEditor{return editor};
			target.text  = inputParameters.text;
		}
		
		private var _input:TextInput;
		private var newmessageData:MessageData;
		private var isCommanding:Boolean ;
		private function onTriggeredSend(e:Event):void
		{
			if(_input && _input.text && !isCommanding){
				new SendClanMessage(_input.text,onUpdated);
				isCommanding = true;
			}
		}
		private function onUpdated():void
		{
			isCommanding = false;
			this.dispatchEventWith(Event.CHANGE);
		}
		
		override public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
	}
}

