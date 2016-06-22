package com.vhall.app.common
{
	/**
	 * 版本信息 
	 * @author Sol
	 * @date 2016-05-24 20:59:33
	 */	
	public class Version
	{
		/**
		 *	产品名称， live,vod,doc等 
		 */		
		public static const App:String = "Vod";
		
		/**
		 *	主版本号 
		 */		
		public static const Major:String = "0";
		
		/**
		 *	主要功能版本 
		 */		
		public static const Minor:String = "0";
		
		/**
		 *	次要功能版本 
		 */		
		public static const Patch:String = "0";
		
		/**
		 *	编译版本号 
		 */		
		public static const Build:String = new Date().minutes + "." + new Date().seconds;
		
		/**
		 * 获取当前APP名字 
		 * @return 
		 * 
		 */		
		public static function get app():String
		{
			return "[" + App + "]";
		}
		
		/**
		 *	获取当前版本号 
		 * 
		 */		
		public static function get ver():String
		{
			return Major + "." + Minor + "." + Patch + "." + Build;
		}
	}
}