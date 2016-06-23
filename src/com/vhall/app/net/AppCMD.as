package com.vhall.app.net
{
	public class AppCMD
	{
		private static const APP_BASE:String = "app_";
	
		
		
		/** 视频流数据状态相关*/
		private static const MEDIA:String = "media_";
		/** 设置音量,参数0~1*/
		public static const MEDIA_SET_VOLUME:String = MEDIA +　"setVolume";
		/**
		 *发送切换视频语音 
		 */		
		public static const MEDIA_CHANGEVIDEO_MODE:String = MEDIA+"changevideomode";
		/** 切换视频清晰度*/		
		public static const MEDIA_SWITCH_QUALITY:String = MEDIA +　"switchQuality";
		/** 切换视频线路*/
		public static const MEDIA_SWITCH_LINE:String = MEDIA + "switchLine";
		
		/** 弹幕相关*/
		private static const BARRAGE:String = "barrage_"
		/**
		 *发送弹幕 
		 */		
		public static const BARRAGE_ADD:String = BARRAGE + "add";
		/**	开启弹幕功能*/
		public static const BARRAGE_OPEN:String = BARRAGE + "open";
		public static const BARRAGE_CLOSE:String = BARRAGE + "close"
		
		/**
		 *ui相关 
		 */		
		public static const UI:String = "ui_";
		/**
		 *显示 loading
		 */		
		public static const UI_SHOW_LOADING:String = UI+"show_loading";
		/**
		 *显示 loading
		 */		
		public static const UI_HIDE_LOADING:String = UI+"hide_loading";
		
	}
}