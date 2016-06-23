package com.vhall.app.view.control.ui.component
{
	import com.vhall.framework.ui.controls.ItemRender;
	import com.vhall.framework.ui.controls.List;
	
	import flash.display.DisplayObjectContainer;

	/**
	 * 普通的list组件 
	 * @author zqh
	 * 
	 */	
	public class SwitchList extends List
	{
		public function SwitchList(direction:String="vertical", parent:DisplayObjectContainer=null, gap:Number=2, xpos:Number=0, ypos:Number=0)
		{
			super(direction, parent, 1, xpos, ypos);
			this.renderCall = itemRenderCall;
		}
		protected var itemSize:Array = [70,20];
		
		override protected function invalidate():void
		{
			// TODO Auto Generated method stub
				super.invalidate();
				if(dataProvider.length > 0 && this.selectIndex < 0){
					this.selectIndex = 0;
				}
		}
		
		override protected function updateDisplay():void
		{
			super.updateDisplay();
			drawBg();
		}
		 
		 protected function itemRenderCall(item:ItemRender, data:*):void
		 {
			 item.setSize(itemSize[0],itemSize[1]);
		 }
		 
		 protected function checkSameData(data:Object,localData:Object):Boolean{
			 if(data.hasOwnProperty("label") 
				 && localData.data 
				 && localData.data.hasOwnProperty("label")
				 && localData.data.label == data.label
			 ){
				 return true;
			 }
			 return false;
		 }
		 
		 protected function drawBg():void{
			 if(dataProvider == null) return;
			 this.graphics.beginFill(0x272727);
			 this.graphics.drawRect(-1,-1,itemSize[0]+2,dataProvider.length*itemSize[1] + dataProvider.length-1 * 1+ 2);
			 this.graphics.endFill();
		 }
		 
		 /**
		  *设置item宽高 
		  * @param tw
		  * @param th
		  * 
		  */	
		 public function setItemSize(tw:int,th:int):void{
			 itemSize = [tw,th];
			 drawBg();
		 }
		 
		/**
		 *跟新选中 
		 * @param data 选中数据
		 * @return  是否查找到并选中
		 * 
		 */		
		public function updateSelect(data:Object):Boolean{
			for (var i:int = 0; i < dataProvider.length; i++) 
			{
				if(checkSameData(data,dataProvider[i])){
					if(selectItem){
						selectItem.selected = false;
					}
					selectData = dataProvider[i];
					return true;	
				}
			}
			return false;
		}
	}
}