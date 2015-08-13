package view.render
{
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.gameSpec.ItemSpec;
	import model.gameSpec.PieceItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	import model.player.GameUser;
	
	import service.command.item.AddEnergyCommand;
	import service.command.item.BuyItemCommand;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.panel.ComposePanel;
	import view.panel.WarnnigTipPanel;
	
	public class SpecialItemRender extends DefaultListItemRenderer
	{
		private var hero:GamePlayer;
		private var curUser:GameUser;
		private var scale:Number;
		private var renderwidth:Number;
		private var renderHeight:Number;
		private var itemspec:ItemSpec;
		private const canUseArr:Array = ["80000","80001"];
		public function SpecialItemRender()
		{
			super();
			scale = Configrations.ViewScale;
			hero = GameController.instance.currentHero;
			curUser = GameController.instance.localPlayer;
		}
		
		private var container:Sprite;
		private var itemId:String;
		private var ownedItem:OwnedItem;
		override public function set data(value:Object):void
		{
			renderwidth = width;
			renderHeight = height;
			super.data = value;
			if(value){
				itemId = String(value) ;
				refreshData();
			}
		}
		
		private function refreshData():void{
			if(container){
				container.removeFromParent(true);
				container = null;
			}
			configContainer();
		}
		private function configContainer():void
		{
			container = new Sprite;
			addChild(container);
			ownedItem = hero.getItem(itemId);
			
			itemspec = ownedItem.itemSpec;
			if(itemspec){
				
				var nameText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,itemspec.cname,0x000000,25);
				nameText.autoSize = TextFieldAutoSize.VERTICAL;
				container.addChild(nameText);
				nameText.y =  5*scale;
				
				var icon:Image = new Image(itemspec.iconTexture);
				var s:Number =  Math.min(renderwidth*0.5/icon.width,renderHeight*0.5/icon.height) ;
				icon.scaleY = icon.scaleX = s;
				container.addChild(icon);
				icon.x = renderwidth*0.5 - icon.width/2;
				icon.y = nameText.y + nameText.height;
				
				var countText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,"×"+ownedItem.count,0xFFEC8B,renderHeight*0.15);
				countText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
				container.addChild(countText);
				countText.y =  icon.y + icon.height - countText.height;
				countText.x = icon.x +icon.width;
				
				if(itemspec.message){
					var mesText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,LanguageController.getInstance().getString(itemspec.message),0x000000,20);
					mesText.autoSize = TextFieldAutoSize.VERTICAL;
					container.addChild(mesText);
					mesText.y =  icon.y + icon.height ;
				}
				if(itemspec is PieceItemSpec){
					var needCount:int;
					var canCompose:Boolean;
					
					
					if(PieceItemSpec(itemspec).type == "skill"){
						needCount = hero.pieceUpdateSkillCount(PieceItemSpec(itemspec));
					}else{
						needCount = hero.pieceUpdateSoldierCount(PieceItemSpec(itemspec));
					}
					if(needCount == 0){
						canCompose = false;
						var str : String; 
						if(PieceItemSpec(itemspec).type == "skill"){
							str = LanguageController.getInstance().getString("WarningSkillMaxLevel");
						}else if(PieceItemSpec(itemspec).type == "soldier"){
							str = LanguageController.getInstance().getString("WarningSoldierMaxLevel");
						}
						var infoText:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,str,0x000000,20);
						infoText.autoSize = TextFieldAutoSize.VERTICAL;
						container.addChild(infoText);
						infoText.y =  icon.y + icon.height ;
					}else{
						var spSkin:Image = new Image(Game.assets.getTexture("TitleTextSkin"));
						container.addChild(spSkin);
						var textSp:Sprite = new Sprite;
						container.addChild(textSp);
						
						if(ownedItem.count >= needCount){
							canCompose = true;
						}else{
							canCompose = false;
						}
						
						var countText1:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,String(ownedItem.count),canCompose?0x00ff00:0xff0000,20);
						countText1.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
						textSp.addChild(countText1);
						var countText2:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight,"/" ,0xffffff,20);
						countText2.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
						textSp.addChild(countText2);
						countText2.x = countText1.width;
						var countText3:TextField = FieldController.createSingleLineDynamicField(renderwidth,renderHeight, needCount == 0 ?"MAX":String(needCount),0xffffff,20);
						countText3.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
						textSp.addChild(countText3);
						countText3.x = countText2.x + countText2.width;
						
						
						spSkin.width = renderwidth*0.6;
						spSkin.height = textSp.height + 4*scale;
						spSkin.x = renderwidth*0.2;
						spSkin.y = icon.y + icon.height ;
						textSp.y = spSkin.y + 2*scale;
						textSp.x = renderwidth/2 - textSp.width/2;
						
					}
					
					if(canCompose){
						var composeBut:Button = new Button();
						composeBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
						composeBut.label = LanguageController.getInstance().getString("compose");
						composeBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 25, 0x000000);
						composeBut.paddingLeft =composeBut.paddingRight =  20;
						composeBut.paddingTop =composeBut.paddingBottom =  5;
						container.addChild(composeBut);
						composeBut.validate();
						composeBut.x =  renderwidth/2 - composeBut.width/2;
						composeBut.y =	renderHeight*0.95 - composeBut.height;
						composeBut.addEventListener(Event.TRIGGERED,onTriggedUse);
					}
					
				}else{
					if(ownedItem.count > 0){
						if(canUseArr.indexOf(ownedItem.item_id)>=0){
							var useBut:Button = new Button();
							useBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
							useBut.label = LanguageController.getInstance().getString("use");
							useBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 25, 0x000000);
							useBut.paddingLeft =useBut.paddingRight =  20;
							useBut.paddingTop = useBut.paddingBottom =  5;
							container.addChild(useBut);
							useBut.validate();
							useBut.x =  renderwidth/2 - useBut.width/2;
							useBut.y =	renderHeight*0.95 - useBut.height;
							useBut.addEventListener(Event.TRIGGERED,onTriggedUse);
						}
					}else{
					
						var sp:Sprite = new Sprite;
						container.addChild(sp);
						
						var leftBound:int ;
						if(itemspec.gem > 0){
							var gemBut:Button = new Button();
							gemBut.defaultSkin = new Image(Game.assets.getTexture("greenButtonSkin"));
							gemBut.label = "×"+itemspec.gem;
							var iconM:Image = new Image(Game.assets.getTexture("GemIcon"));
							iconM.width = iconM.height = renderHeight *0.1;
							gemBut.defaultIcon = iconM;
							gemBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
							gemBut.paddingLeft =gemBut.paddingRight =  5;
							gemBut.paddingTop =gemBut.paddingBottom =  5;
							sp.addChild(gemBut);
							gemBut.validate();
							leftBound = gemBut.width + renderwidth *0.05;
							
							gemBut.addEventListener(Event.TRIGGERED,onTriggedBuyGem);
						}
						if(itemspec.coin > 0){
							var coinBut:Button = new Button();
							coinBut.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
							coinBut.label ="×"+itemspec.coin;
							var iconM1:Image = new Image(Game.assets.getTexture("CoinIcon"));
							iconM1.width = iconM1.height = renderHeight *0.1;
							coinBut.defaultIcon = iconM1;
							coinBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 20, 0x000000);
							coinBut.paddingLeft =coinBut.paddingRight =  5;
							coinBut.paddingTop =coinBut.paddingBottom =  5;
							sp.addChild(coinBut);
							coinBut.validate();
							coinBut.x = leftBound;
							coinBut.addEventListener(Event.TRIGGERED,onTriggedBuyCoin);
						}
						sp.x = renderwidth*0.5 - sp.width/2;
						sp.y = renderHeight*0.9 - sp.height;
					}
				}
			}
		}
		private function onTriggedUse(e:Event):void
		{
			if(!isCommanding){
				if(itemspec is PieceItemSpec){
					DialogController.instance.showPanel(new ComposePanel(itemspec as PieceItemSpec,ownedItem.count),true);
				}
				if(itemId == "80000"){
					new AddEnergyCommand(itemId,onUsed);
					isCommanding = true;
				}
			}
		}
		
		private function checkPieceTouch(pieceSpec:PieceItemSpec,count:int):void
		{
			if(pieceSpec.type == "skill"){
				var needSkill:int = hero.pieceUpdateSkillCount(pieceSpec);
				if(needSkill == 0 ){
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("WarningSkillMaxLevel")));
				}else if(needSkill <= count){
					DialogController.instance.showPanel(new ComposePanel(pieceSpec,count),true);
				}else{
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("WarningPieceIsNotEnough")));
				}
			}else if(pieceSpec.type == "soldier"){
				var needSoldier:int = hero.pieceUpdateSoldierCount(pieceSpec);
				if(needSoldier == 0 ){
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("WarningSoldierMaxLevel")));
				}else if(needSoldier <= count){
					DialogController.instance.showPanel(new ComposePanel(pieceSpec,count),true);
				}else{
					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("WarningPieceIsNotEnough")));
				}
			}
		}
		
		private function onUsed():void
		{
			isCommanding = false;
			refreshData();
		}
		private var isCommanding:Boolean;
		private function onTriggedBuyCoin(e:Event):void
		{
			if(curUser.coin >= itemspec.coin){
				if(!isCommanding){
					new BuyItemCommand(itemId,1,false,onCoinBuySucess);
					isCommanding = true;
				}
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningCoinTip")));
			}
		}
		
		private function onCoinBuySucess(bool:Boolean):void
		{
			isCommanding = false;
			if(bool){
				hero.addItem(itemId,1);
				curUser.changeCoin(-itemspec.coin);
				refreshData();
			}
		}
		
		private function onTriggedBuyGem(e:Event):void
		{
			if(curUser.gem >= itemspec.gem){
				if(!isCommanding){
					new BuyItemCommand(itemId,1,true,onGemBuySucess);
					isCommanding = true;
				}
			}else{
				DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("warningGemTip")));
			}
		}
		private function onGemBuySucess(bool:Boolean):void
		{
			isCommanding = false;
			if(bool){
				hero.addItem(itemId,1);
				curUser.changeGem(-itemspec.gem);
				refreshData();
			}
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
