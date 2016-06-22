package com.vhall.app.view.debug
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.log.LogEvent;
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.ui.container.Box;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	public class LogInfo extends Box
	{
		private var txLogs:TextField;
		
		public function LogInfo(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			txLogs = new TextField();
			txLogs.width = StageManager.stageWidth;
			txLogs.height = StageManager.stageHeight * 0.8;
			txLogs.textColor = 0xFFFFFF;
			txLogs.selectable = true;
			txLogs.wordWrap = true;
			addChild(txLogs);
			DisplayObject(Logger.mcOutputClip).addEventListener(LogEvent.Changed, onLogChanged);
		}
		
		public function onLogChanged(e:LogEvent):void
		{
			txLogs.appendText(e.time + " " +e.content);
			txLogs.appendText("\n");
			txLogs.scrollV = txLogs.maxScrollV;
		}
	}
}