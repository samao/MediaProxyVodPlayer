package com.vhall.app.view.control.ui.progress
{
	import com.vhall.app.model.Model;
	import com.vhall.app.model.info.vo.UsrDataVo;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.HDragBar;
	import com.vhall.framework.ui.event.DragEvent;
	import com.vhall.framework.ui.utils.ComponentUtils;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;

	public class PlayProgressBar extends Box
	{
		protected var cuePoints:Vector.<CuePointItem>;

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
		private var bar:HDragBar;

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

		// 时间tips
		private var labelTips:TimeTips;

		//缩略图tips
		private var thumbTips:ThumbTips;

		override protected function createChildren():void
		{
			super.createChildren();
			// 进度条
			bar = new HDragBar(this);
			bar.addEventListener(DragEvent.HOVER, onBarHover);
			bar.addEventListener(DragEvent.UP, onBarClickUp);
			bar.addEventListener(MouseEvent.ROLL_OUT, onBarOut);
			bar.backgroundImage.source = ComponentUtils.genInteractiveRect(320, 10, null, 0, 0, 0x00FFFF);
			bar.finishBGImage.source = ComponentUtils.genInteractiveRect(320, 10, null, 0, 0, 0xff0000);
			bar.quadImage.visible = false;
			bar.bufferBGImage.visible = false;

			labelTips = new TimeTips();
			labelTips.hide();
			thumbTips = new ThumbTips();
			thumbTips.hide();
			onInitCuePoints();
		}

		override protected function updateDisplay():void
		{
			// TODO Auto Generated method stub
			super.updateDisplay();
			layoutCuePoints();
		}


		protected function onInitCuePoints():void
		{
			var tmpCue:CuePointItem;
			if(cuePoints && cuePoints.length > 0)
			{
				for(var j:int = 0; j < cuePoints.length; j++)
				{
					tmpCue = cuePoints[j];
					if(tmpCue && tmpCue.parent)
					{
						{
							tmpCue.removeFromParent();
						}
					}

				}
			}

			if(Model.docActionInfo.usrdata && Model.docActionInfo.usrdata.length > 0)
			{
				cuePoints = new Vector.<CuePointItem>();
				var cuDatas:Array = Model.docActionInfo.usrdata;

				for(var i:int = 0; i < cuDatas.length; i++)
				{
					tmpCue = new CuePointItem(this, cuDatas[i]);
					tmpCue.addEventListener(MouseEvent.ROLL_OVER, onCueOver);
					cuePoints[cuePoints.length] = tmpCue;
				}
			}

		}

		protected function onCueOver(event:MouseEvent):void
		{
			event.target.addEventListener(MouseEvent.ROLL_OUT, onCueOut);
			var cuePoint:CuePointItem = event.target as CuePointItem;
			showThumbTip(cuePoint.info);
		}

		protected function onCueOut(event:MouseEvent):void
		{
			event.target.removeEventListener(MouseEvent.ROLL_OUT, onCueOut);
			hideThumbTip();
		}

		protected function layoutCuePoints():void
		{
			if(cuePoints && cuePoints.length > 0)
			{
				var len:int = cuePoints.length;
				var tmpCue:CuePointItem;
				var tRate:int
				for(var i:int = 0; i < len; i++)
				{
					tmpCue = cuePoints[i];
					tRate = tmpCue.getTimeRate(2000);
					tmpCue.x = width * tRate * 0.01;
				}
			}
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

		}

		/**	划过*/
		private function onBarHover(e:DragEvent):void
		{
			labelTips.show(this);
			labelTips.data = e.percent * 1000 * 1000;
		}

		private function onBarOut(e:MouseEvent):void
		{
			labelTips.hide();
			thumbTips.hide();
		}

		/**
		 *显示缩略图
		 *
		 */
		protected function showThumbTip(usrVo:UsrDataVo):void
		{
			thumbTips.show(this);
			thumbTips.data = usrVo; //new UsrDataVo("hello", "", 1234);
		}

		/**
		 *隐藏缩略图
		 *
		 */
		protected function hideThumbTip():void
		{
			thumbTips.hide();
		}

		public function showCuePoint():void
		{
			onInitCuePoints();
			layoutCuePoints();
		}

		public function get proBar():HDragBar
		{
			return this.bar;
		}

		public function set currentTime(value:Number):void
		{
			bar.value = value;
		}
	}
}


