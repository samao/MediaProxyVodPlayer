package com.vhall.app.manager
{
	import com.vhall.app.common.Layer;

	/**
	 * 
	 * @author Sol
	 * @date 2016-05-25 15:13:02
	 */	
	public class LayerManager
	{
		/**整个视频层*/
		public static var videoLayer:Layer;
		/**	控制层，音量，线路，全屏那些*/
		public static var controlLayer:Layer;
		/**弹幕层*/
		public static var barrageLayer:Layer;
		/**	特效层 跑马灯，礼物特效？ 等*/
		public static var effectLayer:Layer;
		/**	弹框层*/
		public static var popupLayer:Layer;
		
		public static function initLayer(rootLayer:*):void
		{
			videoLayer = rootLayer.videoLayer;
			controlLayer = rootLayer.controlLayer;
			barrageLayer = rootLayer.barrageLayer;
			effectLayer = rootLayer.effectLayer;
			popupLayer = rootLayer.popupLayer;
		}
		
	}
}