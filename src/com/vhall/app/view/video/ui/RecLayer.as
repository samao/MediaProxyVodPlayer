/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jun 29, 2016 11:08:01 AM
 * ===================================
 */

package com.vhall.app.view.video.ui
{
	import flash.display.DisplayObjectContainer;

	public class RecLayer extends FastLayer
	{
		/**
		 * 视频结束推荐层
		 */		
		public function RecLayer(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createCmdMapper():void
		{
			super.createCmdMapper();
		}

		override protected function createChildren():void
		{
			super.createChildren();
		}
	}
}

