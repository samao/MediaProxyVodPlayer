package  com.vhall.app.view.control.ui.progress
{
	import com.vhall.app.model.Model;
	import com.vhall.framework.ui.controls.HDragBar;
	import com.vhall.framework.ui.utils.ComponentUtils;
	
	import flash.display.DisplayObjectContainer;

	/**
	 *
	 *@author zhaoqinghao
	 *@data 2016-6-27 下午2:35:54
	 */
	public class TimeHBar extends HDragBar
	{
		/**
		 *所有点数据 
		 */		
		protected var cuePoints:Vector.<CuePointItem>;
		public function TimeHBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			testDate();
			onInitCuePoints();
			layoutCuePoints();
		}
		
		private function testDate():void{
			var arr:Array = new Array();
			for (var i:int = 1; i < 11; i++) 
			{
				arr[arr.length] = {time:i*10};
			}
			Model.Me().docactioninfo.usrdata  = arr;
		}
		
		override protected function sizeChanged():void
		{
			// TODO Auto Generated method stub
			super.sizeChanged();
			layoutCuePoints();
		}
		
		protected function onInitCuePoints():void{
			if(Model.docActionInfo.usrdata &&　Model.docActionInfo.usrdata.length > 0){
				cuePoints = new Vector.<CuePointItem>();
				var cuDatas:Array = Model.docActionInfo.usrdata;
				var tmpCue:CuePointItem;
				for (var i:int = 0; i < cuDatas.length; i++) 
				{
					tmpCue = new CuePointItem(this,cuDatas[i]);
					cuePoints[cuePoints.length] = tmpCue;
				}
			}
		}
		
		protected function layoutCuePoints():void{
			if(cuePoints && cuePoints.length > 0){
				var len:int = cuePoints.length;
				var tmpCue:CuePointItem;
				var tRate:int
				for (var i:int = 0; i < len; i++) 
				{
					tmpCue = cuePoints[i];
					tRate = tmpCue.getTimeRate(100);
					tmpCue.x = width * tRate * 0.01;
				}
			}
		}


		override protected function initSkin():void
		{
			super.initSkin();
			bg.source = ComponentUtils.genInteractiveRect(320, 10, null, 0, 0, 0x00FFFF);
			finished.source = ComponentUtils.genInteractiveRect(320, 10, null, 0, 0, 0xff0000);
			quad.visible = false;
			buffer.visible = false;
		}

	}
}

