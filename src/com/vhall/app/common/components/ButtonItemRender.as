package com.vhall.app.common.components
{
	import com.vhall.framework.ui.controls.ItemRender;
	import com.vhall.framework.ui.controls.ToggleButton;
	import com.vhall.framework.ui.interfaces.IItemRenderer;
	import com.vhall.framework.ui.utils.ComponentUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ButtonItemRender extends ItemRender
	{
		private var btnToggle:ToggleButton;

		public function ButtonItemRender(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			btnToggle = new ToggleButton(this);
			btnToggle.labelColor = 0xFF0000;
			btnToggle.skin = ComponentUtils.genInteractiveRect(60, 24, null, 0, 0, 0x00ffe4);
			btnToggle.overSkin = ComponentUtils.genInteractiveRect(60, 24, null, 0, 0, 0x6efff0);
			btnToggle.downSkin = ComponentUtils.genInteractiveRect(60, 24, null, 0, 0, 008476);
			btnToggle.addEventListener(Event.SELECT, onToggleHandler);
		}

		override public function set data(value:*):void
		{
			this._data = value;

			if(value.hasOwnProperty("name"))
			{
				btnToggle.label = value["name"];
			}
			else if(value.hasOwnProperty("label"))
			{
				btnToggle.label = value["label"];
			}
			else
			{
				btnToggle.label = value.toString();
			}
		}
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			btnToggle.selected = value;
		}
		
		override public function setSelected(value:Boolean):void
		{
			super.setSelected(value);
			btnToggle.setSelected(value);
		}

		private function onToggleHandler(e:Event):void
		{
			if(hasEventListener(Event.SELECT))
			{
				dispatchEvent(new Event(Event.SELECT));
			}
		}
	}
}
