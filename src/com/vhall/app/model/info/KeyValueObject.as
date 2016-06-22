package com.vhall.app.model.info
{
	/**
	 * 基于键值对的数据格式类型 , cdn服务器， 播放文件内容啊 什么的
	 * @author Sol
	 * 
	 */	
	public class KeyValueObject extends BaseInfo
	{
		public var key:*;
		
		public var value:*;
		
		public function KeyValueObject()
		{
			super();
		}
	}
}