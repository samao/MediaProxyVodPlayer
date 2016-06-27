package com.vhall.app.view.control.ui.progress
{
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.event.DragEvent;
	import flash.display.DisplayObjectContainer;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;

	public class PlayProgressBar extends Box
	{

		public function PlayProgressBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		/**
		   *循环标示
			  */
		protected var loopUint:uint;
		/**
		 *timebar
		 */
		private var bar:TimeHBar;

		private var ctime:Number = 0;

		/**
		 *停止循环更新时间进度
		 *
		 */
		public function startLoop():void
		{
			stopLoop();
			loopUint = setInterval(onLoop, 30)
		}

		/**
		 *开始循环更新时间进度
		 *
		 */
		public function stopLoop():void
		{
			clearTimeout(loopUint);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			// 进度条
			bar = new TimeHBar(this);
			bar.addEventListener(DragEvent.HOVER, onBarHover);
			bar.addEventListener(DragEvent.UP, onBarClickUp);

		}

		/**
		 *计算进度
		 *
		 */
		protected function onLoop():void
		{
			//计算时间
			var ct:Number = ctime + 0.02;
			//如果当前播放时间没有变则返回
			if(ct == ctime)
				return;
			ctime = ct;
			var tt:Number = 30;
			bar.percent = ct / tt;
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();
			bar.width = width;
		}

		/**	点击*/
		private function onBarClickUp(e:DragEvent):void
		{
			stopLoop();

		}

		/**	划过*/
		private function onBarHover(e:DragEvent):void
		{

		}
	}
}


