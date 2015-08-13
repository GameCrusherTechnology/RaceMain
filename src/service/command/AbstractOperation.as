package service.command
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

import service.OperationManager;
import service.events.OperationEvent;

[Event(name="operation_error",type="elex.event.OperationEvent")]
	
[Event(name="operation_begin",type="elex.event.OperationEvent")]
	
[Event(name="operation_finished",type="elex.event.OperationEvent")]
	
[Event(name="operation_retry",type="elex.event.OperationEvent")]
	
[Event(name="operation_level_change",type="elex.event.OperationEvent")]
	
[Event(name="operation_add_to_queue",type="elex.event.OperationEvent")]

[Event(name="operation_remove_to_queue",type="elex.event.OperationEvent")]
	
[Event(name="operation_doing",type="elex.event.OperationEvent")]

[Event(name="propertyChange",type="mx.events.PropertyChangeEvent")]

public class AbstractOperation extends EventDispatcher 
{
	public static const WORKING:String = "working";
	
	public static const WAITING:String = "waiting";
	
	public static const PENDING:String = "pending";
	
	
	public static const HIGH:int=3;
	
	public static const NORMAL:int=2;
	
	public static const LOW:int=1;
	
	//新加的
	private var _description:String;
	
	public var name:String;
	
	public var cancelable:Boolean = true;
	
	//存在三种级别的operation 最高的为high,operationManager会让他立即执行
	// normal是第二个级别的
	// low是第三个级别的，这个级别的事件是在normal队列的全部都完成了再执行
	private var _level:Number = NORMAL; 
	
	//waiting 等待被commit   pending 放入队列中但是还没有执行  working 正在执行
	public var status:String = WAITING;

	//用来存储一些临时性质的变量，
	private var operationValue:Object;
	
	private var commitLaterTimer:Timer;
	
	private var _displayProgressOnCommit:Boolean = false;
	
	
	private var styleObject:Object;
	
	
	public function AbstractOperation(sHandler:Function=null,eHandler:Function=null)
	{
		if(sHandler!=null)
		{
			this.addEventListener(OperationEvent.OPERATION_FINISHED,sHandler);
		}
		if(eHandler!=null)
		{
			this.addEventListener(OperationEvent.OPERATION_ERROR,eHandler);
		}
	}
	
	public function get isIndeterminate():Boolean
	{
		return false;
	}
	


	
	public function commitLater(delay:int):void
	{
		this.commitLaterTimer = new Timer(delay,1);
        this.commitLaterTimer.addEventListener(TimerEvent.TIMER, commitLaterHandler,false, 0, true);
        this.commitLaterTimer.start();
	}
	
	private function commitLaterHandler(evt:TimerEvent):void
	{
		this.commitLaterTimer.removeEventListener(TimerEvent.TIMER, commitLaterHandler);
	    this.commitLaterTimer.stop();
	    this.commit();
	    this.commitLaterTimer = null;
	}
	public function setValue(name:String,value:*):void
	{
		if(!this.operationValue)
		{
			this.operationValue = new Object();
		}
		this.operationValue[name] = value;
	}
	
	public function getValue(name:String):*
	{
		return this.operationValue[name];
	}
	
	
	public function moveToHigh():void
	{
		this.level = HIGH;
	}
	
	public function moveToLow():void 
	{
		this.level = LOW;
	}
	
	public function moveToNormal():void 
	{
		this.level = NORMAL;
	}
	
	/*
	* 必须调用这个才能够执行
	*/ 
	public function commit():Object
	{
		
		//处于等待被commit的状态
		if(status==WAITING)
		{
			OperationManager.getInstance().add(this);
		}else if(status==PENDING)
		{
			//已经在队列里面了
		}else if(status==WORKING)
		{
			throw(new Error("此处可能存在问题"));
			this.cancel();
			OperationManager.getInstance().add(this);
		}
		return null;
	}
	
	override public function dispatchEvent(evt:Event):Boolean 
	{
		var e:OperationEvent = evt as OperationEvent;
		if(e)
		{
			switch (e.type)
			{
				case OperationEvent.OPERATION_BEGIN:
				break;
				case OperationEvent.OPERATION_FINISHED:
				case OperationEvent.OPERATION_ERROR:
				break;
				
				case OperationEvent.OPERATION_ADD_TO_QUEUE:
				break;
			}
		}
		
		var b:Boolean = super.dispatchEvent(evt);
		//应该放在后面来改
		
		if(e)
		{
			switch (e.type)
			{
				case OperationEvent.OPERATION_BEGIN:
				this.status=WORKING;

				break;
				
				case OperationEvent.OPERATION_FINISHED:
				case OperationEvent.OPERATION_ERROR:
				//是否需要
				case OperationEvent.OPERATION_REMOVE_TO_QUEUE:
				this.status=WAITING;
				this.reset();
				

				break;
				
				case OperationEvent.OPERATION_ADD_TO_QUEUE:
				this.status=PENDING;
				break;
			}
			return b;
		}else
		{
			return true;
		}
	}
	
	

	
	override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
	{
		super.addEventListener(type,listener,useCapture,priority,true);
	}
	

	
	public function cancel():void
	{
		if(this.status!=WAITING)
		{
			this.end();
			var evt:OperationEvent = new OperationEvent(OperationEvent.OPERATION_ERROR);
			evt.action = OperationEvent.EXTERNAL_ERROR;
			this.dispatchEvent(evt);
		}
	}
	
	
	public function _begin():void 
	{
		this.begin();
		this.dispatchEvent (new OperationEvent (OperationEvent.OPERATION_BEGIN));
	}
	
	//需要扩展的方法,不是直接调用的，而是由operationManager来调用的
	// 用于启动一个operation
	protected function begin ():void 
	{
	}
	
	//需要扩展的方法,不是直接调用的，而是由operationManager来调用的
	// 用于强制终止一个operation
	protected function end():void
	{
		
	}	
	// 任何时候，无论是成功执行还是强制被终止，都会调用该方法
	protected function reset():void
	{
		
	}

	public function destroy():void
	{
		cancel();
	}
	
	public function get finishedAmount():Number
	{
		return -1;
	}	
	
	public function get totalAmount():Number
	{
		return -1;
	}
	
	public function set level(l:Number):void 
	{
		if(l!=_level)
		{
			var evt:OperationEvent = new OperationEvent(OperationEvent.OPERATION_LEVEL_CHANGE);
			evt.oldLevel=_level;
			evt.newLevel=l;
			_level=l;
			dispatchEvent(evt);
			OperationManager.getInstance().operationLevelChange(this);
		}
	}
	
	public function get level():Number
	{
		return this._level;
	}
	
	[Bindable]
	public var description:String;
}

}