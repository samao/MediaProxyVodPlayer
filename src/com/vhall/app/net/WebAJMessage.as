package com.vhall.app.net
{
	import com.vhall.framework.app.net.MessageManager;

	public class WebAJMessage
	{
		
		private static var sender:VodWebBridge = MessageManager.getInstance().getBridge() as VodWebBridge;
			
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