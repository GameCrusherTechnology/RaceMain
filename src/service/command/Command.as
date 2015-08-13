package service.command
{
	import flash.events.EventDispatcher;
	
	import controller.GameController;
	
	import gameconfig.Configrations;
	



	public class Command extends EventDispatcher
	{	
		//user
		public static const LOGIN:String  = "user/UserLoginCommand";
		public static const CREATCHARACTER:String  = "user/UserCreatCharacter";
		//HERO
		public static const HEROLOGIN:String = "hero/HeroLoginCommand";
		public static const GETHEROSINFO:String = "hero/GetHerosInfo";
		public static const SETARMY:String = "hero/SetArmy";
		public static const SETSKILL:String = "hero/SetSkill";
		//clan
		public static const GETUSERCLAN:String = "clan/UserLoginClan";
		public static const GETCLANLIST:String = "clan/GetClanList";
		public static const GETCLANINFO:String = "clan/GetClanInfo";
		public static const CREATCLAN:String = "clan/CreatClan";
		public static const JOINCLAN:String = "clan/JoinClan";
		public static const EDITCLANINFO:String = "clan/EditClanInfo";
		public static const DISSOLVECLAN:String = "clan/DissolveClan";
		public static const SIGNOUTCLAN:String = "clan/SignOutClan";
		public static const SENDCLANMES:String = "clan/SendClanMessage";
		public static const REFRESHMESSAGE:String = "clan/RefreshClanMessage";
		//item
		public static const BUYITEM:String = "item/BuyItem";
		public static const USEITEM:String = "item/UseItem";
		public static const COMPOSEITEM:String = "item/ComposeItem";
		public static const ADDENERGY:String = "item/AddEnergy";
		//pay
		public static const GOOGLEPAY:String = "pay/GooglePayForGems";
		
		//battle
		public static const BEGINSPECBATTLE:String = "battle/BeginSpecBattle";
		public static const QuickPass:String = "battle/QuickPassBattle";
		public static const GETBATTLEREWARDS:String= "battle/GetBattleRewards";
		public static const FINDENEMY:String= "battle/FindPKEnemy";
		public static const BEGINPK:String= "battle/BeginPKBattle";
		public static const GETPKBATTLEREWARDS:String= "battle/GetPKBattleRewards";
		public static const GETRATEHEROREWARD:String= "battle/GetRateHeroReward";
		public static const GETRATECLANREWARD:String= "battle/GetRateClanReward";
		public static const REFRESHCLANBOSS:String = "battle/RefreshClanBoss";
		public static const BEGINBOSS:String= "battle/BeginBossBattle";
		public static function get gateway():String
		{
			var url:String = Configrations.GATEWAY;
			return url;
		}

		[Encrypt(key="PElRjzY_IOhkwb8L")]
		public static function get key():String
		{
			return "Are you going to hack?";
		}
		static public function execute(cmd:String,callback:Function,p:Object=null):void
		{
			var params:Object = p;
			if(!params){
				params = new Object;
			}
			params["commandName"] = cmd;
			params["uid"] = Configrations.userID;
			if(GameController.instance.localPlayer){
				params["gameuid"] = GameController.instance.localPlayer.gameuid;
			}
			if(GameController.instance.currentHero){
				params["heroid"] = GameController.instance.currentHero.characteruid;
			}
			RemotingOperation.TIMEOUT = 30000;
			var operation:RemotingOperation = new RemotingOperation(gateway,callback,callback);
			operation.method = cmd;
			operation.params = params;
			
			operation.commit();
		}
		
		//后台返回解析方法
		static public function StringAnaly(array:Array,string:String):void
		{
			if(string)
			{
				var array1:Array= new Array();
	            array1 = string.split(",");
	            for(var i : int =0;i<array1.length;i++) 
                {   
           	        var array2:Array = new Array();
           	       	var st :String ;
           	      	st = String(array1[i]);
           	      	if(st){
           	      		array2 = st.split(":"); 
           	      		array[i] = [array2[0],array2[1]];   
                  	 }
                }
            }
		}

		/**
		 * 检查接口调用是否成功，若不成功则显示错误信息
		 */
		static public function isSuccess(obj:Object):Boolean
		{
			var bool:Boolean=checkSuccess(obj,true);
			return bool;
		}
		
		private static var _restartCount:int = 0;
		/**
		 * 只检查，不打印
		 */
		static private function checkSuccess(obj:Object,bSetAcivity:Boolean=false):Boolean
		{
			try{
				if(obj && obj.__code == 0){
					return true;
				}else{
					trace("command error");
//					DialogController.instance.showPanel(new WarnnigTipPanel(LanguageController.getInstance().getString("systemTip02")));
//					if(_restartCount <=1){
//						GameController.instance.start();
//						_restartCount++;
//					}else{
//						DialogController.instance.showPanel(new ConfirmPanel(LanguageController.getInstance().getString("systemTip01"),function():void{
//							NativeApplication.nativeApplication.exit();
//						},function():void{},false));
//					}
				}
			}catch(e:Error){
				trace("command error");
			}
			return false;
		}
		
		static public function errorRefreh():void
		{
			
		}
		static public function timeOutHandler(code:String="",message:String=""):void
		{
		}
		
		
	}
}
