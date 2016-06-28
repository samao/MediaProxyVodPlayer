package com.vhall.app.model.info.vo
{
	/**
	 *
	 *@author zhaoqinghao
	 *@data 2016-6-28 上午11:02:59
	 */
	public class UsrDataVo
	{
		public function UsrDataVo($msg:String,$pic:String,$timeP:Number)
		{
			msg = $msg;
			picUrl = $pic;
			time = $timeP * 1000;
		}
		public var msg:String;
		public var picUrl:String;
		public var time:int;
	}
}

