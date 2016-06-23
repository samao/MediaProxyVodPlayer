package com.vhall.app.view.control.ui.component
{
	import com.vhall.framework.ui.controls.Button;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	/**
	 *
	 *@author zhaoqinghao
	 *@data 2016-6-7 下午6:17:21
	 */
	public class SwitchBtn extends Button
	{
		public function SwitchBtn(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			this.setSize(74,24);
			this.skin = btnUpBg;
//			this.overSkin = btnOverBg;
			this.labelSize = 14;
			this.labelColor = 0x6b6b6b;
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			// TODO Auto Generated method stub
			super.setSize(w, h);
			this.skin = btnUpBg;
//			this.overSkin = btnOverBg;
		}
		
		
		protected function get btnUpBg():Shape{
			var shp:Shape = new Shape();
			shp.graphics.beginFill(0x6b6b6b);
			shp.graphics.drawRoundRect(0,0,_width,_height,9,9);
			shp.graphics.endFill();
			shp.graphics.beginFill(0x4c4c4c);
			shp.graphics.drawRoundRect(1,1,_width-2,_height-2,6,6);
			shp.graphics.endFill();
			shp.graphics.beginFill(0x191919);
			shp.graphics.drawRoundRect(2,2,_width-4,_height-4,4,4);
			shp.graphics.endFill();
			return shp
		}
		
//		protected function get btnOverBg():Shape{
//			var shp:Shape = new Shape();
//			shp.graphics.beginFill(0xE81926);
//			shp.graphics.drawRoundRect(0,0,_width,_height,9,9);
//			shp.graphics.endFill();
//			shp.graphics.beginFill(0x4c4c4c);
//			shp.graphics.drawRoundRect(1,1,_width-2,_height-2,6,6);
//			shp.graphics.endFill();
//			shp.graphics.beginFill(0xE94644);
//			shp.graphics.drawRoundRect(2,2,_width-4,_height-4,4,4);
//			shp.graphics.endFill();
//			return shp
//		}
		
		override protected function sizeChanged():void
		{
			super.sizeChanged();
		}
		
		override protected function updateDisplay():void
		{
			super.updateDisplay();
		}
	}
}