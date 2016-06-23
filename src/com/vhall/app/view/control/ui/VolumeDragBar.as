package com.vhall.app.view.control.ui
{
	import com.vhall.framework.ui.controls.HDragBar;
	import com.vhall.framework.ui.utils.ComponentUtils;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class VolumeDragBar extends HDragBar
	{
		public function VolumeDragBar()
		{
			super();
		}
		
		override protected function initSize():void
		{
			// TODO Auto Generated method stub
			_w = 95;
			_h = 24;
		}
		
		override protected function onDragStart(e:MouseEvent = null):void
		{
			super.onDragStart();
			quad.startDrag(false, new Rectangle(-quad.width/2+10, quad.y, width - quad.width/2, 0));
			draging = true;
		}
		
		override protected function initSkin():void{
			bg.source = getBgSource();
			buffer.source = ComponentUtils.genInteractiveRect(94, 6, null, 5, 10, 0x000000);
			finished.source = ComponentUtils.genInteractiveRect(94, 6, null, 5, 10, 0XDE403D);
			quad.source = ComponentUtils.genInteractiveRect(21, 21, null,0,0,0x000000);
			quadSkin = "assets/ui/quad.png";
			quad.setSize(18,18);
			buffer.move(5,10);
			finished.move(5,10);
		}
		
		protected function getBgSource():Shape{
			var shp:Shape = new Shape();
			shp.graphics.beginFill(0x363636,.8);
			shp.graphics.drawRoundRect(0,0,_w,_h,5,5);
			shp.graphics.endFill();
			return shp
		}
		/**
		 *设置bg是否显示
		 * @param visible
		 * 
		 */		
		public function set bgVisible(visible:Boolean):void{
			bg.visible = visible
		}
	}
}