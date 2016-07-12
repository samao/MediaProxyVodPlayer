/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jun 2, 2016 5:18:59 PM
 * ===================================
 */

package com.vhall.app.model
{
	import com.vhall.framework.app.manager.SOManager;
	import com.vhall.framework.media.video.IVideoPlayer;

	/**
	 * 视频相关信息
	 */	
	public class MediaModel
	{
		private static var _instance:MediaModel;
		/** 禁止摄像头*/
		public var cameraMute:Boolean = false;
		/** 禁止麦克风*/
		public var microphone:Boolean = false;
		/** 当前播放音量*/
		public var volume:Number = 0.68;
		/** netconnection地址或者文件路径*/
		public var netOrFileUrl:String = "//cnhlsvodhls01.e.vhall.com//vhallrecord/995192982/20160627112633/record.m3u8";

		/** 流名称*/		
		public var streamName:String = "12";
		/**
		 *推流地址
		 */		
		public var publishUrl:String = "";
		/**
		 *推流 流名
		 */	
		public var publishStreamName:String = "";

		public var player:IVideoPlayer;

		/**默认为true视频模式，false为语音*/		
		public var _videoMode:Boolean = false;

		public var defaultDefination:String = "high";

		public var _soCamera:String = null;
		public var _soMicrophone:String = "";
		public var _soCamWidth:uint = 320;
		public var _soCamHeight:uint = 280;
		public function MediaModel()
		{
			if(_instance) return;

			update();
		}

		public function update():void
		{
			var obj:Object = SOManager.getInstance().getValue("setting");
			this._soCamera = obj.cameraName == "禁用视频设备/无设备"?null:obj.cameraName;
			_videoMode = _soCamera!=null;
			this._soCamWidth = obj.width||854;
			this._soCamHeight = obj.height||480;
			this._soMicrophone = obj.micName;
			this.volume = obj.micVolume||.68;
//			this.videoMode = Boolean(Model.Me().meetinginfo.videoMode);
		}

		/**默认为true视频模式，false为语音*/
		public function get videoMode():Boolean
		{
			return Model.Me().playerstatusinfo.videoMode == 1||_videoMode;
		}

		/**
		 * @private
		 */
		public function set videoMode(value:Boolean):void
		{
			_videoMode = value;
		}

		public static function me():MediaModel
		{
			return _instance ||= new MediaModel();
		}
	}
}

