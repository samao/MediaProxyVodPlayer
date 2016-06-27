package  com.vhall.app.view.control.ui.progress
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.controls.HDragBar;
	import com.vhall.framework.ui.utils.ComponentUtils;

	import flash.display.DisplayObjectContainer;

	/**
	 *
	 *@author zhaoqinghao
	 *@data 2016-6-27 下午2:35:54
	 */
	public class TimeHBar extends HDragBar
	{
		public function TimeHBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override protected function initSize():void
		{
			// TODO Auto Generated method stub
			super.initSize();
			this.width = 320;
			this.height = 15;
		}

		override protected function initSkin():void
		{
			bg.source = ComponentUtils.genInteractiveRect(320, 15, null, 5, 10, 0x111111);
			buffer.source = ComponentUtils.genInteractiveRect(320, 15, null, 5, 10, 0x111111);
			finished.source = ComponentUtils.genInteractiveRect(320, 15, null, 5, 10, 0xff0000);
			quad.visible = false;
			bg.visible = false;
		}

	}
}

