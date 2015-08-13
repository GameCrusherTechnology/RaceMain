package view.panel
{
	import starling.events.Event;

	public class PanelConfirmEvent extends Event
	{
		public static const CONFIRM:String = "panelconfirm";
		public static const CANCEL:String = "panelcancel";
		public static const CLOSE:String = "panelclose";
		public var BeConfirm:Boolean = false;
		public function PanelConfirmEvent(_closetype:String)
		{
			BeConfirm = (_closetype == CONFIRM);
			super(CLOSE);
		}
	}
}