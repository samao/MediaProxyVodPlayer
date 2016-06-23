package
{
	import com.adobe.serialization.json.JSON;
	import com.vhall.app.common.controller.MenuController;
	import com.vhall.app.common.controller.MessageController;
	import com.vhall.app.model.DocCuepointServer;
	import com.vhall.app.model.Model;
	import com.vhall.framework.app.mvc.IResponder;
	import com.vhall.framework.app.mvc.ResponderMediator;
	import com.vhall.framework.load.ResourceLoader;
	import com.vhall.framework.ui.container.Box;
	
	import flash.display.DisplayObjectContainer;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	
	public class Vod extends Box implements IResponder
	{
		public function Vod(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*"); 
			new MenuController();
			new MessageController();
			super(parent, xpos, ypos);
			new ResponderMediator(this);
			loadDocMsg();
		}
		
		/**
		 *加载打点数据 
		 * 
		 */		
		protected function loadDocMsg():void{
			var rl:ResourceLoader = new ResourceLoader();
			rl.load({type:3,url:"http:"+Model.docActionInfo.msg_url},onDocMsg);
		}
		
		protected function onDocMsg(item:Object, content:Object, domain:ApplicationDomain):void
		{
			// TODO Auto Generated method stub
			var obj:Object = com.adobe.serialization.json.JSON.decode(String(content));
			Model.docActionInfo.cuepoint = obj.cuepoint as Array;
			Model.docActionInfo.usrdata = obj.usrdata as Array;
			DocCuepointServer.getInstance();
		}
		public function careList():Array
		{
			return null;
		}
		
		public function handleCare(msg:String, ...parameters):void
		{
		}
	}
}