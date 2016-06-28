package com.vhall.app.view.control.ui.progress
{
	import com.vhall.app.common.components.TimeLabel;
	import com.vhall.app.model.Model;
	import com.vhall.app.model.info.vo.UsrDataVo;
	import com.vhall.framework.ui.controls.Image;
	import com.vhall.framework.ui.controls.Label;

	import flash.display.DisplayObjectContainer;

	public class ThumbTips extends AbsTipsBox
	{
		public function ThumbTips(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}
		/**	时间*/
		private var lblTime:TimeLabel;
		/**	文字描述*/
		private var lblDescribe:Label;
		/**	缩略图*/
		private var imgThumb:Image;

		override protected function createChildren():void
		{
			super.createChildren();

			lblTime = new TimeLabel(container);
			lblTime.color = 0xFF0000;
			lblDescribe = new Label(container, 0, 24);
			lblDescribe.color = 0xFF0000;
			imgThumb = new Image(container, 0, 48);
			imgThumb.setSize(140, 78);

			bg.setSize(140, 126);
		}

		override public function set data(value:*):void
		{
			var info:UsrDataVo = value as UsrDataVo;
			lblTime.ms = info.time;
			lblDescribe.text = info.msg;
			imgThumb.source = "http://cnhlsvodhls01.e.vhall.com" + info.picUrl; //"http://cnhlsvodhls01.e.vhall.com//vhallrecord/481859354/20160427154529/1553.jpg";
		}
	}
}
