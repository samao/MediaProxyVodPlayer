package com.vhall.app.model.info
{
	/**
	 *
	 *@author zhaoqinghao
	 *@data 2016-6-23 上午11:10:01
	 */
	public class DocActionInfo extends BaseInfo
	{
		public function DocActionInfo()
		{
			super();
		}
		
		/**
		 *文档操作数据 
		 */		
		private var _msg_url:String ;
		
		/**
		 *文档打点数据 
		 */		
		public var cuepoint:Array;
		/**
		 *命令数据
		 */		
		public var usrdata:Array;
		
		
		public function get msg_url():String
		{
			return _msg_url;
		}
		/**
		 *文档数据 
		 * @param value
		 * 
		 */		
		public function set msg_url(value:String):void
		{
			_msg_url = value;
		}
		
		
	}
}