package com.vhall.app.common.controller
{
	import com.vhall.app.net.VodWebBridge;
	import com.vhall.framework.app.common.Controller;
	import com.vhall.framework.app.net.MessageManager;
	import com.vhall.framework.log.Logger;

	/**
	 * 消息注册控制 
	 * @author Sol
	 * 
	 */	
	public class MessageController extends Controller
	{
		/**
		 * 消息注册 
		 * 
		 */		
		public function MessageController()
		{
		}
		
		override protected function initController():void
		{
			// 注册接收的回调
			Logger.getLogger("message init").info("initController");
			//注册消息收发
			MessageManager.getInstance().initWebBridge(new VodWebBridge());
			MessageManager.getInstance().addWebCallBack("sendMsgToAs");
		}
	}
}