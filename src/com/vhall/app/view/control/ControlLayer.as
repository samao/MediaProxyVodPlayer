package com.vhall.app.view.control
{
	import com.vhall.app.common.Layer;
	import com.vhall.app.net.AppCMD;
	import com.vhall.framework.app.mvc.IResponder;

	import flash.display.DisplayObjectContainer;

	public class ControlLayer extends Layer implements IResponder
	{
		/** 控制栏*/
		private var _viewBar:AbstractControlBar;

		public function ControlLayer(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			height = 50;
			bottom = 0;
		}

		override protected function init():void
		{
			super.init();
		}

		override protected function createChildren():void
		{
			super.createChildren();

			_viewBar = new ViewerControlBar(this);
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();
			_viewBar.width = width;
		}

		public function careList():Array
		{
			return [AppCMD.UI_AUTO_CHANGE_SERVERLINE];
		}

		public function handleCare(msg:String, ... args):void
		{
			switch(msg)
			{
				case 	AppCMD.UI_AUTO_CHANGE_SERVERLINE:
					if(_viewBar){
						(_viewBar as ViewerControlBar).onAutoChangeServeLine();
					}
					break;
			}
		}
	}
}


