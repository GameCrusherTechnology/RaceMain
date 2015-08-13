package service
{
	import flash.events.EventDispatcher;
	
	import service.command.AbstractOperation;
	import service.events.OperationEvent;

public class OperationManager extends EventDispatcher
{
	public var _operation:Array = new Array ();
	
	public var _lowOperation:Array = new Array();

	private var _cuurentOperation:AbstractOperation;

	private static var _instance:OperationManager;
	public static function getInstance():OperationManager
	{
		if(!_instance){
			_instance = new OperationManager;
		}
		return _instance;
	}
	public function OperationManager():void
	{
		
	}
	
	//获得队列实例
	public function getOperation():Array
	{
		return _operation;
	}
	
	public function add (o : AbstractOperation):void
	{
		addToQueue(o);
	}
	
	private function registerOpt(t:AbstractOperation):void 
	{
		t.addEventListener (OperationEvent.OPERATION_ERROR,operationFinishedHandler,false,-1);
		t.addEventListener (OperationEvent.OPERATION_FINISHED,operationFinishedHandler);
	}
	
	private function unregisterOpt(t:AbstractOperation):void 
	{
		t.removeEventListener (OperationEvent.OPERATION_FINISHED,operationFinishedHandler);
		t.removeEventListener (OperationEvent.OPERATION_ERROR,operationFinishedHandler);
	}
	
	private function addToQueue(o:AbstractOperation):void 
	{
		var level:Number = o.level;
		
		if(level==AbstractOperation.LOW)
		{
			registerOpt(o);
			o.dispatchEvent (new OperationEvent (OperationEvent.OPERATION_ADD_TO_QUEUE));
			_lowOperation.push (o);
		}
		else if(level==AbstractOperation.NORMAL)
		{
			registerOpt(o);
			o.dispatchEvent (new OperationEvent (OperationEvent.OPERATION_ADD_TO_QUEUE));
			_operation.push (o);
		}else if(level==AbstractOperation.HIGH)
		{
			o.dispatchEvent (new OperationEvent (OperationEvent.OPERATION_ADD_TO_QUEUE));
			o._begin();
			return;
		}
		
		if(!this._cuurentOperation)
		{
			_runOperation ();
		}
	}
	
	
	//用于将已经放入队列的取出来和addToQueue是对应的,如果返回的值为true,那么就是说明以前在队列里面现在给删除了
	private function removeQueue(opt:AbstractOperation):Boolean
	{
		if(opt.status!=AbstractOperation.PENDING)
		{
			return false;
		}
		
		var b:Boolean = clearFromQueue(opt);
		if(b)
		{
			opt.dispatchEvent (new OperationEvent (OperationEvent.OPERATION_REMOVE_TO_QUEUE));
			//Debug.trace(" opt remove from que "+opt);
		}
		if (b&&_operation.length == 0&&_lowOperation.length==0)
		{
			_finishOperation ();
		}
		return b;
	}
	
	
	private function clearFromQueue(opt:AbstractOperation):Boolean
	{
		
		var i:int=0;
		var oo:Array = _operation;
		var ooo:Array = _lowOperation;
		
		for (i = 0; i < _operation.length; i ++)
		{
			if (_operation [i] == opt)
			{
				_operation.splice (i, 1)[0];
				
				return true;
			}
		}
		
		for (i = 0; i < _lowOperation.length; i++)
		{
			if (_lowOperation [i] == opt)
			{
				_lowOperation.splice (i, 1)[0];
				
				return true;
			}
		}
		return false;
	}
	
	public function destroyCurrent ():void
	{
		_cuurentOperation.destroy ();
		this.unregisterOpt(_cuurentOperation);
		_cuurentOperation = null;
	}
	
	
	public function get currentOperation():AbstractOperation
	{
		return this._cuurentOperation;
	}
	
	private function operationFinishedHandler(evt:OperationEvent):void
	{
		var target:AbstractOperation = evt.target as AbstractOperation;
		this.unregisterOpt(target);
		
		if (_cuurentOperation && _cuurentOperation == target)
		{
			_runOperation ();
		}else
		{
			//对于其他那些游离于operationManager之外的不作考虑
		}
	}

	public function operationLevelChange(target:AbstractOperation):void
	{
		if (_cuurentOperation&&_cuurentOperation == target)
		{
			//如果是就放弃
		}else
		{
			//level的切换要考虑到status的问题(主要是处理那些在队列里面的情况）
			//opt 转换level有两种情况，
			//1，原来在队列中的，需要执行（包括调高到级别为HIGH的)
			//2，不在队列中的，直接修改Level就可以了
			// 从HIGH调到LOW NORMAL的 不需要处理，从LOW NORMAL调到HIGH的立即执行了
			if(removeQueue(target))
			{
				addToQueue(target);
			}
		}
	}
	
	/*
	* 该函数检测任务队列，如果还有任务，就启动一个新的任务
	* 如果任务全部运行完了，则调用_finishOperation，使得manager进入休息状态
	*/ 
	private function _runOperation ():void
	{
		if(_cuurentOperation)
		{
			clearFromQueue(_cuurentOperation);
			_cuurentOperation = null;
		}
		if (_operation.length > 0)
		{
			_beginOperation (AbstractOperation (_operation.shift ()));
		}else if(_lowOperation.length>0)
		{
			_beginOperation (AbstractOperation (_lowOperation.shift ()));
		}else
		{
			_finishOperation ();
		}
	}
	
	
	
	private function _beginOperation (o : AbstractOperation):void
	{
		_cuurentOperation = o;
		trace("start _cuurentOperation " +_cuurentOperation.toString());
		_cuurentOperation._begin ();
	}
	
	private function _finishOperation ():void
	{
		
	}
	
}
}
