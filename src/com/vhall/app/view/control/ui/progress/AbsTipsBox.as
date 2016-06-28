package com.vhall.app.view.control.ui.progress
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.Image;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
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

		protected var _data:*;

		public function show():void
		{
			this.visible = true;
		}

		public function hide():void
		{
			this.visible = false;
		}

		public function set data(value:*):void
		{
			this._data = value;
		}

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

			var s:Stage = StageManager.stage;
			tri.x = s.mouseX - tri.width / 2;
			container.x = s.mouseX - container.width / 2;
			if(container.x <= 0)
			{
				container.x = 0;
			}
			else if(container.x > s.stageWidth - container.width)
			{
				container.x = s.stageWidth - container.width;
			}
		}
	}
}
