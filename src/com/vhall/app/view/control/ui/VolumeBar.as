package com.vhall.app.view.control.ui
{
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.Button;
	
	import flash.display.DisplayObjectContainer;
	
	public class VolumeBar extends Box
	{
		public var volumeBtn:Button;
		public var volumeSlipComp:VolumeDragBar;
		public function VolumeBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
			volumeSlipComp = new VolumeDragBar();
			this.addChild(volumeSlipComp);
		}
		/**
		 *设置bg是否可见 
		 * @param vs
		 * 
		 */		
		public function setBgVisible(vs:Boolean):void{
			volumeSlipComp.bgVisible = vs;
		}
		
		public function set volumeValue(value:int):void{
			volumeSlipComp.percent = value/100;
		}
		/**
		 * 声音大小
		 * @return 
		 * 
		 */		
		public function get volumeValue():int{
			return (volumeSlipComp.percent* 100);
		}
		
	}
}