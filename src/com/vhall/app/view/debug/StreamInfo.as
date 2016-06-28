/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jun 15, 2016 4:37:51 PM
 * ===================================
 */

package com.vhall.app.view.debug
{
	import com.vhall.app.model.MediaModel;
	import com.vhall.framework.load.ResourceLoader;
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.media.provider.MediaProxyType;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.utils.FontUtil;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.net.NetStream;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * 流状态统计信息面板
	 */	
	public class StreamInfo extends Box
	{
		private var _statsText:TextField;

		private var  _id:int;

		private var _bglayer:Shape;

		private var _netWorkInfo:Object;

		public function StreamInfo(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);

			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);

			if(stage) onAdded();
		}

		protected function onRemoved(event:Event):void
		{
			clearInterval(_id);
		}

		protected function onAdded(event:Event = null):void
		{
			if(!_netWorkInfo)
			{
				var l:ResourceLoader =new ResourceLoader();
				l.load({type:3,url:"http://www.speedtest.net/speedtest-config.php"},function(item:Object, content:Object, domain:ApplicationDomain):void
				{
					try{
						var xml:XML = XML(content);
					}catch(e:Error){
						Logger.getLogger("streamInfo").info("无法获取ip");
					}

					if(xml){
						_netWorkInfo = {};
						_netWorkInfo.ip = xml.client.@ip;
						_netWorkInfo.isp = xml.client.@isp;
					}
				},null,function():void
				{
					Logger.getLogger("streamInfo").info(arguments);
				});
			}
			_id = setInterval(function():void
			{
				if(MediaModel.me().player)
				{
					if(MediaModel.me().player.stream)
					{
						var type:String = MediaModel.me().player.type;
						var stream:NetStream = MediaModel.me().player.stream;
						update(stream,type);
					}
				}
			},250);
		}

		internal function update(stream:NetStream,type:String):void
		{
			if(MediaModel.me().player&&type == MediaProxyType.HLS)
			{
				_statsText.htmlText = "视频地址："+MediaModel.me().player.uri;
			}else{
				stream.info&&stream.info.uri&&(_statsText.htmlText = "视频地址："+stream.info.uri.replace(/\?.+/ig,""));
			}

			if(_netWorkInfo!=null)
			{
				_statsText.htmlText += "\rISP：" + _netWorkInfo.isp;
				_statsText.htmlText += "\r本机：" +_netWorkInfo.ip;
			}
			_statsText.htmlText += "\r视频编码: "+stream.videoStreamSettings.codec;

			if(type == MediaProxyType.PUBLISH)
			{
				if(MediaModel.me().player && MediaModel.me().player.usedCam)
				{
					_statsText.htmlText += "\r采集大小：" + MediaModel.me().player.usedCam.width +" X " +MediaModel.me().player.usedCam.height;
				}
				_statsText.htmlText += "\r视频缓存长度: "+uint(stream.info.videoBufferByteLength);
				_statsText.htmlText += "\r音频缓存长度: "+uint(stream.info.audioBufferByteLength);
			}else{
				if(type == MediaProxyType.HTTP) _statsText.htmlText += "\r下载网速: "+ uint(stream.info.currentBytesPerSecond/1024).toFixed(2) + " kbps";
			}

			_statsText.htmlText += "\r播放帧频: "+stream.currentFPS.toFixed(1);
			_statsText.htmlText += "\r播放丢帧: "+stream.info.droppedFrames;
			_statsText.htmlText += "\r解码帧：" + stream.decodedFrames;
			_statsText.htmlText += "\r视(音)频丢包: "+stream.info.videoLossRate + "("+stream.info.audioLossRate+")";
			MediaModel.me().player && (_statsText.htmlText += "\r状态：" + MediaModel.me().player.state);

			//this.move(20,20);

			_bglayer.graphics.clear();
			_bglayer.graphics.beginFill(0x000000,.0);
			_bglayer.graphics.drawRect(0,0,320,_statsText.height);
			_bglayer.graphics.endFill();

			this.setSize(_bglayer.width,_bglayer.height);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			_bglayer = new Shape();
			this.addChild(_bglayer);
			_statsText = new TextField();
			_statsText.multiline = true;
			_statsText.autoSize = "left";
			_statsText.selectable = false;
			_statsText.mouseEnabled = false;
			_statsText.defaultTextFormat = new TextFormat(FontUtil.recommendFont,12,0xFFFFFF,true,null,null,null,null,null,5,5,null,-5);
			addChild(_statsText);
		}
	}
}

