/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	Jun 8, 2016 2:11:33 PM
 * ===================================
 */

package com.vhall.app.view.video
{
	import com.vhall.app.model.MediaModel;
	import com.vhall.app.model.Model;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.controls.UIComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class AudioModelPicComp extends UIComponent
	{
		private var isTimeRun:Boolean = false;
		private var byte:ByteArray = new ByteArray();
		
		public var _skin:MovieClip;
		
		public function AudioModelPicComp()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
		}
		
		protected function onAddedToStage(event:Event=null):void
		{
			// TODO Auto Generated method stub
			isTimeRun = true;
			runTime();
			resizeHandler();
		}
		
		protected function resizeHandler(e:Event = null):void
		{
			StageManager.stage && resize(StageManager.stage.stageWidth,StageManager.stage.stageHeight);
		}
		
		public function set skin(value:MovieClip):void
		{
			_skin = value.getChildAt(0) as MovieClip;
			this.addChild(_skin);
		}
		
		protected function onRemovedFromStage(event:Event=null):void
		{
			// TODO Auto Generated method stub
			isTimeRun = false;
		}
		
		private function runTime():void{
			if(isTimeRun){
				setTimeout(updateVoic,200);
				isTimeRun = true;
			}
		}
		
		override protected function sizeChanged():void
		{
			// TODO Auto Generated method stub
			super.sizeChanged();
			var swidth:int = StageManager.stageWidth;
			var shight:int = StageManager.stageHeight;
			resize(swidth,shight)
		}
		
		
		public function resize(swidth:int,shight:int):void{
			if(!_skin) return;
			var mc:MovieClip = _skin["pic"];
			var vocmc:MovieClip = _skin["voc"]
			if(swidth < 640 || shight < 480){
				var sx:Number = swidth/640;
				var sy:Number = shight/480;
				var ss:Number = Math.min(sx,sy);
				mc.scaleX = mc.scaleY = ss*0.7;
				vocmc.scaleX = vocmc.scaleY = ss* 0.8;
			}else{
				mc.scaleX = mc.scaleY = 1;
				vocmc.scaleX = vocmc.scaleY =  1;
			}
			mc.x = (320 - mc.width)/2;
			mc.y = (240 - mc.height)/2;
			
			vocmc.x =  (320 - vocmc.scaleX*400)/2;
			vocmc.y = (240 - vocmc.scaleY*400)/2;
			try{
				_skin["txt"].y = mc.y + mc.height+5;
			}catch(e:Error){};
			_skin.x = swidth - _skin.width >> 1;
			_skin.y = shight - _skin.height >> 1;
		}
		
		/**
		 *更新音量 
		 */		
		public function updateVoic():void{
			runTime();
			if(!_skin) return;
			var vocmc:MovieClip = _skin.getChildByName("voc") as MovieClip;
			var micVolume:int = activity;
			if(micVolume <=0){
				vocmc.gotoAndStop(1);
			}else if(micVolume > 0 && micVolume <= 30){
				vocmc.gotoAndStop(2);
			}else if(micVolume > 30 && micVolume <= 60){
				vocmc.gotoAndStop(3);
			}else if(micVolume > 60){
				vocmc.gotoAndStop(4);
			}
		}
		
		private function get activity():Number
		{
			if(Model.userInfo.is_pres && MediaModel.me().player&&MediaModel.me().player.usedMic && !MediaModel.me().player.usedCam)
			{
				//Logger.getLogger("[mic level:]").info("当前获取音量：",MediaModel.me().player.usedMic.activityLevel);
				var micactvielevel:Number = MediaModel.me().player.usedMic.activityLevel;
				if(micactvielevel < 20)
				{
					return 0;
				}else if(micactvielevel < 40){
					return 20;
				}else if(micactvielevel < 60){
					return 40;
				}else{
					return 75;
				}
			}
			var left:Number = 0;
			var right:Number = 0;
			const PLOT_HEIGHT:int = 100; 
			const CHANNEL_LENGTH:int = 256; 
			
			try
			{
				SoundMixer.computeSpectrum(byte, true, 0); 
				//left;
				var max:Number=  0;
				var min:Number = 0;
				var n:Number;
				for (var i:int = 0; i < CHANNEL_LENGTH*2; i++) 
				{
					
					n= (byte.readFloat() * PLOT_HEIGHT);
					if(n >0){
						max += n;
					}else{
						min +=n;
					}
				}
			} 
			catch(error:Error) 
			{
				
			}
			return (max - min)/CHANNEL_LENGTH/2.2*10;
		}
	}	
}