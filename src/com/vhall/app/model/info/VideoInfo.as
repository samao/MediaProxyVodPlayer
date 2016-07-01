package com.vhall.app.model.info
{
	import com.vhall.app.model.info.vo.ServeLinevo;
	import com.vhall.framework.log.Logger;

	import flash.utils.Dictionary;

	/**
	 * 当前流数据的一些信息
	 * @author Sol
	 *
	 */
	public class VideoInfo extends BaseInfo
	{
		public function VideoInfo()
		{
			super();
		}

		public var allPublishServers:Array = [];

		/**
		 *音频流地址(语音流名rtmp下有)
		 */
		public var audioSrv:String;
		/**
		 *清晰度数据
		 */
		public var definitionInfo:Array = [];
		/**
		 *连接失败的线路
		 */
		public var failLines:Dictionary;

		/**
		 *选中线路
		 */
		public var selectLineVo:ServeLinevo;

		public var defLinevo:ServeLinevo;
		/**
		 *线路数据
		 */
		public var serverLineInfo:Array = [];
		/**
		 *token
		 */
		public var streamtoken:String;

		/**
		 *线路数据(源数据)
		 */
		private var _cdnServers:String;

		private var _media_srv:String;

		private var _publishServers:String;

		private var _stream_name:String;

		/**服务器选择器的数据源**/
		public function get cdnServers():String
		{
			return _cdnServers;
		}

		/**
		 * @private
		 */
		public function set cdnServers(value:String):void
		{
			_cdnServers = value;
			try
			{
				var arr:Array = JSON.parse(_cdnServers) as Array;
				for(var i:int = 0; i < arr.length; i++)
				{
					var su:String = ""
					if(arr[i].hasOwnProperty("srv_audio"))
					{
						su = arr[i].srv_audio;
					}
					serverLineInfo.push(new ServeLinevo(arr[i].srv, arr[i].name, su));
				}
				selectLineVo = serverLineInfo[0];
			}
			catch(e:Error)
			{
			}
//			serverLineInfo.push(new ServeLinevo("rtmp://cnrtmplive02.e.vhall.com/vhall", "线路1","rtmp://cnrtmplive02.e.vhall.com/vhall"));
//			serverLineInfo.push(new ServeLinevo("rtmp://ccrtmplive02.e.vhall.com/vhall", "线路2","rtmp://ccrtmplive02.e.vhall.com/vhall"));
//			serverLineInfo.push(new ServeLinevo("rtmp://rtmplive01.e.vhall.com/vhall", "线路3","rtmp://rtmplive01.e.vhall.com/vhall"));
//			selectLineVo = serverLineInfo[0];
		}

		private var _playItem:String;
		public function set playItem(value:String):void
		{
			_playItem = value;
			try
			{
				var arr:Array = JSON.parse(_playItem) as Array;
				for(var i:int = 0; i < arr.length; i++)
				{
					var su:String = ""
					if(arr[i].hasOwnProperty("srv_audio"))
					{
						su = arr[i].srv_audio;
					}
					defLinevo = new ServeLinevo(arr[i]['default'].file, arr[i]['default'].server, su);
				}
			}
			catch(e:Error)
			{
			}
		}

		private function get playItem():String
		{
			return _playItem;
		}

		/**
		 *推流服务器地址
		 */
		public function get media_srv():String
		{
			return _media_srv;
		}

		/**
		 * @private
		 */
		public function set media_srv(value:String):void
		{
			_media_srv = value;
		}

		/** 给小助手的推流地址*/
		public function get publishServers():String
		{
			return _publishServers;
		}

		/**
		 * @private
		 */
		public function set publishServers(value:String):void
		{
			_publishServers = value;
			allPublishServers = [];
			try
			{
				Logger.getLogger().info(value);
				var arr:Array = JSON.parse(value) as Array;
				Logger.getLogger().info(arr);
				for(var i:int = 0; i < arr.length; i++)
				{
					var obj:Object = {};
					obj.alias = arr[i].name;
					obj.url = arr[i].srv;
					allPublishServers.push(obj);
				}

				Logger.getLogger().info(allPublishServers, allPublishServers.length);
				var str:String = JSON.stringify(allPublishServers);
				Logger.getLogger().info(str);
			}
			catch(error:Error)
			{
				Logger.getLogger().info("convert publish server error", error.message);
			}

		}

		/*** 推起流的名称*/
		public function get streamname():String
		{
			return _stream_name;
		}

		/**
		 * @private
		 */
		public function set streamname(value:String):void
		{
			_stream_name = value;
		}
	}
}


