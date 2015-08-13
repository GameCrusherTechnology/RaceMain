package view.compenent
{
	import flash.geom.Rectangle;
	
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import gameconfig.Configrations;
	
	import model.battle.BattleRule;
	import model.player.BossPlayer;
	import model.player.MonsterPlayer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	import view.entity.BossHomeEntity;
	import view.entity.CastleEntity;
	import view.entity.MonsterHomeEntity;

	public class BattleTop extends Sprite
	{
		private var tWidth:Number;
		private var tHeight:Number;
		private var leftPart:TopBattlePart;
		private var rightPart:TopBattlePart;
		private var rule:BattleRule;
		public function BattleTop(_rule:BattleRule)
		{
			tWidth =  Configrations.ViewPortWidth;
			tHeight= Configrations.ViewPortHeight*0.15;
			rule = _rule;
			
			var topSkin:Scale9Image = new Scale9Image(new Scale9Textures(Game.assets.getTexture("BlackSkin"),new Rectangle(2,2,60,60)));
			topSkin.width = tWidth
			topSkin.height = tHeight;
			topSkin.alpha = 0.5;
			addChild(topSkin);
			
			leftPart = new TopHeroPart(rule.homeCastleEntity,rule);
			addChild(leftPart);
			
			if(rule.RightPlayer is MonsterPlayer){
				rightPart = new TopMonsterPart(rule.enemyCastleEntity as MonsterHomeEntity,rule);
			}else if(rule.RightPlayer is BossPlayer){
				rightPart = new TopBossPart(rule.enemyCastleEntity as BossHomeEntity,rule,rule.RightPlayer as BossPlayer);
			}else{
				rightPart = new TopRightHeroPart(rule.enemyCastleEntity as CastleEntity,rule);
			}
			addChild(rightPart);
			rightPart.x = tWidth/2;
			
			
			var vsIcon:Image = new Image(Game.assets.getTexture("VSIcon"));
			vsIcon.width = vsIcon.height = tHeight*0.6;
			addChild(vsIcon);
			vsIcon.x = tWidth/2 - vsIcon.width/2;
			vsIcon.y = tHeight*0.1;
			
		}
		public function validate():void
		{
			leftPart.validate();
			rightPart.validate();
		}
		
	}
}