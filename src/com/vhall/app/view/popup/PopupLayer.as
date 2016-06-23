package com.vhall.app.view.popup
{
	import com.vhall.app.common.Layer;
	import com.vhall.app.model.MediaModel;
	import com.vhall.app.model.Model;
	import com.vhall.app.net.AppCMD;
	import com.vhall.framework.app.mvc.IResponder;
	import com.vhall.framework.log.Logger;
	
	import flash.display.DisplayObjectContainer;
	/**
	 *提示layer 
	 * @author zqh
	 * 
	 */	
	public class PopupLayer extends Layer implements IResponder
	{
		public function PopupLayer(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		/**
		 *loading提示
		 */
		public var loadingPop:LoadingPop
		public function careList():Array
		{
			return [
				AppCMD.UI_SHOW_LOADING,
				AppCMD.UI_HIDE_LOADING,
			];
		}
		
		public function handleCare(msg:String, ...parameters):void
		{
			Logger.getLogger("PopupLayer").info("handleCare Enter MSG:"+msg);
			switch(msg)
			{
				case AppCMD.UI_SHOW_LOADING:
					showLoading();
					break;
				case AppCMD.UI_HIDE_LOADING:
					hideLoading();
					break;
				default:
					break;
			}
		}
		
		private function hidePop():void
		{
			// TODO Auto Generated method stub
			hideLoading();
		}
		
		/**
		 *显示load 
		 * 
		 */		
		protected function showLogoLoading():void{
			load.showLogoLoading();
		}
		
		/**
		 *显示load 
		 * 
		 */		
		protected function showLoading():void{
			load.showLineLoadng();
		}
		
		
		protected function hideLoading():void
		{
			load.hide();
		}
		
		public function get load():LoadingPop{
			if(loadingPop == null){
				loadingPop = new LoadingPop(this);
			}
			return loadingPop;
		}
	}
}