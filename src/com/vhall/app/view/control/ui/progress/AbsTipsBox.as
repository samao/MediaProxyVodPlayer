package com.vhall.app.view.control.ui.progress
{
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.Image;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;

	/**
	 * 抽象tips容器
	 * @author Sol
	 *
	 */
	public class AbsTipsBox extends Box
	{
		public function AbsTipsBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		// 背景，九宫格
		protected var bg:Image;

		// 容器
		protected var container:Box;

		// 三角
		protected var tri:Image;

		override protected function createChildren():void
		{
			super.createChildren();

			container = new Box(this);
			tri = new Image(this);
			tri.source = "assets/ui/tipBottom.png";

			bg = new Image(container);
			bg.source = "assets/ui/tipBG.png";
			bg.rect = new Rectangle(2, 2, 10, 10);
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			tri.y = -tri.height;
			container.y = tri.y - container.height + 2;
		}
	}
}
