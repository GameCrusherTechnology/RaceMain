package gameconfig
{
	import flash.utils.getTimer;

	public class SystemDate
	{
		public function SystemDate()
		{
		}
		
		private static var _systemTime:Number;
//		public static var timeReduce:Number ;
		private static var date:Date;
		
		public static function set systemTime(serverTime:Number):void
		{
//			date = new Date();
//			timeReduce  = date.getTime()- serverTime*1000;
			_systemTime = (serverTime-Math.floor(getTimer()/1000));
		}
		
		
		//秒级
		public static function get systemTimeS():Number
		{
//			date = new Date();
//			if(isNaN(timeReduce)){
//				return Math.floor(date.getTime()/1000);
//			}
//			return Math.floor((date.getTime() - timeReduce)/1000);
			
			return _systemTime +  Math.floor(getTimer()/1000);
		}
		public static function getTimeLeftString(time:Number):String
		{
			//大于一天
			if(time > 24*3600*365){
				return Math.floor(time/(24*3600*365)) + "y";
			}
			else if(time > 24*3600){
				return Math.floor(time/(24*3600)) + "d";
			}else{
				var h:int = Math.floor((time)/(3600));
				var m:int = Math.floor((time%3600)/(60));
				var s:int = time%60;
				return  checkNum(h) +":"+checkNum(m) + ":"+checkNum(s) ;
			}
		}
		public static function getTimeMinLeftString(time:Number):String
		{
			//大于一天
			if(time > 24*3600*365){
				return Math.floor(time/(24*3600*365)) + "y";
			}
			else if(time > 24*3600){
				return Math.floor(time/(24*3600)) + "d";
			}else if(time > 3600){
				return Math.floor(time/(3600)) + "h";
			}else{
				var m:int = Math.floor((time%3600)/(60));
				var s:int = time%60;
				return  checkNum(m) + ":"+checkNum(s) ;
			}
		}
		public static function getMsTimeLeftString(time:Number):String
		{
			if(time > 3600000){
				return Math.floor(time/(36000)) + "h";
			}else if(time > 60000){
				return Math.floor(time/(60000)) + "m";
			}else{
				return time/(1000) + "s";
			}
		}
		
		public static function getSTimeLeftString(time:Number):String
		{
			if(time > 3600){
				return Math.floor(time/(36000)) + "h";
			}else if(time > 60){
				return Math.floor(time/(60000)) + "m";
			}else{
				return time + "s";
			}
		}
		
		private static function checkNum(num:int):String
		{
			if(num < 10){
				return "0"+String(num);
			}
			return String(num);
		}
		
	}
}