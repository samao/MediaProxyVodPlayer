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
	import com.vhall.app.common.Layer;
	import com.vhall.app.model.DataService;
	import com.vhall.app.model.MediaModel;
	import com.vhall.app.net.AppCMD;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.app.mvc.IResponder;
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.media.provider.MediaProxyStates;
	import com.vhall.framework.media.provider.MediaProxyType;
	import com.vhall.framework.media.video.VideoPlayer;

	import flash.display.DisplayObjectContainer;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;

	import appkit.responders.NResponder;

	public class VideoLayer extends Layer implements IResponder
	{
		private var _videoPlayer:VideoPlayer;

		/**播放时间当前位置计时器id*/
		private var _postionId:int;
		/**上一次计时器获取的视频播放时间*/
		private var _preTime:Number = 0;

		private var _retryId:int;
		/**当前重试次数*/
		private var _retryTimes:uint = 0;
		/**拉流重试最大次数*/
		private const MAX_RETRY:uint = 16;

		private var _commandMaper:ICommandMapper;

		public function VideoLayer(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			createCmdMapper();
			super(parent, xpos, ypos);
		}

		private function createCmdMapper():void
		{
			_commandMaper = new CommandMapper()
				.mapTo(pause,AppCMD.VIDEO_CONTROL_PAUSE)
				.mapTo(resume,AppCMD.VIDEO_CONTROL_RESUME)
				.mapTo(seek,AppCMD.VIDEO_CONTROL_SEEK)
				.mapTo(start,AppCMD.VIDEO_CONTROL_START)
				.mapTo(stop,AppCMD.VIDEO_CONTROL_STOP)
				.mapTo(toggle,AppCMD.VIDEO_CONTROL_TOGGLE)
				.mapTo(volume,AppCMD.MEDIA_SET_VOLUME);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			info.player = _videoPlayer ||= VideoPlayer.create();
			_videoPlayer.volume = info.volume;
			addChild(_videoPlayer);

			doubleClickEnabled = true;
			mouseChildren = false;

			addEventListener(MouseEvent.DOUBLE_CLICK, mouseHandler);

			play();
		}

		private function play():void
		{
			_preTime = 0;
			const server:String = MediaModel.me().netOrFileUrl;
			const stream:String = MediaModel.me().streamName;
			log("拉流地址：", protocol(server), server, stream);
			if(_videoPlayer.type == null)
			{
				_videoPlayer.connect(protocol(server), server, stream, videoHandler, true, 0);
			}
			else
			{
				_videoPlayer.attachType(protocol(server), server, stream);
			}
			_videoPlayer.visible = true;
		}

		private function mouseHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.CLICK:
					_videoPlayer.toggle();
					//_videoPlayer.isPlaying?send():send();
					break;
				case MouseEvent.DOUBLE_CLICK:
					//全屏切换
					StageManager.toggleFullscreen(e);
					break;
			}
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
		 * 清楚计时器
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
			switch(states)
			{
				case MediaProxyStates.CONNECT_NOTIFY:
					log("通道建立成功");
					clearTimer();
					_postionId = setInterval(timeCheck, 1000);
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
					//send(AppCMD.MEDIA_STATES_SEEK_COMPLETE);
					break;
				case MediaProxyStates.SEEK_FAILED:
					send(AppCMD.MEDIA_STATES_SEEK_FAIL);
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

		/**
		 * 发送内部通讯事件
		 * @param action
		 * @param param
		 */
		private function send(action:String, param:Array = null):void
		{
			//log("发送消息",action,param);
			if(param)
				NResponder.dispatch(action, param);
			else
				NResponder.dispatch(action);
		}

		public function careList():Array
		{
			return _commandMaper.cmds;
		}

		public function handleCare(msg:String, ...parameters):void
		{
			_commandMaper.excute(msg,parameters);
		}

		//----------播放器控制
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
			_videoPlayer.time = value*_videoPlayer.duration;
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

		/**
		 * 统一打印日志
		 * @param value
		 */
		private function log(... value):void
		{
			Logger.getLogger("VideoLayer").info(value);
		}
	}
}

