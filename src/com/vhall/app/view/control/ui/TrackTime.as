package com.vhall.app.view.control.ui
{
	import com.vhall.app.common.components.TimeLabel;
	import com.vhall.framework.ui.container.HBox;
	import com.vhall.framework.ui.controls.Label;

	import flash.display.DisplayObjectContainer;

	/**
	 * 播放时间
	 * @author Sol
	 *
	 */
	public class TrackTime extends HBox
	{
		private var playTime:TimeLabel;

		private var duration:TimeLabel;

		private static const labelColor:uint = 0x6b6b6b;

		public function TrackTime(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			playTime = new TimeLabel(this);
			playTime.color = labelColor;
			const sp:Label = new Label(this);
			sp.color = labelColor;
			sp.text = "/";
			duration = new TimeLabel(this);
			duration.color = labelColor;
		}

		public function set currentTime(value:Number):void
		{
			playTime.ms = value;
		}

		public function set totalTime(value:Number):void
		{
			duration.ms = value;
		}
	}
}


