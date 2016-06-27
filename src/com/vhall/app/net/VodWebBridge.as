package com.vhall.app.net
{
	import com.vhall.framework.app.net.WebBridge;
	
	/**
	 *
	 *@author zhaoqinghao
	 *@data 2016-6-27 上午11:06:55
	 */
	public class VodWebBridge extends WebBridge
	{
		public function VodWebBridge()
		{
			super();
		}
		
		/**
		 * 记录数据发送
		 * @param body 信息
		 *
		 */		
		public function sendRecordMsg(body:Object):void{
			super.sendMsg4Type("sendRecordMsg", "recordMsg", body);
		}
	}
}