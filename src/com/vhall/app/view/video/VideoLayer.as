/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jun 28, 2016 10:09:13 AM
 * ===================================
 */

package com.vhall.app.view.video
{
	import com.vhall.app.common.Resource;
	import com.vhall.app.model.DataService;
	import com.vhall.app.model.MediaModel;
	import com.vhall.app.model.Model;
	import com.vhall.app.net.AppCMD;
	import com.vhall.app.view.video.command.VideoCMD;
	import com.vhall.app.view.video.ui.AudioModelPicComp;
	import com.vhall.app.view.video.ui.FastLayer;
	import com.vhall.app.view.video.ui.VideoInteractive;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.app.mvc.IResponder;
	import com.vhall.framework.load.ResourceLoader;
	import com.vhall.framework.media.provider.MediaProxyStates;
	import com.vhall.framework.media.provider.MediaProxyType;
	import com.vhall.framework.media.video.VideoPlayer;
	import com.vhall.framework.ui.container.Box;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;

	import appkit.responders.NResponder;

	public class VideoLayer extends FastLayer implements IResponder
	{
		private var _videoPlayer:VideoPlayer;

		/**播放时间当前位置计时器id*/
		private var _postionId:int;
		private const CHECKER_INTERVAL:uint = 250;
		/**上一次计时器获取的视频播放时间*/
		private var _preTime:Number = 0;

		private var _retryId:int;
		/**当前重试次数*/
		private var _retryTimes:uint = 0;
		/**拉流重试最大次数*/
		private const MAX_RETRY:uint = 16;

		/**麦克状态ui*/
		private var _micActivity:AudioModelPicComp;
		/**是否循环播放*/
		private var _loop:Boolean = true;

		private var _micActivBox:Box;
		//广告内容
		private var _adsBox:Box;
		//播放结束推荐内容
		private var _recBox:Box;

		//屏幕交互元件
		private var _videoInteractive:VideoInteractive;

		public function VideoLayer(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);

			_layerId = "videoLayer";
			//接入页面起始seek点(暂时都从0开始播放)
			//_preTime = Model.Me().playerstatusinfo.seekPosition;
		}

		/**
		 * 创建command和处理函数映射
		 */
		override protected function createCmdMapper():void
		{
			super.createCmdMapper();

			_commandMaper.mapTo(pause, AppCMD.VIDEO_CONTROL_PAUSE).mapTo(resume, AppCMD.VIDEO_CONTROL_RESUME).mapTo(seekPrecent, AppCMD.VIDEO_CONTROL_SEEK).mapTo(start, AppCMD.VIDEO_CONTROL_START).mapTo(stop,
				AppCMD.VIDEO_CONTROL_STOP).mapTo(toggle, AppCMD.VIDEO_CONTROL_TOGGLE).mapTo(volume, AppCMD.MEDIA_SET_VOLUME).mapTo(play, AppCMD.MEDIA_SWITCH_LINE).mapTo(play, AppCMD.MEDIA_SWITCH_QUALITY).mapTo(seek,
				AppCMD.CUE_POINT_CLICK).mapTo(changeVodMode, AppCMD.MEDIA_CHANGEVIDEO_MODE);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			info.player = _videoPlayer ||= VideoPlayer.create();
			_videoPlayer.volume = info.volume;
			addChild(_videoPlayer);

			_micActivBox ||= new Box();
			addChild(_micActivBox);

			mouseEnabled = false;

			_videoInteractive = new VideoInteractive(this);

			NResponder.addNative(_videoInteractive, VideoCMD.DOUBLE_CLICK, function():void
			{
				StageManager.toggleFullscreen();
			});
			NResponder.addNative(_videoInteractive, VideoCMD.SINGLE_CLICK, function():void
			{
				_videoPlayer.toggle();
			});

			//加载语音状态麦克皮肤
			var l:ResourceLoader = new ResourceLoader();
			l.load({type:1, url:Resource.getResource("MicrophoneActivity")}, function(item:Object, content:Object, domain:ApplicationDomain):void
			{
				_micActivity = new AudioModelPicComp();
				_micActivity.skin = content as MovieClip;
			}, null, function():void
			{
				log("加载语音状态资源失败");
			});

			//play();
		}

		/**
		 * 改变当前播放模式，mediamodel.videomode = false为视频模式，true为语音模式
		 */
		private function changeVodMode():void
		{
			log("videoMode:", info.videoMode);
			if(!info.videoMode)
			{
				_micActivity && _micActivBox.contains(_micActivity) && _micActivBox.removeChild(_micActivity);
				//_videoPlayer.start();
				_videoPlayer.visible = true;
			}
			else
			{
				_micActivity && _micActivBox.addChild(_micActivity);
				//_videoPlayer.stop();
				_videoPlayer.visible = false;
			}
			play();
		}

		/**
		 * 播放视频
		 */
		private function play():void
		{
			clearTimer();
			const server:String = MediaModel.me().netOrFileUrl;
			const stream:String = MediaModel.me().streamName;
			log("拉流地址：", protocol(server), server, stream, _preTime);

			if(_videoPlayer.type == null)
			{
				_videoPlayer.connect(protocol(server), "http:" + server, stream, videoHandler, true, _preTime);
			}
			else
			{
				_videoPlayer.attachType(protocol(server), "http:" + server, stream, true, _preTime);
			}
			_videoPlayer.visible = true;
		}

		/**
		 * 是否为直播或者推流
		 * @return
		 */
		private function get isLive():Boolean
		{
			return [MediaProxyType.RTMP, MediaProxyType.PUBLISH].indexOf(type) != -1;
		}

		/**
		 * 当前播放的视频类型
		 * @return
		 */
		private function get type():String
		{
			if(_videoPlayer)
				return _videoPlayer.type;
			return null;
		}

		/**
		 * 舞台resize时重绘视频大小
		 * @param w
		 * @param h
		 */
		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			_videoInteractive.setSize(w, h);
			if(stage)
			{
				var rect:Rectangle = null;

				if(stage.displayState != StageDisplayState.NORMAL)
				{
					rect = new Rectangle(0, 0, w, h);
				}
				else
				{
					//底部控制了高度
					const CONTROL_BAR_HEIGHT:uint = 0;
					rect = new Rectangle(0, 0, w, h - CONTROL_BAR_HEIGHT);
				}
				_videoPlayer.viewPort = rect;
			}
		}

		/**
		 * 根据业务逻辑和用户数据返回当前协议类型
		 * @param uri
		 * @return
		 */
		private function protocol(uri:String):String
		{
			if(uri.indexOf("rtmp://") == 0)
			{
				return MediaProxyType.RTMP
			}

			const p:String = uri.replace(/\?.+/ig, "");
			const exName:String = ".m3u8";
			const lastIndexExName:int = p.length - exName.length;
			if(lastIndexExName >= 0 && lastIndexExName == p.indexOf(exName))
			{
				return MediaProxyType.HLS;
			}

			return MediaProxyType.HTTP;
		}

		/**
		 * 计时器发送回放当前时间变更
		 */
		private function timeCheck():void
		{
			if(_videoPlayer.time == _preTime)
				return;
			_preTime = _videoPlayer.time;
			if(!isLive)
			{
				send(AppCMD.MEDIA_STATES_TIME_UPDATE);
			}
		}

		/**
		 * 清除计时器
		 */
		private function clearTimer():void
		{
			clearInterval(_postionId);
			clearTimeout(_retryId);
		}

		/**
		 * 播放失败尝试重连
		 */
		private function retry(result:String = ""):void
		{
			++_retryTimes;

			if(_retryTimes > MAX_RETRY)
			{
				//连接失败，抛到外层
				_retryTimes = 0;
				log("拉流重连尝试完毕，请手动刷新");
				return;
			}
			else
			{
				log("拉流失败", result, _retryTimes);
				if(_retryTimes == (MAX_RETRY >> 1) && DataService.connFailed2ChangeServerLine())
				{
					DataService.updateMediaInfo();
					log("更换拉流服务器");
				}
				play();
			}
		}

		private function videoHandler(states:String, ... value):void
		{
			//log("视频状态：",states);
			switch(states)
			{
				case MediaProxyStates.CONNECT_NOTIFY:
					log("通道建立成功");
					clearTimer();
					_postionId = setInterval(timeCheck, CHECKER_INTERVAL);
					_retryTimes = 0;
					loading = true;
					break;
				case MediaProxyStates.CONNECT_FAILED:
					clearTimer();
					retry(states);
					break;
				case MediaProxyStates.STREAM_NOT_FOUND:
					clearTimer();
					break;
				case MediaProxyStates.STREAM_START:
					log("拉流视频", _videoPlayer.stream && _videoPlayer.stream.info && _videoPlayer.stream.info.uri ? _videoPlayer.stream.info.uri + "/" + _videoPlayer.stream.info.resourceName : "");
					send(AppCMD.MEDIA_STATES_START);
					break;
				case MediaProxyStates.STREAM_PAUSE:
					send(AppCMD.MEDIA_STATES_PAUSE);
					break;
				case MediaProxyStates.STREAM_UNPAUSE:
					send(AppCMD.MEDIA_STATES_UNPAUSE);
					break;
				case MediaProxyStates.STREAM_STOP:
					send(AppCMD.MEDIA_STATES_FINISH);
					clearTimer();
					_preTime = 0;
					_loop && play();
					break;
				case MediaProxyStates.STREAM_TRANSITION:
				case MediaProxyStates.STREAM_FULL:
				case MediaProxyStates.PUBLISH_NOTIFY:
					loading = false;
					break;
				case MediaProxyStates.STREAM_LOADING:
				case MediaProxyStates.UN_PUBLISH_NOTIFY:
					loading = true;
					break;
				case MediaProxyStates.DURATION_NOTIFY:
					send(AppCMD.MEDIA_STATES_DURATION_UPDATE, [_videoPlayer.duration]);
					log("视频时长:" + _videoPlayer.duration);
					break;
				case MediaProxyStates.SEEK_COMPLETE:
					send(AppCMD.MEDIA_STATES_SEEK_COMPLETE);
					break;
				case MediaProxyStates.SEEK_FAILED:
					send(AppCMD.MEDIA_STATES_SEEK_FAIL);
					break;
				case MediaProxyStates.PROXY_ERROR:
					log("视频播放出错：", value[0]);
					break;
			}
		}

		/**
		 * 发送bufferloading 状态
		 * @param bool
		 */
		private function set loading(bool:Boolean):void
		{
			if(bool)
			{
				send(AppCMD.MEDIA_STATES_BUFFER_LOADING);
				send(AppCMD.UI_SHOW_LOADING);
			}
			else
			{
				send(AppCMD.MEDIA_STATES_BUFFER_FULL);
				send(AppCMD.UI_HIDE_LOADING);
					//send(AppCMD.UI_HIDE_WARN);
			}
		}

		/**
		 * MediaModel数据
		 * @return
		 */
		private function get info():MediaModel
		{
			return MediaModel.me();
		}

		//----------播放器控制
		private function seekPrecent(value:Number):void
		{
			seek(value * _videoPlayer.duration);
		}

		private function pause():void
		{
			_videoPlayer.pause();
		}

		private function resume():void
		{
			_videoPlayer.resume();
		}

		private function seek(value:Number):void
		{
			_videoPlayer.time = value / 1000;
		}

		private function start():void
		{
			_videoPlayer.start();
		}

		private function stop():void
		{
			_videoPlayer.stop();
		}

		private function toggle():void
		{
			_videoPlayer.toggle();
		}

		private function volume(value:Number):void
		{
			_videoPlayer.volume = value;
		}
	}
}

