/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jun 29, 2016 3:21:01 PM
 * ===================================
 */

package com.vhall.app.view.video.ui
{
	import com.vhall.app.view.video.command.VideoCMD;
	import com.vhall.framework.ui.container.Box;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	import appkit.responders.NResponder;

	/**
	 * 视频层双击单击交互
	 */	
	public class VideoInteractive extends Box
	{
		private var _bg:Sprite;

		private var _lastClickTime:Number = 0;

		private var id:Number = NaN;

		private const DELTA:uint = 350;

		public function VideoInteractive(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			_bg = new Sprite();
			_bg.graphics.beginFill(0xFF0000,0);
			_bg.graphics.drawRect(0,0,100,100);
			_bg.graphics.endFill();
			this.addChild(_bg);

			this.mouseChildren = false;
			this.mouseEnabled = true;

			addEventListener(MouseEvent.CLICK,clickHandler);
		}

		protected function clickHandler(event:MouseEvent):void
		{
			if(!isNaN(id))
			{
				clearInterval(id);
				sendCmd(VideoCMD.DOUBLE_CLICK);
				return;
			}
			id = setTimeout(function():void
			{
				sendCmd(VideoCMD.SINGLE_CLICK);
			},DELTA);
		}

		private function sendCmd(cmd:String):void
		{
			id = NaN;
			NResponder.dispatch(cmd,null,this);
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			_bg.width = _width;
			_bg.height = _height;
		}

		public function hide():void
		{
			visible = false;
		}

		public function show():void
		{
			visible = true;
		}
	}
}

