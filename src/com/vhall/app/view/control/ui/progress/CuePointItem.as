package com.vhall.app.view.control.ui.progress
{
	import appkit.responders.NResponder;

	import com.vhall.app.model.info.vo.UsrDataVo;
	import com.vhall.app.net.AppCMD;
	import com.vhall.framework.ui.controls.UIComponent;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	public class CuePointItem extends UIComponent
	{
		public function CuePointItem(parent:DisplayObjectContainer = null, tinfo:UsrDataVo = null, xpos:Number = 0, ypos:Number = 0)
		{
			info = tinfo;
			super(parent, xpos, ypos);
			useHandCursor = buttonMode = true;
			addEventListener(MouseEvent.CLICK, onItemClickHandler);
		}

		public var info:UsrDataVo;

		/**
		 *获取当前打点的时间比
		 */
		public function getTimeRate(ttTime:Number):int
		{
			return (info.time / (ttTime * 1000)) * 100;
		}

		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
			this.graphics.beginFill(0xababab);
			this.graphics.drawRoundRect(0,1,5,8,3,3);
			this.graphics.endFill();
		}

		private function onItemClickHandler(e:MouseEvent):void
		{
			NResponder.dispatch(AppCMD.CUE_POINT_CLICK, [this.info.time]);
		}

	}
}

