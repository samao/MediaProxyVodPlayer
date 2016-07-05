package
{
	import com.vhall.app.common.controller.MenuController;
	import com.vhall.app.common.controller.MessageController;
	import com.vhall.app.manager.LayerManager;
	import com.vhall.app.model.DocCuepointServer;
	import com.vhall.app.model.Model;
	import com.vhall.app.net.AppCMD;
	import com.vhall.app.view.control.ControlLayer;
	import com.vhall.app.view.debug.DebugLayer;
	import com.vhall.app.view.popup.PopupLayer;
	import com.vhall.app.view.video.VideoLayer;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.app.mvc.IResponder;
	import com.vhall.framework.app.mvc.ResponderMediator;
	import com.vhall.framework.keyboard.KeyboardMapper;
	import com.vhall.framework.load.ResourceLoader;
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.manager.PopupManager;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.ui.Keyboard;

	import appkit.responders.NResponder;

	public class Vod extends Box implements IResponder
	{
		public function Vod(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			new MenuController();
			new MessageController();
			super(parent, xpos, ypos);
			new ResponderMediator(this);

			addEventListener(Event.ADDED_TO_STAGE,function():void
			{
				NResponder.dispatch(AppCMD.MEDIA_SWITCH_LINE);
			});
		}

		// 控制层，音量，线路，全屏那些
		public var controlLayer:ControlLayer;

		public var debug:DebugLayer;
		// 弹框层
		public var popupLayer:PopupLayer;
		// 整个视频层
		public var videoLayer:VideoLayer;

		public function careList():Array
		{
			return null;
		}

		public function handleCare(msg:String, ... parameters):void
		{
		}

		override protected function componentInited(e:Event):void
		{
			super.componentInited(e);
			loadDocMsg();
		}

		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
			videoLayer = new VideoLayer(this);
			popupLayer = new PopupLayer(this);
			controlLayer = new ControlLayer(this);
			LayerManager.initLayer(this);
			//NResponder.dispatch(AppCMD.MEDIA_SWITCH_LINE);
			debug = new DebugLayer();
			//注册调试信息 快捷键为ctrl+K
			var km:KeyboardMapper = new KeyboardMapper(StageManager.stage);
			km.mapListener(showLogs, Keyboard.SHIFT, Keyboard.K);
		}

		/**
		 *加载打点数据
		 *
		 */
		protected function loadDocMsg():void
		{
			if(Model.docActionInfo && Model.docActionInfo.msg_url)
			{
				var rl:ResourceLoader = new ResourceLoader();
				rl.load({type:3, url:"http:" + Model.docActionInfo.msg_url}, onDocMsg);
			}
			else
			{
				Logger.getLogger("loadDocMsg").info("docActionInfo or msg_url is null");
			}
		}

		protected function onDocMsg(item:Object, content:Object, domain:ApplicationDomain):void
		{
			// TODO Auto Generated method stub
			var obj:Object = JSON.parse(String(content));
			Model.docActionInfo.cuepoint = obj.cuepoint as Array;
			Model.docActionInfo.setupUsrData(obj.usrdata as Array)
			NResponder.dispatch(AppCMD.DATA_CUEPOINT_COMP);
			DocCuepointServer.getInstance();
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();
			_height = StageManager.stageHeight;
			_width = StageManager.stageWidth;
			videoLayer.setSize(StageManager.stageWidth,StageManager.stageHeight);
			controlLayer.width = StageManager.stageWidth;
			popupLayer && popupLayer.setSize(_width, _height);
		}

		private function showLogs():void
		{
			PopupManager.addPopup(debug);
		}
	}
}


