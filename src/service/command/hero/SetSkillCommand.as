package service.command.hero
{
	import controller.GameController;
	
	import service.command.AbstractCommand;
	import service.command.Command;
	
	public class SetSkillCommand extends AbstractCommand
	{
		private var onSuccess:Function;
		private var newArr:Array;
		public function SetSkillCommand(_skill:Array,callBack:Function)
		{
			onSuccess =callBack;
			newArr = _skill;
			super(Command.SETSKILL,onHandler,{skill:_skill})
		}
		private function onHandler(result:Object):void
		{
			if(Command.isSuccess(result)){
				GameController.instance.currentHero.skillList = newArr;
				onSuccess();
			}
		}
	}
}

