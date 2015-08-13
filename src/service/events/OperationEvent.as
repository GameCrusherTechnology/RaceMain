package service.events
{
import flash.events.Event;

import service.command.AbstractOperation;

// operationEvent对于各种各样的event进行了封装，确保大家可以通过一个统一的事件名称来获得

public class OperationEvent extends Event
{
	public var subType:int;
	//操作的对象
	public var item:Object;
	
	
	//某一个operation的可以支持的event
	static public const OPERATION_ERROR:String="operation_error";//error 有两种action用来支持 
	
	static public const OPERATION_BEGIN:String="operation_begin";
	
	static public const OPERATION_FINISHED:String="operation_finished";
	
	static public const OPERATION_RETRY:String = "operation_retry";
	
	static public const OPERATION_LEVEL_CHANGE:String = "operation_level_change";
	
	static public const OPERATION_ADD_TO_QUEUE:String = "operation_add_to_queue";
	
	static public const OPERATION_REMOVE_TO_QUEUE:String = "operation_remove_to_queue";

	static public const OPERATION_DOING:String = "operation_doing";
	
	
	//operation manager支持的event
	static public const OPERATION_FINISHED_ALL:String = "operation_finished_all";
	
	
	
	// 针对sub_operation提供的支持
	static public const SUB_OPERATION_ADD:String = "sub_operation_add";
	
	static public const SUB_OPERATION_REMOVE:String = "sub_operation_remove";
	
	static public const SUB_OPERATION_ERROR:String = "sub_operation_error";
	
	static public const SUB_OPERATION_FINISHED:String = "sub_operation_finished";
	
	public var subOperation:AbstractOperation;
	
	
	
	// 用于具体的operation进行扩展的东西
	static public const OPERATION_ACTION:String = "operation_action";
	
	public var action:String;
	
	
	
	
	// 两种不同类型的error
	static public const INTERNAL_ERROR:String = "internal_error";
	
	static public const EXTERNAL_ERROR:String = "external_error";

	
	public var errorInfo:*;
	
	public var result:*;
	
	public var reasonEvent:Event;
	
	public var oldLevel:int;
	
	public var newLevel:int;
	
	private var bDefaultPrevented:Boolean=false;
	
	public function OperationEvent (type : String,bubbles : Boolean = false,cancelable : Boolean = false)
	{
		super (type, bubbles, cancelable);		
	}
	
	override public function clone():Event
	{
        var o:OperationEvent =  new OperationEvent(type);
		
		if(this.item)
		{
			o.item = this.item;
		}
		
		if(this.oldLevel)
		{
			o.oldLevel = oldLevel;
		}
		
		if(this.newLevel)
		{
			o.newLevel = newLevel;
		}
		
		if(this.action)
		{
			o.action = action;
		}
		
		if(this.result)
		{
			o.result = this.result;
		}
		
		if(this.errorInfo)
		{
			o.errorInfo = this.errorInfo;
		}
		
		if(this.reasonEvent)
		{
			o.reasonEvent = this.reasonEvent; 
		}
		
		return o;
	}
}
}