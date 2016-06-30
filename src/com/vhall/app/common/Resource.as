package com.vhall.app.common
{
	import com.vhall.framework.app.App;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	/**
	 *	资源路径
	 * @author Sol
	 *
	 */	
	public class Resource
	{
		public static var basePath:String = Version.App + "/";

		private static var tempUrl:String;


		public static function parsePath(url:String, update:Boolean = true):String
		{
			url = App.baseURL + url;
			return update ? url + "?v=" + Version.ver : url;
		}

		public static function getResource(id:*):String
		{
			tempUrl = basePath + id + ".swf";
			return parsePath(tempUrl);
		}

		public static function getCode(id:*):String
		{
			tempUrl = id + ".swf" + "?ver=" + Math.random().toFixed(5);
			return parsePath(tempUrl);
		}

		/**
		 *获取logo
		 * @return
		 *
		 */		
		public static function getLogo():DisplayObject{
			return new Bitmap(new Whall_Logo3());
		}

		/**
		 *通过类名反射具体对象
		 * @param cName 类名
		 * @return
		 *
		 */		
		public static function getObjectByClassName(cName:String):Object{
			if(ApplicationDomain.currentDomain.getDefinition(cName)){
				var obj:Class = getDefinitionByName(cName) as Class;
				if(obj){
					return  new obj();
				}
			}
			return null;
		}
	}
}

