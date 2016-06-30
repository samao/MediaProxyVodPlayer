package com.vhall.app.view.control
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.tween.AppTween;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.Image;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 抽象控制栏
	 * <br> 当自身交互时会停止舞台交互判断,防止鼠标在自身操作是隐藏,如果不需要，
	 * 请重写addLocalLsn() 与removeLocalLsn()方法
	 * @author Sol
	 *
	 */
	public class AbstractControlBar extends Box
	{
		public var checkTimer:uint;
		public var HIDE_CHECK_TIME:int = 1000;
		/**	背景图*/
		private var bg:Image;

		public function AbstractControlBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function init():void
		{
			super.init();
		}

		override protected function createChildren():void
		{
			super.createChildren();
			// 背景
			bg = new Image(this);
			bg.rect = new Rectangle(4,4,10,10);
			bg.source = "assets/ui/bg.png";

			// 默认来一发
			onStageMouseMove(null);
			StageManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFull);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();
			bg.width = width;
			bg.height = height;
		}

		protected function onAddStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveStage);
			addStageLsn();
		}

		protected function onRemoveStage(event:Event):void
		{
			// TODO Auto-generated method stub
			removeStageLsn();
		}

		/**
		 *监听鼠标移入
		 *
		 */		
		protected function addStageLsn():void{
			StageManager.stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			StageManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			StageManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			addLocalLsn();

		}
		/**
		 *移除 鼠标移动，鼠标一处，鼠标移入
		 *
		 */		
		protected function removeStageLsn():void{
			StageManager.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			StageManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,onStageMouseDown);
			StageManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			removeLocalLsn();

		}

		/**
		 *自身监听和stage监听分离  隐藏优化监听
		 *
		 */		
		protected function addLocalLsn():void{
			if(!this.hasEventListener(MouseEvent.ROLL_OVER)){
				this.addEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			}
		}

		/**
		 *自身监听和stage监听分离
		 *
		 */	
		protected function removeLocalLsn():void{
			this.removeEventListener(MouseEvent.ROLL_OVER,onMouseOver);
			this.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}

		/**
		 *鼠标移入时监听鼠标移动和移出  并且停止鼠标检测（防止鼠标在controlbar时，继续执行隐藏检测）
		 *
		 */		
		protected function onMouseOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.addEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.stopMouseCheck();
		}

		/**
		 *鼠标移出，开始执行舞台鼠标交互检测
		 * @param event
		 *
		 */		
		protected function onMouseOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			//加入rect判断,如果还在bar内部隐藏bar;
			var rect:Rectangle = this.getRect(StageManager.stage);
			if(rect.containsPoint(new Point(StageManager.stage.mouseX,StageManager.stage.mouseY)))
			{
				return;
			}
			this.removeEventListener(MouseEvent.ROLL_OUT,onMouseOut);
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			this.startMouseCheck();
		}	
		/**
		 *移动式停止冒泡，防止舞台检测鼠标交互导致隐藏controlbar
		 * @param event
		 *
		 */		
		protected function onMouseMove(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			event.stopImmediatePropagation();
		}


		protected function onStageMouseDown(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(!checkSelfChild(event.target as DisplayObject)){
				clearTimeout(checkTimer);
				checkTimer = setTimeout(onDelayCheckMouse, HIDE_CHECK_TIME);
				Mouse.show();
				showBar();
			}
		}

		/**
		 *检测是否自己
		 *
		 */		
		protected function checkSelfChild(dsp:DisplayObject):Boolean{
			var boo:Boolean = false;
			if(dsp && dsp.parent){
				if(dsp.parent == this){
					return true;
				}else{
					return checkSelfChild(dsp.parent);
				}
			}
			return false;
		}

		protected function onStageMouseMove(event:MouseEvent):void
		{
			clearTimeout(checkTimer);
			checkTimer = setTimeout(onDelayCheckMouse, HIDE_CHECK_TIME);
			Mouse.show();
			showBar();
		}

		protected function onStageMouseLeave(event:Event):void
		{
			clearTimeout(checkTimer);
			checkTimer = setTimeout(onDelayCheckMouse, 200);
		}

		/**
		 *发送隐藏控制栏通知
		 *
		 */
		protected function onDelayCheckMouse():void
		{
			if(StageManager.stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				Mouse.hide();
			}
			hideBar();
		}

		protected function onFull(e:FullScreenEvent):void
		{

		}

		/**	显示控制栏*/
		protected function showBar():void
		{
			AppTween.to(this, .45, {y:0});
			onShow();
		}

		/**	隐藏控制栏*/
		protected function hideBar():void
		{
			AppTween.to(this, .35, {y:this.height});
			onHide();
		}

		protected function onShow():void{
			addLocalLsn();
		}

		protected function onHide():void{
			removeLocalLsn();
		}

		override public function destory():void
		{
			super.destory();
			removeStageLsn();
		}

		/**
		 *停止交互检测  停止检测后，不会隐藏控制栏
		 *
		 */		
		public function stopMouseCheck():void{
			clearTimeout(checkTimer);
			showBar();
		}
		/**
		 *开始检测，最少两秒后隐藏控制栏
		 *
		 */	
		public function startMouseCheck():void{
			clearTimeout(checkTimer);
			checkTimer = setTimeout(onDelayCheckMouse, HIDE_CHECK_TIME);
		}


		/**
		 * 禁用/启用
		 * @param enable
		 *
		 */		
		public function setEnable(enable:Boolean):void{
			this.mouseEnabled = this.mouseChildren = enable;
		}

	}
}


