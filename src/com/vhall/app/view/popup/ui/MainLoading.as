package com.vhall.app.view.popup.ui
{
	import com.vhall.framework.ui.container.Box;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class MainLoading extends Box
	{
		private var lineLoading:MovieClip;
		public function MainLoading(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		override protected function createChildren():void
		{
			// TODO Auto Generated method stub
			super.createChildren();
			var cla:Class = getDefinitionByName("logo4") as Class;
			lineLoading = new cla();
			this.addChild(lineLoading);
		}
	}
}