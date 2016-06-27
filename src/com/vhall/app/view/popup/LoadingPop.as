package com.vhall.app.view.popup
{
	import com.vhall.framework.ui.container.Box;
	
	import flash.display.DisplayObjectContainer;
	import com.vhall.app.view.popup.ui.LineLoading;
	import com.vhall.app.view.popup.ui.MainLoading;

	/**
	 * 加载条提示板 显示时会自动到父容器的最上层显示
	 * @author zqh
	 * 
	 */	
	public class LoadingPop extends Box
	{
		protected var tParent:DisplayObjectContainer
		protected var loadLine:LineLoading;
		protected var loadMian:MainLoading;
		public function LoadingPop(parent:DisplayObjectContainer)
		{
			tParent = parent;
			verticalCenter = 0;
			horizontalCenter = 0;
		}
		 
		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
			
			loadLine = new LineLoading();
			loadLine.y = 10;
			loadMian = new MainLoading();
		}
		
		/**
		 *显示加载条 
		 * 
		 */		
		public function showLineLoadng():void{
			removeAllChild();
			this.addChild(loadLine);
			show();
		}
		
		/**
		 *显示主加载 
		 */
		public function showLogoLoading():void{
			removeAllChild();
			this.addChild(loadMian);
			show();
		}
		
		
		public function hide():void{
			removeFromParent();
		}
		
		protected function show():void{
			if(tParent){
				if(this.parent){
					this.parent.setChildIndex(this,tParent.numChildren-1)
				}else{
					tParent.addChildAt(this,tParent.numChildren);
				}
			}
		}
		
	}
}