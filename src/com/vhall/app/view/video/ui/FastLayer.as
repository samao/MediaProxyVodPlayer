/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jun 29, 2016 11:12:02 AM
 * ===================================
 */

package com.vhall.app.view.video.ui
{
	import com.vhall.app.common.Layer;
	import com.vhall.framework.log.Logger;

	import flash.display.DisplayObjectContainer;

	import appkit.responders.NResponder;
	import com.vhall.app.view.video.impl.CommandMapper;
	import com.vhall.app.view.video.api.ICommandMapper;

	public class FastLayer extends Layer
	{
		/**cmd映射关系*/
		protected var _commandMaper:ICommandMapper;

		protected var _layerId:String = "";

		public function FastLayer(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			createCmdMapper();
			super(parent, xpos, ypos);
		}

		/**
		 * 创建command和处理函数映射
		 */		
		protected function createCmdMapper():void
		{
			_commandMaper = new CommandMapper();
		}

		/**
		 * 发送内部通讯事件
		 * @param action
		 * @param param
		 */
		protected function send(action:String, param:Array = null):void
		{
			//log("发送消息",action,param);
			if(param)
				NResponder.dispatch(action, param);
			else
				NResponder.dispatch(action);
		}

		public function careList():Array
		{
			return _commandMaper.cmds;
		}

		public function handleCare(msg:String, ...parameters):void
		{
			_commandMaper.excute(msg,parameters);
		}

		/**
		 * 统一打印日志
		 * @param value
		 */
		protected function log(... value):void
		{
			Logger.getLogger(_layerId).info(value);
		}
	}
}

