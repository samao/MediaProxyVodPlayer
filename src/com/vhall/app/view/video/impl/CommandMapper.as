/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jun 28, 2016 11:55:22 AM
 * ===================================
 */

package com.vhall.app.view.video.impl
{
	import flash.utils.Dictionary;
	import com.vhall.app.view.video.api.ICommandMapper;

	public class CommandMapper implements ICommandMapper
	{
		private var _map:Array = [];

		private var _dic:Dictionary = new Dictionary(true);

		public function mapTo(handler:Function,cmd:String):ICommandMapper
		{
			_map.push(cmd);
			_dic[cmd] = handler;

			return this
		}

		public function get cmds():Array
		{
			return _map;
		}

		public function excute(cmd:String,args:* = null):void
		{
			if(_dic.hasOwnProperty(cmd))
			{
				var handler:Function = _dic[cmd];
				if(handler)
				{
					handler.apply(null,args);
				}
			}
		}
	}
}

