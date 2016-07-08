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
		
		/**
		 *ui相关 
		 */		
		public static const UI:String = "ui_";
		
		/**
		 *自动更新serverline 
		 */		
		public static const UI_AUTO_CHANGE_SERVERLINE:String = "ui_auto_change_serverline";
		/**
		 *显示 loading
		 */		
		public static const UI_SHOW_LOADING:String = UI+"show_loading";
		/**
		 *显示 loading
		 */		
		public static const UI_HIDE_LOADING:String = UI+"hide_loading";
		
		/**	视频播放控制相关*/
		private static const VIDEO:String = "video_";
		/** 视频播放开始*/
		public static const VIDEO_CONTROL_START:String = VIDEO +　"controlStart";
		/** 外部控制视频暂停*/
		public static const VIDEO_CONTROL_RESUME:String = VIDEO + "controlResume";
		/** 播放器暂停*/
		public static const VIDEO_CONTROL_PAUSE:String = VIDEO + "controlPause";
		/**切换播放器播放暂停状态*/
		public static const VIDEO_CONTROL_TOGGLE:String = VIDEO + "controlToggle";
		/** 回放视频seek*/
		public static const VIDEO_CONTROL_SEEK:String = VIDEO + "controlSeek";
		/** 回放视频停止播放*/
		public static const VIDEO_CONTROL_STOP:String = VIDEO + "controlStop";
		
		/**视频播放状态通知*/
		private static const MEDIA_STATES:String = "mediaState_";
		/** 视频播放开始*/
		public static const MEDIA_STATES_START:String = MEDIA_STATES + "start";
		/** 视频播放完毕*/
		public static const MEDIA_STATES_FINISH:String = MEDIA_STATES + "finish";
		/** 视频播放暂停*/
		public static const MEDIA_STATES_PAUSE:String = MEDIA_STATES + "pause";
		/** 视频播放暂停恢复*/
		public static const MEDIA_STATES_UNPAUSE:String = MEDIA_STATES + "unpause";
		/** 视频seek失败*/
		public static const MEDIA_STATES_SEEK_FAIL:String = MEDIA_STATES + "seekFail";
		/** 视频seek成功*/
		public static const MEDIA_STATES_SEEK_COMPLETE:String = MEDIA_STATES + "seekComplete";
		/**	填充buffer*/		
		public static const MEDIA_STATES_BUFFER_LOADING:String = MEDIA_STATES + "bufferLoaing";
		/** buffer填充完成*/
		public static const MEDIA_STATES_BUFFER_FULL:String = MEDIA_STATES + "bufferFull";
		/** 更新视频时长*/
		public static const MEDIA_STATES_DURATION_UPDATE:String = MEDIA_STATES + "durationUpdate";
		/** 播放头位置更新*/
		public static const MEDIA_STATES_TIME_UPDATE:String = MEDIA_STATES + "timeUpdate";
		/**
		 *打点数据加载完毕 
		 */		
		public static const DATA_CUEPOINT_COMP:String = "data_cuepoint_loaded";
		
		/**	锚点数据点击了*/
		public static const CUE_POINT_CLICK:String = "cur_point_click";
		
	}
}