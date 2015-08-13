package model.player
{
	import controller.GameController;
	
	import starling.events.EventDispatcher;

	
	public class GameUser extends EventDispatcher
	{
		public function GameUser(data:Object)
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in GamePlayer: GamePlayer["+str+"]="+data[str]);
				}
			}
		}
		public function refresh(data:Object):void
		{
			for(var str:String in data){
				try{
					this[str] = data[str];
				}catch(e:Error){
					trace("FIELD DOSE NOT EXIST in GamePlayer: GamePlayer["+str+"]="+data[str]);
				}
			}
		}
		
		public var gameuid:String;
		public var coin:int;
		public var gem:int;
		public var login:String;
		public var extra:int;
		
		public var _user_characters:Array = [];
		public function get user_characters():Array
		{
			return _user_characters;
		}
		public function set user_characters(data:Array):void
		{
			var ob:Object;
			var hero:GamePlayer;
			for each(ob in data){
				hero = new GamePlayer(ob);
				_user_characters.push(hero);
			}
		}
		public function pushCharacter(data:Object):void
		{
			var hero:GamePlayer  = new GamePlayer(data);
			_user_characters.push(hero);
		}
		
		public function changeGem(changeNum:int):void
		{
			gem += changeNum;
			if(GameController.instance.curUIScene){
				GameController.instance.curUIScene.refreshHeadUI();
			}
		}
		public function changeCoin(changeNum:int):void
		{
			coin += changeNum;
			if(GameController.instance.curUIScene){
				GameController.instance.curUIScene.refreshHeadUI();
			}
		}
	}
}