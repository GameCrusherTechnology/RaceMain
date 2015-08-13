package service.command
{
	import controller.GameController;
	
	import model.player.GameUser;

	public class AbstractCommand
	{
		public function AbstractCommand(key:String,callback:Function,params:Object=null)
		{
			Command.execute(key,callback,params);
		}
		
		protected function get localplayer():GameUser
		{
			return GameController.instance.localPlayer;
		}
	}
}