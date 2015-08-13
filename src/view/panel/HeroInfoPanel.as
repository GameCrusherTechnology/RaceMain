package view.panel
{
	import flash.geom.Rectangle;
	
	import controller.DialogController;
	import controller.FieldController;
	import controller.GameController;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.events.FeathersEventType;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.TiledRowsLayout;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	import gameconfig.LanguageController;
	
	import model.entity.SoldierData;
	import model.gameSpec.PieceItemSpec;
	import model.item.OwnedItem;
	import model.player.GamePlayer;
	
	import service.command.hero.SetSkillCommand;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	import view.compenent.GreenProgressBar;
	import view.render.HeroSkillRender;

	public class HeroInfoPanel extends PanelScreen
	{
		private var panelwidth:Number;
		private var panelheight:Number;
		private var panelScale:Number;
		private var titleText:TextField;
		private var backBut:Button;
		private var curHero :GamePlayer;
		private var lastSkillArr:Array;
		public function HeroInfoPanel()
		{
			curHero = GameController.instance.currentHero;
			lastSkillArr = curHero.skillList.concat();
			addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}
		
		protected function initializeHandler(event:Event):void
		{
			panelwidth = Configrations.ViewPortWidth;
			panelheight = Configrations.ViewPortHeight;
			panelScale = Configrations.ViewScale;
			
			var blackSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			addChild(blackSkin);
			blackSkin.alpha = 0.5;
			blackSkin.width = panelwidth;
			blackSkin.height = panelheight;
			
			var backSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("ListSkin"),new Rectangle(15,16,300,300)));
			addChild(backSkin);
			backSkin.width = panelwidth*0.8;
			backSkin.height = panelheight*0.8;
			backSkin.x = panelwidth*0.1;
			backSkin.y = panelheight*0.1;
			
			var titleSkin:Scale9Image = new Scale9Image(Configrations.PanelTitleSkinTexture);
			addChild(titleSkin);
			titleSkin.width = panelwidth*0.8;
			titleSkin.height = panelheight*0.08;
			titleSkin.x = panelwidth*0.1;
			titleSkin.y = panelheight*0.1;
			
			titleText = FieldController.createNoFontField(panelwidth,titleSkin.height,curHero.name,0xffffff,titleSkin.height*0.8);
			addChild(titleText);
			titleText.y =  titleSkin.y;
			
			var heroSkin:Scale9Image = new Scale9Image(new Scale9Textures( Game.assets.getTexture("PanelRenderSkin"),new Rectangle(12,12,40,40)));
			heroSkin.width = panelwidth*0.7;
			heroSkin.height = panelheight*0.4;
			addChild(heroSkin);
			heroSkin.x = panelwidth*0.15;
			heroSkin.y = panelheight*0.2;
				
			var icon:Image = new Image(Game.assets.getTexture(curHero.characterSpec.name+"Icon"));
			icon.height = panelheight*0.2;
			icon.scaleX = icon.scaleY;
			addChild(icon);
			icon.x = panelwidth*0.3 - icon.width;
			icon.y = panelheight*0.2;
			
			
			var expProgressBar :GreenProgressBar = new GreenProgressBar(panelwidth*0.2,30*panelScale,2);
			addChild(expProgressBar);
			expProgressBar.x = panelwidth *0.4;
			expProgressBar.y = panelheight*0.22 + 10* panelScale;
			
			var level:int = Configrations.expToGrade(curHero.curExp);
			var nextLevel:int = level+1;
			var currentExp:int = curHero.curExp - Configrations.gradeToExp(level);
			var currentTotal:int =  Configrations.gradeToExp(nextLevel) - Configrations.gradeToExp(level);
			expProgressBar.progress = currentExp/currentTotal;
			expProgressBar.comment = "EXP: "+curHero.curExp;
			
			var soldierData:SoldierData = new SoldierData(curHero.characterSpec,level);
			var expIcon:Image = new Image(Game.assets.getTexture("expIcon"));
			expIcon.width = expIcon.height = 50*panelScale;
			addChild(expIcon);
			expIcon.x = expProgressBar.x - expIcon.width/2;
			expIcon.y = panelheight*0.22 ;
			
			var expText:TextField = FieldController.createSingleLineDynamicField(expIcon.width,expIcon.height,String(curHero.level),0x000000,15,true);
			addChild(expText);
			expText.x = expIcon.x;
			expText.y = expIcon.y;
			
			
			var aicon:Image = new Image(Game.assets.getTexture("AttackTipIcon"));
			aicon.width = aicon.height = 30*panelScale;
			addChild(aicon);
			aicon.x = expProgressBar.x + expProgressBar.width/2;
			aicon.y = expProgressBar.y + expProgressBar.height + 5*panelScale; ;
			
			var aname:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.5,aicon.height,LanguageController.getInstance().getString("attack"),0x000000,20);
			aname.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(aname);
			aname.x = aicon.x - aname.width - 5*panelScale;
			aname.y = aicon.y  ;
			
			var aText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.5,aicon.height,String(soldierData.attackPoint),0xff6666,25);
			aText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(aText);
			aText.x = aicon.x + aicon.width +5*panelScale;
			aText.y = aicon.y  ;
			
			
			var hicon:Image = new Image(Game.assets.getTexture("HealthTipIcon"));
			hicon.width = hicon.height = 30*panelScale;
			addChild(hicon);
			hicon.x = expProgressBar.x + expProgressBar.width/2;
			hicon.y = aicon.y + aicon.height + 3*panelScale ;
			
			var hname:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.5,hicon.height,LanguageController.getInstance().getString("health"),0x000000,20);
			hname.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(hname);
			hname.x = hicon.x - hname.width - 5*panelScale;
			hname.y = hicon.y  ;
			
			var hText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.5,aicon.height,String(soldierData.healthPoint),0x2317D0,20);
			hText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(hText);
			hText.x = hicon.x + hicon.width +5*panelScale;
			hText.y = hicon.y  ;
			
			var asicon:Image = new Image(Game.assets.getTexture("AttackSpeedIcon"));
			asicon.width = asicon.height = 30*panelScale;
			addChild(asicon);
			asicon.x = expProgressBar.x + expProgressBar.width/2;
			asicon.y = hicon.y + hicon.height + 3*panelScale ;
			
			var asname:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.5,hicon.height,LanguageController.getInstance().getString("attackspeed"),0x000000,20);
			asname.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(asname);
			asname.x = asicon.x - asname.width - 5*panelScale;
			asname.y = asicon.y  ;
			
			var asText:TextField = FieldController.createSingleLineDynamicField(panelwidth*0.5,aicon.height,String(soldierData.attackSpeedT),0x33ff33,20);
			asText.autoSize = TextFieldAutoSize.HORIZONTAL;
			addChild(asText);
			asText.x = asicon.x + asicon.width +5*panelScale;
			asText.y = asicon.y  ;
			
			
			
			backBut = new Button();
			backBut.defaultSkin = new Image(Game.assets.getTexture("CancelButtonIcon"));
			backBut.width = backBut.height = panelheight*0.1;
			addChild(backBut);
			backBut.x = panelwidth*0.1 - panelheight*0.05;
			backBut.y = panelheight*0.08;
			backBut.addEventListener(Event.TRIGGERED,onTriggerBack);
			
			configCurSkillList();
			configOwnedSkillList();
			
			var list:Array = hero.ownedItemlist;
			var item:OwnedItem;
			for each(item in list){
				if(item.itemSpec is PieceItemSpec){
					if(PieceItemSpec(item.itemSpec).type == "skill"){
						var needSkill:int = hero.pieceUpdateSkillCount(PieceItemSpec(item.itemSpec));
						if(needSkill <= item.count && needSkill >0){
							configUpdateBut();
							break;
						}
					}
				}
			}
			
		}
		private function configUpdateBut():void
		{
			var container:Sprite = new Sprite;
			addChild(container);
			
			var updateButton:Button = new Button();
			updateButton.defaultSkin = new Image(Game.assets.getTexture("blueButtonSkin"));
			updateButton.label = LanguageController.getInstance().getString("toUpdate");
			updateButton.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
			updateButton.addEventListener(Event.TRIGGERED, onUpdateClickHandler);
			updateButton.paddingLeft =updateButton.paddingRight =  20;
			updateButton.paddingTop =updateButton.paddingBottom =  5;
			container.addChild(updateButton);
			var icon:Image = new Image(Game.assets.getTexture("markIcon"));
			container.addChild(icon);
			updateButton.validate();
			icon.width = icon.height = updateButton.height;
			updateButton.x = icon.x + icon.width ;
			container.x = panelwidth*0.8 - container.width;
			container.y = panelheight*0.82;
			
			var tween:Tween = new Tween(icon, 1);
			tween.scaleTo(icon.scaleX*2); 
			tween.moveTo(-icon.width/2,-icon.height/2);
			tween.repeatCount = 10;
			Starling.juggler.add(tween);
		}
		private function onUpdateClickHandler(e:Event):void
		{
			DialogController.instance.showPanel(new ComposePanel());
			dispose();
		}
		private var curSkillList:List;
		private function configCurSkillList():void
		{
			if(!curSkillList){
				
				curSkillList = new List();
				const listLayout:HorizontalLayout = new HorizontalLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
				listLayout.gap = 10*panelScale;
				
				curSkillList.layout = listLayout;
				curSkillList.dataProvider = getcurSkillList();
				curSkillList.itemRendererFactory =function tileListItemRendererFactory():HeroSkillRender
				{
					var renderer:HeroSkillRender = new HeroSkillRender();
					renderer.defaultSkin = new Image(Game.assets.getTexture("SelectRenderSkin"));
					renderer.width = panelheight *0.15;
					renderer.height = panelheight *0.15;
					return renderer;
				}
				curSkillList.width =  panelwidth*0.6;
				curSkillList.height =  panelheight *0.2;
				curSkillList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				curSkillList.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
				addChild(curSkillList);
				curSkillList.x = panelwidth*0.2;
				curSkillList.y = panelheight*0.4;
				curSkillList.selectedIndex = -1;
				curSkillList.addEventListener(Event.CHANGE,oncurSkillListChange);
			}else{
				curSkillList.dataProvider = getcurSkillList();
				curSkillList.validate();
			}
		}
		
		private var ownSkillList:List;
		private var ownlistText:TextField;
		private var shopBut:Button;
		private function configOwnedSkillList():void
		{
			if(!ownSkillList){
				ownSkillList = new List();
				const listLayout:HorizontalLayout = new HorizontalLayout();
				listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
				listLayout.verticalAlign = TiledRowsLayout.VERTICAL_ALIGN_MIDDLE;
				listLayout.paddingTop = 30*panelScale;
				listLayout.gap = 10*panelScale;
				
				
				var listSkin:Scale9Image =  new Scale9Image(new Scale9Textures( Game.assets.getTexture("PanelBackSkin"),new Rectangle(12,12,40,40)));
				ownSkillList.backgroundSkin =listSkin;
				
				ownSkillList.layout = listLayout;
				ownSkillList.dataProvider = getownSkillList();
				ownSkillList.itemRendererFactory =function tileListItemRendererFactory():HeroSkillRender
				{
					var renderer:HeroSkillRender = new HeroSkillRender();
					
					renderer.defaultSkin = new Image(Game.assets.getTexture("PanelSkin"));
					renderer.width = panelwidth *0.1;
					renderer.height = panelheight *0.1;
					return renderer;
				}
				ownSkillList.width =  panelwidth*0.7;
				ownSkillList.height =  panelheight *0.17;
				ownSkillList.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
				ownSkillList.horizontalScrollPolicy = List.SCROLL_POLICY_AUTO;
				addChild(ownSkillList);
				ownSkillList.x = panelwidth*0.15;
				ownSkillList.y = panelheight*0.6;
				ownSkillList.selectedIndex = -1;
				ownSkillList.addEventListener(Event.CHANGE,onownSkillListChange);
				
				ownlistText = FieldController.createSingleLineDynamicField(panelwidth *0.7,30*panelScale,LanguageController.getInstance().getString("owned"),0x000000,25);
				addChild(ownlistText);
				ownlistText.x = panelwidth*0.15;
				ownlistText.y =  panelheight*0.6;
				
				shopBut = new Button();
				shopBut.defaultSkin = new Image(Game.assets.getTexture("Y_button"));
				shopBut.label = LanguageController.getInstance().getString("ShopScene");
				shopBut.addEventListener(Event.TRIGGERED,onTriggeredShop);
				shopBut.defaultLabelProperties.textFormat = new BitmapFontTextFormat(FieldController.FONT_FAMILY, 30, 0x000000);
				shopBut.paddingLeft =shopBut.paddingRight =  20;
				shopBut.paddingTop =shopBut.paddingBottom =  10;
				addChild(shopBut);
				shopBut.validate();
				shopBut.x = panelwidth*0.5- shopBut.width/2;
				shopBut.y = ownlistText.y + panelheight*0.2 ;
				
			}else{
				ownSkillList.dataProvider = getownSkillList();
				ownSkillList.validate();
			}
			
			if(ownSkillList.dataProvider.length<=0){
				ownlistText.height = panelheight*0.17;
				ownlistText.text = LanguageController.getInstance().getString("OwnedNothing");
				shopBut.visible = true;
			}else{
				ownlistText.height = 30*panelScale;
				ownlistText.text = LanguageController.getInstance().getString("owned");
				shopBut.visible = false;
			}
		}
		private function onTriggeredShop(e:Event):void
		{
			DialogController.instance.showPanel(new ShopPanel(),true);
		}
		private function oncurSkillListChange(e:Event):void
		{
			var itemid:String = String(curSkillList.selectedItem);
			if(int(itemid) >0){
				lastSkillArr.splice(lastSkillArr.indexOf(itemid),1);
				configCurSkillList();
				configOwnedSkillList();
			}
		}
		private function onownSkillListChange(e:Event):void
		{
			var itemid:String = String(ownSkillList.selectedItem);
			if(int(itemid) > 0){
				lastSkillArr.push(itemid);
				configCurSkillList();
				configOwnedSkillList();
			}
		}
		private function getcurSkillList():ListCollection
		{
			lastSkillArr.sort();
			return new ListCollection(lastSkillArr);
		}
		private function getownSkillList():ListCollection
		{
			var arr:Array = [];
			var army:Array = lastSkillArr;
			for each(var item:OwnedItem in hero.ownedSkilllist){
				if(item.count > 0){
					var index:int = army.indexOf(item.item_id);
					if(index<0){
						arr.push(item.item_id);
					}
				}
			}
			arr.sort();
			return new ListCollection(arr);
		}
		
		private function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
		private function onTriggerBack(e:Event):void
		{
			lastSkillArr.sort();
			var newstr:String = lastSkillArr.join(":");
			var oldstr:String = hero.skillList.join(":");
			if(newstr != oldstr){
				new SetSkillCommand(lastSkillArr,onChanged);
			}
			dispose();
		}
		private function onChanged():void
		{
		}
		
		override public function dispose():void
		{
			removeFromParent();
			super.dispose();
		}
	}
}