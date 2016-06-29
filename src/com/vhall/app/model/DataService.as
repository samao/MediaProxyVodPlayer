package com.vhall.app.model
{
	import com.vhall.app.model.info.PlayMode;
	import com.vhall.app.model.info.vo.ServeLinevo;
	import com.vhall.framework.log.Logger;

	import flash.utils.Dictionary;


	/**
	 *通用数据处理类
	 * @author zqh
	 *
	 */	
	public class DataService
	{
		public function DataService()
		{
		}

		/**
		 *更新观看模式
		 * @param isVideoMode true:音频模式 | false:视频模式
		 * @return
		 *
		 */		
		public static function onVideoModelChange(isVideoMode:Boolean):Boolean{
			Model.playerStatusInfo.viewVideoMode = isVideoMode;
			return true;
		}
		/**
		 *更新当前观看模式
		 *
		 */		
		public static function updatePlayTypeMode():void{
			var sline:String = "";
			if(Model.videoInfo && Model.videoInfo.selectLineVo){
				sline = Model.videoInfo.selectLineVo.serverUrl;
			}
			if(sline.toLocaleLowerCase().indexOf(PlayMode.HLS_FILE_SUFFIXES)>0){
				Model.playerStatusInfo.playMode = PlayMode.PLAY_HLS;
			}else{
				Model.playerStatusInfo.playMode = PlayMode.PLAY_RTMP;
			}
		}

		/**
		 *更新选择线路
		 */	
		public static function onSelectServerLine(slName:String):Boolean{
			var sfs:Array = Model.videoInfo.serverLineInfo;
			if(sfs && sfs.length > 0){
				for (var i:int = 0; i < sfs.length; i++) 
				{
					if(sfs[i].sName == slName && Model.videoInfo.selectLineVo != sfs[i]){
						Model.videoInfo.selectLineVo = sfs[i];
						return true;
					}
				}
			}
			return false;
		}
		/**
		 *连接线路失败后，重新切换到其他线路（数据切换）（失败过的线路会记录）
		 * @return 返回是否查找线
		 */		
		public static function connFailed2ChangeServerLine():Boolean{
			var fail:Dictionary;
			if(Model.videoInfo.failLines == null){
				Model.videoInfo.failLines = new Dictionary();
			}
			fail = Model.videoInfo.failLines;
			var currentUrl:String;
			if(Model.videoInfo.selectLineVo){
				currentUrl = Model.videoInfo.selectLineVo.serverUrl;
			}
			if(fail[currentUrl] == null){
				fail[currentUrl] = currentUrl;
			}
			var lines:Array = Model.videoInfo.serverLineInfo;
			var tmpLinevo:ServeLinevo;
			if(lines){
				for (var i:int = 0; i < lines.length; i++) 
				{
					tmpLinevo = lines[i];
					if(fail[tmpLinevo.serverUrl] == null && tmpLinevo.serverUrl != currentUrl){
						Model.videoInfo.selectLineVo = tmpLinevo;
						return true;
					}
				}
			}
			return false;
		}

		/**
		 *更新播放信息
		 * <br>1.rtmp 视频 需要复制 serverUrl +fileName 需要选择线路，清晰度
		 * <br>2 rtmp 语音 需要复制 serverUrl +fileName 需要选择线路，没有清晰度
		 * <br>3.hls 视频/视频 只需要给serverUrl 没有fileName 只需要选择线路，没有清晰度
		 */	
		public static function updateMediaInfo():void{
			updatePlayTypeMode();
			var initfail:int = 0;
			if(Model.playerStatusInfo == null) initfail = 1;
			if(Model.videoInfo == null) initfail = 2;
			if(Model.videoInfo.selectLineVo == null) initfail = 3;
			if(initfail > 0){
				Logger.getLogger("updateMediaInfo").info("初始化数据错误："+initfail);
				return;
			}
			//判断hls还是rtmp
			if(Model.playerStatusInfo.playMode == PlayMode.PLAY_HLS){
				//hls视频语音路径区分
				if(Model.playerStatusInfo.viewVideoMode){
					//当前线路视频地址
					MediaModel.me().netOrFileUrl = Model.videoInfo.selectLineVo.serverUrl;
				}else{
					//当前线路音频地址
					MediaModel.me().netOrFileUrl = Model.videoInfo.selectLineVo.serverAudio;
				}
			}else{
				if(Model.playerStatusInfo.viewVideoMode){
					//当前线路视频地址
					MediaModel.me().netOrFileUrl = Model.videoInfo.selectLineVo.serverUrl;
					MediaModel.me().streamName = Model.videoInfo.streamname;
				}else{
					//当前线路音频地址
					MediaModel.me().netOrFileUrl = Model.videoInfo.selectLineVo.serverAudio;
					MediaModel.me().streamName = Model.videoInfo.audioSrv;
				}
			}
		}

		/**
		 *更新推流服务器地址
		 * @param url
		 *
		 */		
		public static function updatePublisServerUrl(url:String):void{
			if(Model.videoInfo.media_srv != url){
				Model.videoInfo.media_srv = url
			}
			updatePublishInfo();
		}

		/**
		 *更新推流信息
		 *
		 */		
		public static function updatePublishInfo():void{
			MediaModel.me().publishUrl = Model.videoInfo.media_srv + "?token=" + Model.videoInfo.streamtoken;
			MediaModel.me().publishStreamName = Model.videoInfo.streamname;
			Logger.getLogger("updatePublishInfo").info("ps:" + MediaModel.me().publishUrl + "  sn:" + Model.videoInfo.streamname)
		}

	}

}

