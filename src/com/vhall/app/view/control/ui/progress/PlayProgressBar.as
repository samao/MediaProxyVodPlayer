package com.vhall.app.view.control.ui.progress
{
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.HDragBar;
	import com.vhall.framework.ui.event.DragEvent;
	import flash.display.DisplayObjectContainer;

	public class PlayProgressBar extends Box
	{
		public function PlayProgressBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		private var bar:HDragBar;

		override protected function createChildren():void
		{
			super.createChildren();

			// 进度条
			bar = new HDragBar(this);
			bar.addEventListener(DragEvent.HOVER, onBarHover);
			bar.addEventListener(DragEvent.CLICK, onBarClick);
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();
			bar.width = width;
		}

		/**	点击*/
		private function onBarClick(e:DragEvent):void
		{

		}

		/**	划过*/
		private function onBarHover(e:DragEvent):void
		{

		}
	}
}
