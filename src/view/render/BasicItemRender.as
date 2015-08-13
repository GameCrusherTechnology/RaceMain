package view.render
{
	import feathers.controls.Label;
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	public class BasicItemRender extends DefaultListItemRenderer
	{
		public function BasicItemRender()
		{
		}
		
		protected var itemLabel:Label;
		
		
		override protected function initialize():void
		{
			if(!this.itemLabel)
			{
				this.itemLabel = new Label();
				this.addChild(this.itemLabel);
			}
		}
		
		
		override protected function commitData():void
		{
			if(this._data)
			{
				this.itemLabel.text = this._data.toString();
			}
			else
			{
				this.itemLabel.text = "";
			}
		}
		
		protected function layout():void
		{
			this.itemLabel.width = this.actualWidth;
			this.itemLabel.height = this.actualHeight;
		}
	}
}