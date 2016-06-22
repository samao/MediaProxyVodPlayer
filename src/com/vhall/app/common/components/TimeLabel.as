package com.vhall.app.common.components
{
	import com.vhall.framework.ui.controls.Label;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 用于显示时间的文本标签 
	 * @author Sol
	 * 
	 */	
	public class TimeLabel extends Label
	{
		/** 1 秒钟 */
		private static const ONE_SECOND:int=1000;
		/** 1 分钟 */
		private static const ONE_MINUTE:int=1000 * 60;
		/** 1 小时 */
		private static const ONE_HOUR:int=1000 * 60 * 60;
		
		public function TimeLabel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		private var _ms:int;
		private var _autoStart:Boolean;
		private var _fillZero:Boolean = true;
		
		private var timer:Timer;
		private var _delay:Number = 1000;
		private var _addTime:Boolean = true;
		
		public function start():void
		{
			if(timer == null)
			{
				timer = new Timer(delay);
				timer.addEventListener(TimerEvent.TIMER, onTImer);
				onTImer(null);
			}
			
			if(!timer.running)
			{
				timer.start();
			}
		}
		
		public function stop():void
		{
			if(timer.running)
			{
				timer.stop();
			}
		}
		
		protected function onTImer(e:TimerEvent):void
		{
			if(addTime)
			{
				_ms +=delay;
			}
			else
			{
				_ms -=delay;
			}
			
			this.text = format(_ms);
			
			if(_ms <=0)
			{
				stop();
			}
			
			if(hasEventListener(Event.CHANGE))
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 将毫秒数格式化为 "hh:mm:ss" 字符串
		 *
		 * @param ms 毫秒时间
		 */
		private function format(ms:int):String
		{
			if (ms <= 0)
			{
				return "";
			}
			
			var h:int=ms / ONE_HOUR;
			ms%=ONE_HOUR;
			var m:int=ms / ONE_MINUTE;
			ms%=ONE_MINUTE;
			var s:int=ms / ONE_SECOND;
			
			var h_str:String=h > 9 ? String(h) : fillZero ? "0" + h : h+"";
			var m_str:String=m > 9 ? String(m) : fillZero ? "0" + m : m+"";
			var s_str:String=s > 9 ? String(s) : fillZero ? "0" + s : s+"";
			
			return h_str + ":" + m_str + ":" + s_str;
		}

		/**	毫秒值*/
		public function get ms():int
		{
			return _ms;
		}

		public function set ms(value:int):void
		{
			_ms = value;
			
			this.text = format(value);
			
			if(autoStart)
			{
				start();
			}
		}

		/**	是否自动开始*/
		public function get autoStart():Boolean
		{
			return _autoStart;
		}

		public function set autoStart(value:Boolean):void
		{
			_autoStart = value;
		}

		/**	小于10的时候是否补全0，00:02:04 2:4*/
		public function get fillZero():Boolean
		{
			return _fillZero;
		}

		public function set fillZero(value:Boolean):void
		{
			_fillZero = value;
		}
		
		/**	timer的延迟*/
		public function get delay():Number
		{
			return _delay;
		}

		public function set delay(value:Number):void
		{
			_delay = value;
		}

		/**	是增加时间还是减少时间*/
		public function get addTime():Boolean
		{
			return _addTime;
		}

		public function set addTime(value:Boolean):void
		{
			_addTime = value;
		}
	}
}