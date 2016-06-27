package
{
	import com.vhall.app.common.Resource;
	import com.vhall.app.load.ResourceLoadingView;
	import com.vhall.app.model.Model;
	import com.vhall.framework.app.App;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.load.ResourceLibrary;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	
	[SWF(width = "960", height = "640", backgroundColor = "0xC0C0C0")]
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