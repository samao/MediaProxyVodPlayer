package com.vhall.app.view.control
{
	import com.vhall.app.model.DataService;
	import com.vhall.app.model.MediaModel;
	import com.vhall.app.model.Model;
	import com.vhall.app.model.info.vo.ServeLinevo;
	import com.vhall.app.net.AppCMD;
	import com.vhall.app.view.control.ui.VolumeBar;
	import com.vhall.app.view.control.ui.component.SwitchListBox;
	import com.vhall.app.view.control.ui.component.VideoAudioChangeBtn;
	import com.vhall.app.view.control.ui.progress.PlayProgressBar;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.app.mvc.IResponder;
	import com.vhall.framework.app.mvc.ResponderMediator;
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.ui.container.HBox;
	import com.vhall.framework.ui.controls.ToggleButton;
	import com.vhall.framework.ui.controls.UIComponent;
	import com.vhall.framework.ui.event.DragEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import appkit.responders.NResponder;

	public class ViewerControlBar extends AbstractControlBar implements IResponder
	{
		public function ViewerControlBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			new ResponderMediator(this);
		}

		/**切换视频 音频 模式组件**/
		protected var changeVideoMode:VideoAudioChangeBtn;

		/**
		 *是否已经隐藏了组件
		 */
		protected var isAutoHide:Boolean = false;

		protected var playProgressBar:PlayProgressBar
		/**切换线路组件**/
		protected var serverLinke:SwitchListBox;
		/**静音按钮*/
		private var _muteBut:ToggleButton;

		private var _volumeBar:VolumeBar;
		/**静音前的音量*/
		private var _volumeBeforeMute:Number = 1;

		private var btnFullscreen:ToggleButton;
		/**	容器*/
		private var hb:HBox;

		public function careList():Array
		{
			var arr:Array = [
				AppCMD.MEDIA_CHANGEVIDEO_MODE,
				AppCMD.DATA_CUEPOINT_COMP
				];
			return arr;
		}


		public function getNeedHideChild():UIComponent
		{
			var i:int = 0;
			var min:int = 999;
			var maxCd:UIComponent;
			var tmpCd:UIComponent;
			var cmin:int = 999;
			while(i < hb.numChildren)
			{
				tmpCd = hb.getChildAt(i) as UIComponent;
				if(tmpCd)
				{
					cmin = int((tmpCd as UIComponent).userData);
					if(cmin < min && tmpCd.visible)
					{
						min = cmin;
						maxCd = tmpCd;
					}
				}
				i++;
			}
			return maxCd;
		}

		public function handleCare(msg:String, ... args):void
		{
			switch(msg)
			{
				case AppCMD.MEDIA_CHANGEVIDEO_MODE:
					updateStatus(true);
					break;
				case AppCMD.DATA_CUEPOINT_COMP:
					if(playProgressBar){
						playProgressBar.showCuePoint();
					}
					break;
			}
		}

		/**
		 *显示所有
		 * @return
		 *
		 */
		public function showAll():void
		{
			var tmpCd:UIComponent;
			var i:int = 0;
			var isChange:Boolean = false;
			while(i < hb.numChildren)
			{
				tmpCd = hb.getChildAt(i) as UIComponent;
				if(tmpCd)
				{
					if(tmpCd.visible == false)
					{
						tmpCd.visible = true;
						isChange = true;
					}
				}
				i++;
			}
			isAutoHide = false;
			if(!updateStatus() && isChange)
			{
				hb.validateNow()
			}
		}

		/**
		 *更新bar组件状态
		 * <br>组件按照业务判断显示或者隐藏状态
		 * <br><li>只有在状态改变了（isChange），才刷新控件，否则不刷新。
		 * @param isOnlyStatus 是否是只更新状态(外部有可能是从自动显示过来的，也有可能是从状态改变过来的,状态改变过来的需要var 立即更新，否则hb更新)
		 */
		public function updateStatus(isOnlyStatus:Boolean = false):Boolean
		{
			var isChange:Boolean = false;
			if(isChange)
			{
				if(isOnlyStatus)
				{
					this.validateNow();
				}
				else
				{
					hb.validateNow();
				}
			}
			return isChange;
		}


		/**
		 *自动隐藏
		 *
		 */
		protected function autoHide(currentWd:int):void
		{
			if(currentWd < 60)
				return;
			var cWidth:int = StageManager.stageWidth - 130;
			if(cWidth < currentWd)
			{
				var hideCd:UIComponent = getNeedHideChild();
				if(hideCd && hideCd.visible)
				{
					hideCd.visible = false;
					isAutoHide = true;
					currentWd = currentWd - hideCd.width;
				}
				autoHide(currentWd);
					//
			}
		}

		/**
		 *自动显示隐藏按钮
		 * <br><li>1.如果舞台宽度小于当前bar宽度，调用隐藏方法
		 * <br><li>2.如果舞台宽度大于当前bar宽度，需要判断是否自动隐藏过控件
		 * <br><li>2-1.如果自动隐藏过控件则显示控件，否则跳过</li></p>
		 */
		protected function autoShowHide():void
		{
			var cWidth:int = StageManager.stageWidth - 130;
			if(cWidth < hb.width)
			{
				autoHide(hb.width);
			}
			else
			{
				if(isAutoHide)
				{
					showAll();
					autoShowHide();
				}
			}
		}

		override protected function createChildren():void
		{
			super.createChildren();
			hb = new HBox(this);
			hb.setSize(width / 2, height);
			hb.right = 10;
			hb.verticalAlign = "center";
			hb.horizontalAlign = "right";
			hb.move(0, 20);
			playProgressBar = new PlayProgressBar(this);
//			playProgressBar.startLoop();

			// 静音
			onInitVolume();

			// 切换线路
			onInitServerLine();

			// 切换音视频
			onInitVideoModeBtn();

			// 全屏按钮
			btnFullscreen = new ToggleButton(hb);
			btnFullscreen.skin = "assets/ui/expand.png";
			btnFullscreen.downSkin = "assets/ui/scope.png";
			btnFullscreen.tooltip = "全屏";
			btnFullscreen.callOut = "top";
			btnFullscreen.addEventListener(MouseEvent.CLICK, onToggleClickHandler);
			btnFullscreen.userData = 9990;
		}

		protected function muteHandler(event:Event = null):void
		{
			if(_muteBut.selected)
			{
				_volumeBeforeMute = _volumeBar.volumeValue;
				_volumeBar.volumeValue = 0;
			}
			else
			{
				_volumeBar.volumeValue = _volumeBeforeMute || 50;
			}
			if(event)
			{
				MediaModel.me().volume = _volumeBar.volumeValue / 100;
				NResponder.dispatch(AppCMD.MEDIA_SET_VOLUME);
			}

			updateVolumeButton();
		}


		override protected function onFull(e:FullScreenEvent):void
		{
			super.onFull(e);
			btnFullscreen.setSelected(e.fullScreen);
		}

		override protected function onHide():void
		{
			// TODO Auto Generated method stub
			super.onHide();
			if(serverLinke)
			{
				serverLinke.hideList();
			}
		}


		/**
		 *初始化线路组件 会判断是否需要显示
		 *
		 */
		protected function onInitServerLine():void
		{
			if(Model.playerStatusInfo.hideLineSwitch)
				return;
			var sdata:Array = Model.videoInfo.serverLineInfo;
			var showData:Array = []
			if(sdata && sdata.length > 0)
			{
				serverLinke = new SwitchListBox(hb);
				var tmpdta:ServeLinevo;
				var data:Object;
				for(var i:int = 0; i < sdata.length; i++)
				{
					data = new Object();
					tmpdta = sdata[i]
					data.label = tmpdta.sName;
					data.value = tmpdta.sName;
					showData[i] = data;
				}
				serverLinke.initList(showData, 110);
				serverLinke.setShowItemSize(74, 22);
				serverLinke.showlabel = "切换线路";

				serverLinke.addEventListener(Event.CHANGE, onServerLineChange);
				serverLinke.userData = 30;
			}
		}

		/**
		 *初始化视频音频模式组件  会判断是否需要显示
		 *
		 */
		protected function onInitVideoModeBtn():void
		{
			if(!Model.playerStatusInfo.streamType)
				return;
			changeVideoMode = new VideoAudioChangeBtn(hb)
			changeVideoMode.setSize(74, 22);
			changeVideoMode.addEventListener(Event.CHANGE, onVideoModeChange);
			changeVideoMode.userData = 40;
		}

		/**
		 *初始化音量
		 * @param event
		 *
		 */
		protected function onInitVolume():void
		{
			var volumeBox:HBox = new HBox(this);
			volumeBox.left = 10;
			volumeBox.verticalCenter = 0;
			volumeBox.verticalAlign = "center";
			_muteBut = new ToggleButton(volumeBox);
			_muteBut.skin = "assets/ui/1.png";
			_muteBut.downSkin = "assets/ui/0.png";
			_muteBut.tooltip = "静音";
			_muteBut.callOut = "top";
			_muteBut.addEventListener(Event.SELECT, muteHandler);
			_volumeBar = new VolumeBar(volumeBox);
			_volumeBar.volumeSlipComp.addEventListener(DragEvent.CHANGE, volumeChange);
			_volumeBeforeMute = MediaModel.me().volume * 100;
			_volumeBar.volumeValue = MediaModel.me().volume * 100;
			_volumeBar.setBgVisible(false);
			_volumeBar.userData = 50;

			updateVolumeButton();
		}

		/**
		 * 线路改变时 处理数据 切换播放
		 * @param event
		 *
		 */
		protected function onServerLineChange(event:Event):void
		{
			// TODO Auto-generated method stub
			Logger.getLogger("ViewerControlBar").info("onServerLineChange :", serverLinke.getSelectData().value);
			var selectSl:String = serverLinke.getSelectData().value;
			if(DataService.onSelectServerLine(selectSl))
			{
				DataService.updateMediaInfo();
				NResponder.dispatch(AppCMD.MEDIA_SWITCH_LINE);
				NResponder.dispatch(AppCMD.UI_SHOW_LOADING);
			}
		}

		protected function onToggleClickHandler(e:MouseEvent):void
		{
			StageManager.toggleFullscreen();
		}

		/**
		 *音频视频模式改变时 处理数据，及切换播放
		 * @param event
		 *
		 */
		protected function onVideoModeChange(event:Event):void
		{
			changeVideoMode.isVideoMode;
			DataService.onVideoModelChange(changeVideoMode.isVideoMode);
			DataService.updateMediaInfo();
			MediaModel.me().videoMode = !Model.playerStatusInfo.viewVideoMode;
			NResponder.dispatch(AppCMD.MEDIA_CHANGEVIDEO_MODE);
			NResponder.dispatch(AppCMD.UI_SHOW_LOADING);
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();
			//计算是否需要隐藏控件
			autoShowHide();
			playProgressBar.width = StageManager.stageWidth
		}

		protected function updateVolumeButton():void
		{
			if(!_muteBut.selected)
			{
				var index:uint = MediaModel.me().volume <= .3 ? 1 : MediaModel.me().volume <= .55 ? 2 : 3;
				_muteBut.setSkin("assets/ui/" + index + ".png");
				trace(MediaModel.me().volume)
			}
		}

		protected function volumeChange(e:DragEvent):void
		{
			MediaModel.me().volume = e.percent;
			NResponder.dispatch(AppCMD.MEDIA_SET_VOLUME, [e.percent]);
			_muteBut.setSelected(e.percent == 0);
			_volumeBeforeMute = _volumeBar.volumeValue;
			muteHandler();
		}
	}
}


