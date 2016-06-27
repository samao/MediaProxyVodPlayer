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
			Logger.getLogger("message init").info("initController");
			// 注册接收的回调
			MessageManager.getInstance().addWebCallBack("sendMsgToAs");

			// 注册web接收
			MessageManager.getInstance().initWebBridge(new VodWebBridge());
		}
	}
}
