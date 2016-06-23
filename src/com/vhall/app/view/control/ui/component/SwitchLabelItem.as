package com.vhall.app.view.control.ui.component
{
	import com.vhall.framework.app.manager.RenderManager;
	
	import flash.display.DisplayObjectContainer;

	/**
	 * 用户combox显示label的渲染组件 
	 * @author zqh
	 * 
	 */	
	public class SwitchLabelItem extends SwitchItemRender
	{
		public function SwitchLabelItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			this.setSize(52,20);
			super(parent, xpos, ypos);
		}
		
		override protected function initDrawBg():void{
			this.graphics.clear()
			this.graphics.beginFill(0x373737);
			this.graphics.drawRoundRect(0,0,52,20,4,4);
			this.graphics.endFill();
			this.graphics.beginFill(0x2D2D2D);
			this.graphics.drawRoundRect(1,1,50,18,4,4);
			this.graphics.endFill();
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		
		override protected function overDrawBg():void{
			this.graphics.clear()
			this.graphics.beginFill(0xE81926);
			this.graphics.drawRoundRect(0,0,52,20,4,4);
			this.graphics.endFill();
			this.graphics.beginFill(0xE94644);
			this.graphics.drawRoundRect(1,1,50,18,4,4);
			this.graphics.endFill();
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		/**
		 *更新显示文本 
		 * 
		 */		
		override protected function update4Label():void{
			lab.color = 0xffffff;
		}
	}
}