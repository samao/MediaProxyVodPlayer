package com.vhall.app.load
{
	import com.vhall.app.model.Model;
	import com.vhall.framework.app.App;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.load.QueueLoader;
	import com.vhall.view.LoadingLine;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getDefinitionByName;

	/**
	 *	资源加载视图
	 * @author Sol
	 *
	 */	
	public class ResourceLoadingView extends Sprite
	{
		protected var ql:QueueLoader;
		private static var instanceCache:Array;

		public function ResourceLoadingView()
		{
			super();
		}

		public static function show(urls:Array, complete:Function, progress:Function = null, allComplete:Function = null):ResourceLoadingView
		{
			var instance:ResourceLoadingView;
			if (instanceCache && instanceCache.length > 0)
			{
				instance=instanceCache.pop();
			}
			else
			{
				instance=new ResourceLoadingView;
			}
			instance.show(urls, complete, progress, allComplete);
			return instance;
		}

		private function createAndConfigUI():void
		{
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0,0,StageManager.stageWidth,StageManager.stageHeight);
			graphics.endFill();

			while(numChildren)
			{
				removeChildAt(0);
			}
			var dis:DisplayObject;
			if(Model.playerStatusInfo.hide_powered){
				dis = new LoadingLine();
				dis.x = (StageManager.stageWidth - dis.width) >> 1;
				dis.y = (StageManager.stageHeight - dis.height) >> 1;
				addChild(dis);
			}else{
				dis = new logo4();
				dis.x = (StageManager.stageWidth - dis.width) >> 1;
				dis.y = (StageManager.stageHeight - dis.height) >> 1;
				addChild(dis);
			}
		}

		private function show(urls:Array, complete:Function, progress:Function = null, allComplete:Function = null):void
		{
			createAndConfigUI();
			App.app.stage.addChild(this);
			ql = new QueueLoader();
			this.complete = complete;
			this.progress = progress;
			this.allComplete = allComplete;
			ql.startQueue(urls,complete,innerAllComplete,innerOnProgress,null);
			function innerAllComplete():void
			{
				allComplete && allComplete();

				hide();
			}

			function innerOnProgress(totalCount:int, loadedCount:int, bytesTotal:Number, bytesLoaded:Number, currentItem:Object):void
			{
				progress && progress(totalCount, loadedCount, bytesTotal, bytesLoaded, currentItem);
			}
		}

		private function hide():void
		{
			App.app.stage.removeChild(this);
		}

		private var complete:Function = null;
		private var progress:Function = null;
		private var allComplete:Function = null;
	}
}

