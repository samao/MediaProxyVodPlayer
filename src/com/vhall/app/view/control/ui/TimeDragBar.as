package com.vhall.app.view.control.ui
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.controls.UIComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * 观看拖动条
	 * <br><li>监听视频start事件,开始计时器;
	 *<br><li>拖动后 停止计时器,视频播放后再次开始计时器，已便于时间进度更新
	 *@author zhaoqinghao
	 *@data 2016-6-23 下午4:23:39
	 */
	public class TimeDragBar extends UIComponent
	{
		/**
		 *循环标示 
		 */		
		protected var loopUint:uint;
		/**
		 *时间条背景 
		 */		
		protected var timebg:Shape;
		/**
		 *播放到的时间 
		 */		
		protected var ctime:Number = 0;
		/**
		 * 时间条前景
		 */		
		protected var stepBg:Shape;
		
		/**
		 *当前进度 
		 */		
		public var playPercent:Number = 0;
		public var isDown:Boolean = false;
		public function TimeDragBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
			timebg = new Shape();
			this.addChild(timebg);
			stepBg=  new Shape();
			this.addChild(stepBg);
		}
		
		override protected function init():void
		{
			// TODO Auto Generated method stub
			super.init();
			this.addEventListener(MouseEvent.CLICK,onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		override protected function sizeChanged():void
		{
			// TODO Auto Generated method stub
			super.sizeChanged();
			this.width = StageManager.stageWidth;
			updateTimeBg();
			updateStepBg();
		}
		
		/**
		 *当鼠标安下，监听up事件(更新进度)，监听stage拖动事件(更新时间tip,更新进度) 
		 * @param event
		 * 
		 */		
		protected function onMouseDown(event:MouseEvent):void
		{
			isDown = true;
			// TODO Auto-generated method stub
			StageManager.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,onMouseUp);
			StageManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			isDown =false;
			// TODO Auto-generated method stub
			StageManager.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,onMouseUp);
			this.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,onMouseUp);
			StageManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			//抛事件 通知seek
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(isDown){
				dragorClickStep();
			}
			updateTipTime();
		}
		
		protected function onStageMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			dragorClickStep();
			updateTipTime();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			dragorClickStep();
			//抛事件 通知seek
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 *更新背景 
		 * 
		 */		
		protected function updateTimeBg():void{
			timebg.graphics.clear();
			timebg.graphics.beginFill(0x111111,.8);
			timebg.graphics.drawRect(0,0,StageManager.stageWidth,15);
			timebg.graphics.endFill();
			
		}
		
		/**
		 *更新进度 
		 * 
		 */		
		protected function updateStepBg():void{
			stepBg.graphics.clear();
			stepBg.graphics.beginFill(0xff0000,.8);
			stepBg.graphics.drawRect(0,0,_width*playPercent,15);
			stepBg.graphics.endFill();
		}
		
		/**
		 *拖动或点击执行 
		 * <br>停止loop
		 * <br>计算位置，刷新ui;
		 */		
		protected function dragorClickStep():void{
			stopLoop();
			var mx:Number = StageManager.stage.mouseX;
			//0--1区间
			var step:Number = Math.max(0,Math.min(1,mx / this._width));
			if(this.playPercent == step) return;
			this.playPercent = step;
			stopLoop();
			updateCTime()
			updateStepBg();
		}
		/**
		 *更新当前时间 
		 * 总时间*playPercent
		 */		
		protected function updateCTime():void{
			ctime = 999 * playPercent;
		}
		
		/**
		 *计算时长 
		 * 
		 */		
		protected function updateTipTime():void{
			
		}
		
		/**
		 *计算进度 
		 * 
		 */		
		protected function onLoop():void
		{
			// TODO Auto Generated method stub
			//计算时间
			var ct:Number = ctime+0.05;
			//如果当前播放时间没有变则返回
			if(ct == ctime) return;
			ctime = ct;
			var tt:Number = 30;
			playPercent = ct/tt;
			updateStepBg();
		}
		/**
		 *开始循环更新时间进度
		 * 
		 */		
		public function stopLoop():void{
			clearTimeout(loopUint);
		}
		/**
		 *停止循环更新时间进度
		 * 
		 */		
		public function startLoop():void{
			stopLoop();
			loopUint = setInterval(onLoop,30)
		}
		
		/**
		 *tip显示时间 
		 * @return 
		 * 
		 */		
		public function get showTime():String{
			return "00:10";
		}
		
		override public function destory():void
		{
			// TODO Auto Generated method stub
			super.destory();
			stopLoop();
		}
		
	}
}