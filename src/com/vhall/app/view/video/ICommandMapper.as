/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jun 28, 2016 11:57:32 AM
 * ===================================
 */

package com.vhall.app.view.video
{
	public interface ICommandMapper
	{
		function mapTo(handler:Function,cmd:String):ICommandMapper;

		function get cmds():Array;
		function excute(cmd:String,args:* = null):void;
	}
}

