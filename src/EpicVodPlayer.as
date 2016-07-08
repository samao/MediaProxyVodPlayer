package
{
	import com.vhall.app.common.Resource;
	import com.vhall.app.load.ResourceLoadingView;
	import com.vhall.app.model.Model;
	import com.vhall.framework.app.App;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.load.ResourceLibrary;

	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.system.Security;

	[SWF(width = "960", height = "640", backgroundColor = "0x000000")]
	public class EpicVodPlayer extends App
	{
		public function EpicVodPlayer()
		{
			addEventListener(App.INIT_START, onInitStart);
			addEventListener(App.INIT_END, onInited);
			super();
		}

		protected function onInitStart(event:Event):void
		{
			// 初始化参数
			var vars:Object = this.loaderInfo.parameters;
			// model init
			Model.Me().init(vars);
		}

		protected function onInited(event:Event):void
		{
			removeEventListener(App.INIT_END, onInited);
			StageManager.stage.addEventListener(Event.RESIZE, onResize);
			Security.allowDomain("*");
			// load live.swf
			var arr:Array = [];
			arr.push({type:2,id:"ui", url:Resource.getResource("ui")});
			arr.push({type:2,id:"vod", url:Resource.getCode("Vod")});
			ResourceLoadingView.show(arr, itemComplete, progress, allComplete);
		}

		protected function onResize(event:Event):void
		{
			var obj:DisplayObject = this.getChildAt(0);
			obj.width = StageManager.stageWidth;
			obj.height = StageManager.stageHeight;


			var alphas:Array = [0.03, 0.4];
			var colors:Array = [0, 0];
			var ratios:* = [80, 255];
			var matrix:* = new Matrix();
			matrix.createGradientBox(stage.stageWidth, stage.stageHeight);

			this.graphics.clear();
			this.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.graphics.endFill();
		}


		protected function itemComplete(item:Object, content:Object, domain:ApplicationDomain):void
		{
			switch(item.id)
			{
				case "ui":
					ResourceLibrary.addLibrary("ui", content.getAssets());
					break;
				case "vod":
					addChild(content as DisplayObject);
					onResize(null);
					break;
			}

		}

		protected function progress(totalCount:int, loadedCount:int, bytesTotal:Number, bytesLoaded:Number, currentItem:Object):void
		{

		}

		protected function allComplete():void
		{

		}
	}
}

