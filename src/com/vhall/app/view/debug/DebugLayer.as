package com.vhall.app.view.debug
{
	import com.vhall.app.common.components.ButtonItemRender;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.container.ViewStack;
	import com.vhall.framework.ui.controls.Button;
	import com.vhall.framework.ui.controls.TabBar;
	import com.vhall.framework.ui.event.ListEvent;
	import com.vhall.framework.ui.manager.PopupManager;
	import com.vhall.framework.ui.utils.ComponentUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DebugLayer extends Box
	{
		public function DebugLayer(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		private var tab:TabBar;
		
		/**	容器*/
		private var container:ViewStack;
		
		private var btnClose:Button;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			// 导航组件
			tab = new TabBar(TabBar.HORIZONTAL, this);
			tab.dataProvider = ["log","流媒体"];
			tab.itemRender = ButtonItemRender;
			tab.addEventListener(ListEvent.IndexChanged, onChanged);
			
			// 关闭按钮
			btnClose = new Button(this);
			btnClose.skin = ComponentUtils.genInteractiveRect(20,20,null,0,0,0xC0C0C0,1,2);
			btnClose.label = "X";
			btnClose.right = 10;
			btnClose.y = 10;
			btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
			
			// 容器
			container = new ViewStack(this,0,30);
			container.addChild(new LogInfo());
			container.addChild(new StreamInfo());
		}
		
		protected function onChanged(e:ListEvent):void
		{
			container.selectedIndex = e.index;
		}
		
		override protected function sizeChanged():void
		{
			super.sizeChanged();
			width = StageManager.stageWidth;
			height = StageManager.stageHeight;
		}
		
		protected function onBtnCloseClick(event:MouseEvent):void
		{
			PopupManager.removePopup(this);
		}
		
	}
}