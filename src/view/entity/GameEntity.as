package view.entity
{
	import flash.geom.Point;
	
	import model.battle.BattleRule;
	import model.entity.EntityItem;
	import model.gameSpec.EntityItemSpec;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import view.compenent.HurtTip;
	import view.compenent.SoldierLifeProgressBar;

	public class GameEntity extends Sprite
	{
		public var item:EntityItem;
		protected var surface:DisplayObject;
		protected var battleRule:BattleRule;
		protected var lifeBar:SoldierLifeProgressBar;
		protected var isLeft:Boolean;
		public function GameEntity(_item:EntityItem,rule:BattleRule,_isleft:Boolean)
		{
			isLeft = _isleft;
			item = _item;
			battleRule = rule;
			creatSurface();
			configPosition();
			this.touchable = false;
		}
		protected function creatSurface():void
		{
			surface = new Image(Game.assets.getTexture(item.itemSpec.name));
			addChild(surface);
			surface.x = -surface.width/2;
			surface.y = -surface.height;
			
		}
		protected function configPosition():void
		{
			x = item.pos_x;
			y = item.pos_y;
		}
		
		public function showHurtBar(texture:Texture,hurt:int,type:String="skill"):void
		{
			var bar:HurtTip = new HurtTip(texture,hurt,isLeft,type);
			addChild(bar);
			bar.x = 0;
			bar.y = -item.itemSpec.recty +(item.itemSpec.recty- item.itemSpec.runy) - bar.height - 10;
		}
		protected function showLife():void
		{
			if(!lifeBar){
				lifeBar = new SoldierLifeProgressBar(item.itemSpec,isLeft);
				addChild(lifeBar);
				lifeBar.x = -lifeBar.width/2;
				lifeBar.y = -item.itemSpec.recty +(item.itemSpec.recty- item.itemSpec.runy) - lifeBar.height ;
			}
			lifeBar.showProgress(item.life,item.totalLife);
		}
		
		
		public function validate():void
		{
			
		}
		public function getCurAttackPoint():int
		{
			return Math.round(item.attckPoint*(1+ attackBuffAdd/100));
		}
		public function beAttacked(hurt:Number,texture:Texture,type:String = "skill"):void
		{
			if(!item.isDead){
				item.life -=hurt*(1-dodgeBuffAdd/100);
				showLife();
				showHurtBar(texture,hurt,type);
				if(item.isDead){
					beDead();
				}
			}
		}
		protected var canMove:Boolean = true;
		protected var canAttack:Boolean = true;
		
		private var attackBuffAdd:int;
		private var attackBuffMC:MovieClip;
		private var healthBuffMC:MovieClip;
		private var dodgeBuffAdd:int;
		private var dodgeMC:MovieClip;
		private var thunderMC:MovieClip;
		private var fireMC:MovieClip;
		private var shieldMC:MovieClip;
		private var shieldBuffAdd:int;
		public function beBuffed(type:String,add:int=0):void
		{
			switch(type)
			{
				case "attackBuff":
					if(!attackBuffMC){
						attackBuffMC = creatBuffMC("attackBuff");
					}
					addChild(attackBuffMC);
					attackBuffAdd += add;
					Starling.juggler.add(attackBuffMC);
					break;
					
				case "healthBuff":
					if(!healthBuffMC){
						healthBuffMC = creatBuffMC("healthBuff");
					}
					showHurtBar(Game.assets.getTexture("skillIcon/healthBuff"),add,"health");
					addChild(healthBuffMC);
					item.life += add;
					Starling.juggler.add(healthBuffMC);
					break;
				case "zhiyu":
					if(!dodgeMC){
						dodgeMC = creatBuffMC("zhiyu");
					}
					addChild(dodgeMC);
					Starling.juggler.add(dodgeMC);
					dodgeBuffAdd += add;
					break;
				
				case "thunder":
					if(!thunderMC){
						thunderMC = creatBuffMC("thunder");
					}
					addChild(thunderMC);
					Starling.juggler.add(thunderMC);
					
					canMove = false;
					canAttack = false;
					if(surface is MovieClip){
						(surface as MovieClip).pause();
					}
					
					break;
				case "fire":
					if(!fireMC){
						fireMC = creatBuffMC("redBuff");
					}
					addChild(fireMC);
					Starling.juggler.add(fireMC);
					
					
					break;
				case "shield":
					if(!shieldMC){
						shieldMC = creatBuffMC("shield");
					}
					addChild(shieldMC);
					Starling.juggler.add(shieldMC);
					shieldBuffAdd = add;
					break;
				case "stop":
					canMove = false;
					canAttack = false;
					break;
				default:
				{
					break;
				}
			}
		}
		
		public function setOut():void
		{
			canMove = false;
			canAttack = false;
		}
		public function setIn():void
		{
			canMove = true;
			canAttack = true;
		}
		private function creatBuffMC(name:String):MovieClip
		{
			var spec:EntityItemSpec = item.itemSpec;
			var mc:MovieClip = new MovieClip(Game.assets.getTextures(name));
			var s1:Number = Math.min(spec.rectw/mc.width,spec.recty/mc.height);
			mc.scaleX = mc.scaleY = s1;
			mc.x = 	-mc.width/2 ;
			mc.y =  -mc.height;
			return mc;
		}
		
		public function removeBuffed(type:String,add:int=0):void
		{
			switch(type)
			{
				case "attackBuff":
				{
					Starling.juggler.remove(attackBuffMC);
					removeChild(attackBuffMC);
					attackBuffAdd -= add;
					
					break;
				}
				case "healthBuff":
				{
					Starling.juggler.remove(healthBuffMC);
					removeChild(healthBuffMC);
					if(item.life >item.totalLife){
						item.life = item.totalLife;
					}
					break;
				}
				case "zhiyu":
				{
					Starling.juggler.remove(dodgeMC);
					removeChild(dodgeMC);
					dodgeBuffAdd -= add;
					break;
				}
				
				case "thunder":
				{
					Starling.juggler.remove(thunderMC);
					removeChild(thunderMC);
					
					canMove = true;
					canAttack = true;
					if(surface is MovieClip){
						(surface as MovieClip).play();
					}
					break;
				}
				case "fire":
				{
					Starling.juggler.remove(fireMC);
					removeChild(fireMC);
					
					break;
				}
				case "shield":
				{
					Starling.juggler.remove(shieldMC);
					removeChild(shieldMC);
					
					break;
				}
				case "stop":
					canMove = true;
					canAttack = true;
					break;
				default:
				{
					break;
				}
			}
		}
		public function getSkillPoint():Point
		{
			return new Point(x,y -  item.itemSpec.recty/2*scaleY);
		}
		protected function beDead():void
		{
			battleRule.removeEntity(this);
		}
		public function get isDead():Boolean 
		{
			return item.isDead;
		}
			
	}
}