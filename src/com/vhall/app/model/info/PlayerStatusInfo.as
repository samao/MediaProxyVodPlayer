package com.vhall.app.model.info
{

	/**
	 * 播放器状态信息
	 *@author zhaoqinghao
	 *@data 2016-6-7 下午1:19:19
	 */
	public class PlayerStatusInfo extends BaseInfo
	{
		public function PlayerStatusInfo()
		{
			super();
		}

		/*** 是否隐藏线路选择器*/
		public var hideLineSwitch:Boolean;
		/*** 是否隐藏微吼的相关标识*/
		public var hide_powered:Boolean;
		/***是否显示线路（cdn线路切换）*/
		public var lineType:int = 1;
		/***当前播放模式（RTMP/HLS） */
		public var playMode:String = PlayMode.PLAY_HLS;
		/***是否显示音频切换  */
		public var streamType:int = 1;
		public var viewVideoMode:Boolean = true;
	}
}


