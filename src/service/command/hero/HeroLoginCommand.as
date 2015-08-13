package service.command.hero
{
	import controller.GameController;
	
	import gameconfig.Configrations;
	
	import model.player.GamePlayer;
	import model.staticData.TopRatingData;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class HeroLoginCommand extends AbstractCommand
	{
		private var onLoginSuccess:Function;
		private var hero:GamePlayer;
		public function HeroLoginCommand(_hero:GamePlayer,callBack:Function)
		{
			hero = _hero;
			onLoginSuccess =callBack;
			super(Command.HEROLOGIN,onLogin,{characteruid:hero.characteruid})
		}
		private function onLogin(result:Object):void
		{
			if(Command.isSuccess(result)){
				
				hero.refreshData(result['hero_info']);
				if(GameController.instance.currentHero){
					GameController.instance.resetWorldScene(hero);
				}else{
					GameController.instance.showWorldScene(hero);
				}
				
				if(result['topHeroRate']){
					Configrations.TopHeroRatingList = new TopRatingData(result['topHeroRate'][0],result['topHeroRate'][1],true);
				}
				if(result['topClanRate']){
					Configrations.TopClanRatingList = new TopRatingData(result['topClanRate'][0],result['topClanRate'][1],false);
				}
				
				if(result['isnewer']){
					GameController.instance.isNewer = result['isnewer'];
					GameController.instance.beginGuide(0);
				}
				GameController.instance.beginGuide(0);
			}
			onLoginSuccess();
		}
	}
}

