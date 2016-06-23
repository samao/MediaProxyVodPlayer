package com.vhall.app.net
{
	import com.vhall.framework.app.net.MessageManager;
	import com.vhall.framework.app.net.WebBridge;

	public class WebAJMessage
	{
		
		private static var sender:WebBridge = MessageManager.getInstance().getBridge();
			
		/**
		 *发送打点数据 
		 * @param data
		 * 
		 */		
		public static function sendRecordMsg(data:Object):void{
			sender.sendRecordMsg(data);
		}
	}
}