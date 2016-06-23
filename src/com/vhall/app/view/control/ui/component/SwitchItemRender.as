package com.vhall.app.view.control.ui.component
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.controls.ItemRender;
	import com.vhall.framework.ui.controls.Label;
	
	import flash.display.DisplayObjectContainer;
	/**
	 * 用于list中渲染组件 
	 * @author zqh
	 * 
	 */	
	public class SwitchItemRender extends ItemRender
	{
		public function SwitchItemRender(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			this.setSize(80,20);
		}
		
		private var _overBgColor:uint = 0xE5403E;
		private var _outBgColor:uint = 0x000000;
		/**
		 *显示label 
		 */		
		protected var lab:Label;
		
		override protected function init():void
		{
			super.init();
			update4Select();
		}
		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
			lab = new Label(this);
			lab.fontSize = 14;
			lab.color = 0x6b6b6b;
			lab.mouseChildren = lab.mouseEnabled = false;
		}
		
		protected function initDrawBg():void{
			this.graphics.clear()
			this.graphics.beginFill(outBgColor,70);
			this.graphics.drawRect(0,0,this._width,this._height);
			this.graphics.endFill();
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		protected function overDrawBg():void{
			this.graphics.clear()
			this.graphics.beginFill(overBgColor,85);
			this.graphics.drawRect(0,0,this._width,this._height);
			this.graphics.endFill();
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		/**
		 *更新显示文本 
		 * 
		 */		
		protected function update4Label(move:Boolean =false):void{
			if(selected || move){
				lab.color = 0xFFFFFF;
			}else{
				lab.color = 0x6b6b6b;
			}
		}
		/**
		 *更新item 
		 * 
		 */		
		protected function updateItem():void{
			if(data == null) return;
			lab.text = data.label;
			this.lab.textField.width = this.lab.textField.textWidth + 4;
			this.lab.move((this.width - this.lab.width) >> 1,(this.height - this.lab.height) >>1);
		}
		
		override public function onMouseClick():void
		{
			// TODO Auto Generated method stub
			super.onMouseClick();
		}
		
		override public function onMouseOut():void
		{
			// TODO Auto Generated method stub
			super.onMouseOut();
			update4Select();
			update4Label();
		}
		
		override public function onMouseOver():void
		{
			// TODO Auto Generated method stub
			super.onMouseOver();
//			overDrawBg();
			update4Label(true);
		}
		
		override public function set selected(value:Boolean):void
		{
			// TODO Auto Generated method stub
			super.selected = value;
			update4Select();
			update4Label();
		}
		
		
		override public function set data(value:*):void
		{
			// TODO Auto Generated method stub
			super.data = value;
			updateItem();
		}
		
		override public function setSize(w:Number, h:Number):void
		{
			// TODO Auto Generated method stub
			super.setSize(w, h);
			update4Select();
			updateItem();
		}
		
		/**
		 *更新背景颜色 
		 * 
		 */		
		public function update4Select():void{
			if(selected){
				overDrawBg();
			}else{
				initDrawBg()
			}
		}
		
		/**
		 *常态背景 
		 * @return 
		 * 
		 */		
		public function get outBgColor():uint
		{
			return _outBgColor;
		}
		
		public function set outBgColor(value:uint):void
		{
			_outBgColor = value;
			update4Select();
		}
		/**
		 * 移入背景 
		 * @return 
		 * 
		 */		
		public function get overBgColor():uint
		{
			return _overBgColor;
		}
		
		public function set overBgColor(value:uint):void
		{
			_overBgColor = value;
			update4Select();
		}
		
	}
}