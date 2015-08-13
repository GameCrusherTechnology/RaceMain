package service.command
{
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import gameconfig.MD5;
	import gameconfig.SystemDate;
	
	import service.events.OperationEvent;
	
	public class RemotingOperation extends AbstractOperation
	{
		public static var TIMEOUT:Number = 120000; // 2 minutes
		
		public static var SIG_KEY:String = "";
		
		private var connection:NetConnection;
		
		public var method:String;
		
		public static var COUNT:int=0;
		
		public static  var CURSORID:int=-1;
		
		public var timeStamp:Number=0;
		
		//参数约定为一个对象，这样我们能统一处理
		private var _params:Object;
		
		public static var INDEX:int=0;
		
		public function set params(p:Object):void
		{
			if(!p){
				p = new Object();
			}
			
			
			this._params = p;
			this._params['__index']=INDEX;
		}
		
		public function getHashString(o:Object):String
		{
			var key:String = "";
			var list:Array = [];
			for( var k:String in o ) {
            	var object:Object = new Object();
				object.key = k;
				if( o[k] is Boolean ) {
					//object.value = int(o[k]);
					if(o[k]){
						object.value = int(o[k]);
					}else{
						object.value = "";
					}
				} else if(o[k] is String || o[k] is Number) {
					object.value = o[k];
				}else{
					object.value = getHashString(o[k]);
				}
				list.push(object);
            }
            var array:Array = list.sortOn("key");
            if( array ) {
	            for( var i:int = 0; i < array.length; i++ ) {
	            	key += array[i].key + array[i].value;
	            }
            }
            
            return key;
		}
		public function get params():Object
		{
			var o:Object = new Object;
			for( var v:String in this._params ) {
				o[v] = this._params[v];
			}
						
			var key:String = SIG_KEY;
			key += getHashString(o);
			
            o.k = String(MD5.hash(key)).toUpperCase();

			return o;
		}
		
		private var successHandler:Function;
		
		private var errorHandler:Function;
		
		private var timeoutId:int;
		
		override public function toString():String
		{
			return "remote operation method " +this.method;
		}
		
		override public function get isIndeterminate():Boolean
		{
			return true;
		}
		
		public function RemotingOperation(gateway:String,sHandler:Function=null,eHandler:Function=null)
		{
			
			if(gateway == null) {
				throw new Error("The gateway parameter is required in the ServiceProxy class.");
			}
			
			this.connection = new NetConnection();
			connection.client = this;
			connection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
			connection.addEventListener(IOErrorEvent.IO_ERROR, onConnectionError);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR , onConnectionError);
			this.connection.connect(gateway);
			
			if(sHandler!=null)
			{
				this.successHandler = sHandler;
			}
			if(eHandler!=null)
			{
				this.errorHandler = eHandler;
			}
			
		}
		
		override protected function begin ():void
		{
			var responder:Responder = new Responder(this.onResult,this.onError);
			this.connection.call("BaseCommand.callCommand",responder,this.params);
			this.timeoutId = setTimeout(onTimeout, RemotingOperation.TIMEOUT);
			RemotingOperation.COUNT++;
			RemotingOperation.INDEX++;
			timeStamp=getTimer();
			
		}
		
		private function onTimeout():void {
			this.onError();
		}

		private function onConnectionError(event:ErrorEvent):void {
			this.onError();
		}

		private function onConnectionStatus(evt:NetStatusEvent):void
		{
			switch(evt.info.code) {
				case "NetConnection.Connect.Failed":
				case "NetConnection.Call.Failed":
					this.onError();	
					break;
			}

		}
				
		private function onResult(data:Object):void
		{
			if(data&& ("__index" in data)&& Number(data.__index)>RemotingOperation.INDEX){
				RemotingOperation.INDEX=Number(data.__index);
			}
			RemotingOperation.COUNT--;
			
			clearTimeout(this.timeoutId);
			if(data&&data.__end_time){
				SystemDate.systemTime = data.__end_time;
			}
			
			if(this.successHandler != null)
			{
				this.successHandler(data);
			}
			var o:OperationEvent = new OperationEvent(OperationEvent.OPERATION_FINISHED,false,true);
			o.item = data;
			this.dispatchEvent(o);
		}
		
		private function onError(data:Object=null):void
		{
			var str:String=this.method;
			if(str){
				str=str.replace('.','_');
			}else{
				str="";
			}

			RemotingOperation.COUNT--;
			clearTimeout(this.timeoutId);
			
			if(this.errorHandler != null)
			{
				this.errorHandler(data);
			}
			var o:OperationEvent = new OperationEvent(OperationEvent.OPERATION_ERROR,false,true);
			this.dispatchEvent(o);			
		}
	}
}