package com.vhall.app.view.control.ui.progress
{
	import com.vhall.app.common.components.TimeLabel;
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.Label;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;

	/**
	 * 时间tips
	 * @author Sol
	 * @date 2016-06-27 15:12:57
	 */
	public class TimeTips extends AbsTipsBox
	{

		public function TimeTips(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		private var lblTime:TimeLabel;

		override protected function createChildren():void
		{
			super.createChildren();

			lblTime = new TimeLabel(container);
			lblTime.autoStart = false;
			lblTime.color = 0xFF0000;
		}

		override public function set data(value:*):void
		{
			super.data = value;
			lblTime.ms = value;
			bg.width = lblTime.width;
			container.width = lblTime.width;
			RenderManager.getInstance().invalidate(invalidate);
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
//			this.y = -tri.height - container.height;
//			tri.y = container.height;
//			var s:Stage = StageManager.stage;
//			tri.x = s.mouseX - tri.width / 2;
//			if(s.mouseX - container.width / 2 < 0)
//			{
//				container.x = 0;
//			}
//			else if(s.mouseX + container.width / 2 > s.stageWidth)
//			{
//				container.x = s.stageWidth - container.width;
//			}
//			else
//			{
//				container.x = s.mouseX - container.width / 2;
//			}
		}
	}
}
