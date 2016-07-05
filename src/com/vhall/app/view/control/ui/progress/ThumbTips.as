package com.vhall.app.view.control.ui.progress
{
	import com.hurlant.util.Base64;
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

			lblDescribe = new Label(container, 0, 78);
			lblDescribe.color = 0xFFFFFF;
			imgThumb = new Image(container, 1, 1);
			imgThumb.setSize(116, 66);
			lblTime = new TimeLabel(container, 0, 60);
			lblTime.color = 0xFFFFFF;
		}

		override public function set data(value:*):void
		{
			var info:UsrDataVo = value as UsrDataVo;
			lblTime.ms = info.time;
			lblDescribe.text = Base64.decode(info.msg).replace('\r', '');
			lblDescribe.width = lblDescribe.textField.textWidth + 4;
			imgThumb.source = "http:" + Model.videoInfo.media_srv + info.picUrl; //"http://cnhlsvodhls01.e.vhall.com//vhallrecord/481859354/20160427154529/1553.jpg";
			container.height = 102;
			bg.setSize(142, 102);
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			lblDescribe.x = (142 - lblDescribe.width) >> 1;
		}
	}
}


