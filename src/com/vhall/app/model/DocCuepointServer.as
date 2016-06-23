package com.vhall.app.model
{
	import com.adobe.serialization.json.JSON;
	import com.vhall.app.net.WebAJMessage;
	
	import flash.external.ExternalInterface;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;

	/**
	 *doc打点数据上报服务
	 *@author zhaoqinghao
	 *@data 2016-6-23 下午12:04:59
	 */
	public class DocCuepointServer
	{
		private static var instance:DocCuepointServer;
		protected var cuepointLoogUint:uint;
		protected var currCuepoint:Object;	
		public static var loopTime:int = 200;
		
		/**
		 *单例 
		 * @return 
		 * 
		 */		
		public static function getInstance():DocCuepointServer{
			return instance ||= new DocCuepointServer();
		}
		
		
		public function DocCuepointServer()
		{
			//监听当播放时,开始start
			//监听seek时
		}
		
		
		public function startCuePointLoop(start:Boolean):void{
			clearTimeout(cuepointLoogUint);
			if(start){
				cuepointLoogUint = setInterval(onCuePotint,loopTime);
			}
		}
		
		public function onCuePotint():void{
			var cues:Array = Model.docActionInfo.cuepoint;
			//当前时间
			var ctime:Number =0;
			for (var i:int = cues.length; i >= 0; i--)
			{
				if (ctime > Number(cues[i].created_at))
				{
					if (cues[i] == currCuepoint)
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
		
		public function toSeekCuePointInfo(time):void{
			var cues:Array = Model.docActionInfo.cuepoint;
			if(cues == null ||  cues.length < 0){
				return;
			}
			try{
				//查找当前文档时间
				var currentIdx:int;
				var lastPoint:Object;
				var drawList:Array = [];
				var len:Number = cues.length - 1
				for (var i:int = 0; i < len; i++) 
				{
					var cut:Object = cues[i];
					if (time > Number(cut.created_at))
					{
						if(toCheckFilp(cut)){
							lastPoint = cut;
							drawList = [];
						}else {
							drawList.push(cut); 
						}
					}else{
						break;
					}
					//				}
				}
				
				//发送翻页并且清除
				if(lastPoint){
					var creat:String = createCeanPage(lastPoint.content)
					WebAJMessage.sendRecordMsg(lastPoint.content);
					WebAJMessage.sendRecordMsg(creat);
				}
				//发送画笔
				for (var j:int = 0; j < drawList.length; j++) 
				{
					WebAJMessage.sendRecordMsg(drawList[j].content);
				}
			}catch(e:Error){
				ExternalInterface.call("console.log", "解析跳转文档数据出错："+ e.errorID + "_"+ e.message);
			}
		}
		
		/**
		 * //因为跳转的问题需要清除当页之前所有画笔
		 * @param jumpPoint
		 * @return 
		 * 
		 */		
		private function createCeanPage(jumpInfo:String):String{
			var object:Object = com.adobe.serialization.json.JSON.decode(String(jumpInfo));
			object.type = "clearAllStroke"
			return com.adobe.serialization.json.JSON.encode(object);
		}
		
		private function toCheckFilp(data:Object):Boolean{
			if(data&& data.content && data.content!=""){
				var cobj:Object = com.adobe.serialization.json.JSON.decode(String(data.content));
				if(cobj && cobj.type == "flipOver"){
					return true;
				}
			}
			return false;
		}
		
	}
}