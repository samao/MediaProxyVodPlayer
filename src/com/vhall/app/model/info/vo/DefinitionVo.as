package com.vhall.app.model.info.vo
{

	public class DefinitionVo 
	{
		
		public static const LOW:String = "low";
		public static const LOW_CN:String = "流畅";
		
		public static const MIDDLE:String = "middle";
		public static const MIDDLE_CN:String = "清晰";
		
		public static const HIGH:String = "high";
		public static const HIGH_CN:String = "原画";
		
		public function DefinitionVo(tkey:String,data:Object)
		{
			key = tkey;
			_fileName = data.file;
			_serverUrl = data.server;
		}
		
		private var _sName:String;
		
		private var _key:String;
		
		private var _fileName:String;
		
		private var _serverUrl:String;

		public function get serverUrl():String
		{
			return _serverUrl;
		}

		public function set serverUrl(value:String):void
		{
			_serverUrl = value;
		}

		public function get sName():String
		{
			return _sName;
		}

		public function set sName(value:String):void
		{
			_sName = value;
		}

		public function get fileName():String
		{
			return _fileName;
		}

		public function set fileName(value:String):void
		{
			_fileName = value;
		}

		public function get key():String
		{
			return _key;
		}

		public function set key(value:String):void
		{
			_key = value;
			if(_key == LOW){
				sName = LOW_CN;
			}else if(_key == MIDDLE){
				sName = MIDDLE_CN;
			}else if(_key == HIGH){
				sName = HIGH_CN;
			}else{
				_key = HIGH;
				sName = HIGH_CN;
			}
		}

	}
}