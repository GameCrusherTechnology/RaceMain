package view.screen
{
	import controller.GameController;
	
	import model.player.GamePlayer;
	
	import starling.display.Sprite;
	
	import view.compenent.HeadCompenet;

	public class UIScreen extends Sprite
	{
		private var headCp:HeadCompenet;
		
		public function UIScreen()
		{
			configUI();
		}
		
		public function refresh():void
		{
			refreshHeadUI();
		}
		
		private function configUI():void
		{
			headCp = new HeadCompenet(hero);
			addChild(headCp);
		}
		public function refreshHeadUI():void
		{
			headCp.refresh();
		}
		
		private function get hero():GamePlayer
		{
			return GameController.instance.currentHero;
		}
	}
}