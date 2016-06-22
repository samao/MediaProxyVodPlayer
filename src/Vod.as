package
{
	import com.vhall.app.common.controller.MenuController;
	import com.vhall.app.common.controller.MessageController;
	import com.vhall.framework.app.mvc.IResponder;
	import com.vhall.framework.app.mvc.ResponderMediator;
	import com.vhall.framework.ui.container.Box;
	
	import flash.display.DisplayObjectContainer;
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