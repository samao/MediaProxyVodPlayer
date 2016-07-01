package com.vhall.app.view.control.ui.progress
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.Image;

	import flash.display.DisplayObject;
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
			mouseChildren = mouseEnabled = false;
		}

		// 背景，九宫格
		protected var bg:Image;

		// 容器
		protected var container:Box;

		protected var _data:*;

		public function show(p:DisplayObjectContainer):void
		{
			if(p)
			{
				p.addChild(this);
			}
			this.visible = true;
		}

		public function hide():void
		{
			this.removeFromParent();
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

			bg = new Image(container);
			bg.source = "ui/tbg.png";
			bg.rect = new Rectangle(2, 2, 10, 10);
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			var s:Stage = StageManager.stage;
			this.y = -container.height;
			if(s.mouseX - container.width / 2 < 0)
			{
				container.x = 0;
			}
			else if(s.mouseX + container.width / 2 > s.stageWidth)
			{
				container.x = s.stageWidth - container.width;
			}
			else
			{
				container.x = s.mouseX - container.width / 2;
			}
		}
	}
}


