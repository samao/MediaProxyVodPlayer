package com.vhall.app.view.control.ui.progress
{
	import com.vhall.app.model.info.vo.UsrDataVo;
	import com.vhall.framework.ui.controls.UIComponent;

	import flash.display.DisplayObjectContainer;

	public class CuePointItem extends UIComponent
	{
		public function CuePointItem(parent:DisplayObjectContainer=null, tinfo:UsrDataVo = null, xpos:Number=0, ypos:Number=0)
		{
			info=tinfo;
			super(parent, xpos, ypos);
		}

		public var info:UsrDataVo;

		/**
		 *获取当前打点的时间比
		 */
		public function getTimeRate(ttTime:Number):int
		{
			return (info.time/(ttTime*1000))*100;
		}

		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
			this.graphics.beginFill(0xff,.8);
			this.graphics.drawRect(0,0,5,10);
			this.graphics.endFill();
		}

	}
}

