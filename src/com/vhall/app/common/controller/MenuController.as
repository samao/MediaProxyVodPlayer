package com.vhall.app.common.controller
{
	import com.vhall.app.common.Version;
	import com.vhall.app.model.Model;
	import com.vhall.framework.app.common.Controller;
	import com.vhall.framework.app.manager.StageManager;
	
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 构建右键菜单目录 
	 * @author Sol
	 * 
	 */	
	public class MenuController extends Controller
	{
		public function MenuController()
		{
			super();
		}
		
		override protected function initController():void
		{
			super.initController();
			var cropName:String = "[微吼直播]";
			var verion:String = Version.app + " " +Version.ver;
			
			// 实例化右键菜单类
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			var cmi:ContextMenuItem;
			
			// 是否隐藏版权信息
			if(true)
			{
				cmi = new ContextMenuItem(cropName,true,true);
				cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuClickHandler);
				cm.customItems.push(cmi);
			}
			
			cmi = new ContextMenuItem(verion,true,true);
			cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuClickHandler);
			cm.customItems.push(cmi);
			
			StageManager.root.contextMenu = cm;
		}
		
		private function menuClickHandler(e:ContextMenuEvent):void
		{
			var url:String = "http://www.vhall.com";
			navigateToURL(new URLRequest(url), "_blank");
		}
	}
}