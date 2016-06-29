/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jun 28, 2016 11:57:32 AM
 * ===================================
 */

package com.vhall.app.view.video.api
{
	public interface ICommandMapper
	{
		/**
		 * 映射命令和处理函数关系
		 * @param handler
		 * @param cmd
		 * @return
		 */
		function mapTo(handler:Function,cmd:String):ICommandMapper;

		/**
		 * 关注的命令集合
		 * @return
		 */		
		function get cmds():Array;
		/**
		 * 执行改命令的回调
		 * @param cmd
		 * @param args
		 */		
		function excute(cmd:String,args:* = null):void;
	}
}

