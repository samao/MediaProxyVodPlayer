package com.vhall.app.view.control
{
	import com.vhall.app.common.Layer;
	import com.vhall.framework.app.mvc.IResponder;
	
	import flash.display.DisplayObjectContainer;
	
	public class ControlLayer extends Layer implements IResponder
	{
		/** 控制栏*/
		private var bar:AbstractControlBar;
		private var _viewBar:AbstractControlBar;
		
		public function ControlLayer(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			height = 45;
			bottom = 0;
		}

		override protected function init():void
		{
			super.init();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			setToView();
		}
		
		override protected function sizeChanged():void
		{
			super.sizeChanged();
			bar.width = width;
		}
		
		protected function setToView():void
		{
			if(bar) bar.removeFromParent();
			bar = _viewBar ||= new ViewerControlBar();
			this.addChild(bar);
		}
		
		public function careList():Array
		{
			return [
			];
		}
		
		public function handleCare(msg:String, ...args):void
		{
			switch(msg)
			{
			}
		}
	}
}