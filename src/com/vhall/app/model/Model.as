package com.vhall.app.model
{
	import com.vhall.app.model.info.DocActionInfo;
	import com.vhall.app.model.info.PlayerStatusInfo;
	import com.vhall.app.model.info.VideoInfo;

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 * 数据模型
	 * @author Sol
	 *
	 */	
	public class Model
	{
		private static var I:Model;

		/**	原始数据*/
		private var originParmeters:Object;

		public static function Me():Model
		{
			if(!I)
			{
				I = new Model();
			}
			return I;
		}

		public function Model()
		{
			if(I)
			{
				throw new Error("Model is singlton");
			}

			I = this;
		}
		/**	当前流数据的信息*/
		public var videoinfo:VideoInfo;
		/***播放器状态信息 */		
		public var playerstatusinfo:PlayerStatusInfo;
		/**
		 *文档打点数据
		 */		
		public var docactioninfo:DocActionInfo ;

		public function init(data:Object):void
		{
			this.originParmeters = data;
			parseData(data,this);
		}

		// 递归解析数据
		private function parseData(data:Object, t:*):void
		{
			trace("parsing t:",t);
			var xml:XML = describeType(t);
			var child:XML;
			var varName:String = "";
			var typeName:String = "";

			var attrList:XMLList = xml..variable;
			// 公共属性
			for each(child in attrList)
			{
				varName = child["@name"].toString();
				typeName = child["@type"].toString();
				trace("t have property:",varName,"type is ",typeName,data[varName]);
				switch(typeName)
				{
					case "String":
						if(data.hasOwnProperty(varName)){
							t[varName] = data[varName];
						}
						break;
					case "int":
						if(data.hasOwnProperty(varName)){
							t[varName] = int(data[varName]);
						}
						break;
					case "Boolean":
						if(data.hasOwnProperty(varName)){
							t[varName] = data[varName] == "0" && data.hasOwnProperty(varName) ? false : true;
						}
						break;
					case "Array":
						break;
					default:
						trace("unrecognition type",typeName);
						var instanceName:String = typeName.toLowerCase().split("::")[1];
						if(t.hasOwnProperty(instanceName)){
							if(t[instanceName] == null)
							{
								t[instanceName] = new (getDefinitionByName(typeName));
							}
							parseData(data,t[instanceName]);
							trace("parse unrecognition " + typeName +" over");
						}
						break;
				}
			}

			var accList:XMLList = xml..accessor;
			var accessName:String;
			for each(child in accList)
			{
				accessName = child["@name"];
				if(child["@access"].toString().toLowerCase().indexOf("write") > -1)
				{
					if(data[accessName] != null)
					{
						t[accessName] = data[accessName];
					}
				}
			}
		}

		/**
		 *视频信息
		 * @return
		 *
		 */		
		public static function get videoInfo():VideoInfo{
			return Me().videoinfo;
		}

		/**
		 *状态信息
		 * @return
		 *
		 */		
		public static function get playerStatusInfo():PlayerStatusInfo{
			return Me().playerstatusinfo;
		}
		/**
		 *打点数据
		 * @return
		 *
		 */		
		public static function get docActionInfo():DocActionInfo{
			return Me().docactioninfo;
		}
	}
}

