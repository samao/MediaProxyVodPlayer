package com.vhall.app.model
{
	import com.vhall.app.net.AppCMD;
	import com.vhall.app.net.WebAJMessage;
	import com.vhall.framework.log.Logger;

	import flash.utils.clearTimeout;
	import flash.utils.setInterval;

	import appkit.responders.NResponder;

	/**
	 *doc打点数据上报服务
	 *@author zhaoqinghao
	 *@data 2016-6-23 下午12:04:59
	 */
	public class DocCuepointServer
	{
		public static var loopTime:int = 100;
		private static var instance:DocCuepointServer;

		/**
		 *单例
		 * @return
		 *
		 */
		public static function getInstance():DocCuepointServer
		{
			return instance ||= new DocCuepointServer();
		}

		public function DocCuepointServer()
		{
			//监听当播放时,开始start
			NResponder.add(AppCMD.MEDIA_STATES_START,onStart);
			//监听seek时
			NResponder.add(AppCMD.VIDEO_CONTROL_SEEK,toSeekCuePointInfo);
		}

		protected function onStart():void
		{
			// TODO Auto Generated method stub
			startCuePointLoop(true);
		}

		protected var cuepointLoogUint:uint;
		protected var currCuepoint:Object;

		public function destroy():void
		{
			clearTimeout(cuepointLoogUint);
		}

		public function onCuePotint():void
		{
			var cues:Array = Model.docActionInfo.cuepoint;
			//当前时间
			var ctime:Number = MediaModel.me().player.time;
			for(var i:int = cues.length; i >= 0; i--)
			{
				if(ctime > Number(cues[i].created_at))
				{
					if(cues[i] == currCuepoint)
					{
						return;
					}

					currCuepoint = cues[i];
					//ExternalInterface.call("console.log", "onCuepointLoop循环满足条件开始上报");
					WebAJMessage.sendRecordMsg(currCuepoint.content);
					break;
				}
			}
		}


		public function startCuePointLoop(start:Boolean):void
		{
			clearTimeout(cuepointLoogUint);
			if(start)
			{
				cuepointLoogUint = setInterval(onCuePotint, loopTime);
			}
		}

		public function toSeekCuePointInfo(time:Number):void
		{
			var ttime:Number = MediaModel.me().player.duration * time;
			var cues:Array = Model.docActionInfo.cuepoint;
			if(cues == null || cues.length < 0)
			{
				return;
			}
			try
			{
				//查找当前文档时间
				var currentIdx:int;
				var lastPoint:Object;
				var drawList:Array = [];
				var len:Number = cues.length - 1
				for(var i:int = 0; i < len; i++)
				{
					var cut:Object = cues[i];
					if(ttime > Number(cut.created_at))
					{
						if(toCheckFilp(cut))
						{
							lastPoint = cut;
							drawList = [];
						}
						else
						{
							drawList.push(cut);
						}
					}
					else
					{
						break;
					}
						//				}
				}

				//发送翻页并且清除
				if(lastPoint)
				{
					var creat:String = createCeanPage(lastPoint.content)
					WebAJMessage.sendRecordMsg(lastPoint.content);
					WebAJMessage.sendRecordMsg(creat);
				}
				//发送画笔
				for(var j:int = 0; j < drawList.length; j++)
				{
					WebAJMessage.sendRecordMsg(drawList[j].content);
				}
			}
			catch(e:Error)
			{
				Logger.getLogger("docCuep").info("解析跳转文档数据出错：" + e.errorID + "_" + e.message);
			}
		}

		/**
		 * //因为跳转的问题需要清除当页之前所有画笔
		 * @param jumpPoint
		 * @return
		 *
		 */
		private function createCeanPage(jumpInfo:String):String
		{
			var object:Object = JSON.parse(String(jumpInfo));
			object.type = "clearAllStroke"
			return JSON.stringify(object);
		}

		private function toCheckFilp(data:Object):Boolean
		{
			if(data && data.content && data.content != "")
			{
				var cobj:Object = JSON.parse(String(data.content));
				if(cobj && cobj.type == "flipOver")
				{
					return true;
				}
			}
			return false;
		}
	}
}


