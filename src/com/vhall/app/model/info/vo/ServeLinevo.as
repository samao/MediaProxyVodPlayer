package com.vhall.app.model.info.vo
{
	
	

	/**
	 *切线数据实体 
	 * @author zqh
	 * 
	 */	
	public class ServeLinevo 
	{
		public function ServeLinevo(serverUrl:String,sname:String,serverAudioUrl:String)
		{
			_serverUrl = serverUrl;
			_sName = sname;
			_serverAudio = serverAudioUrl;
		}
		
		private var _serverUrl:String;
		private var _sName:String;
		private var _serverAudio:String;

		public function get serverAudio():String
		{
			return _serverAudio;
		}

		public function set serverAudio(value:String):void
		{
			_serverAudio = value;
		}

		public function get sName():String
		{
			return _sName;
		}

		public function set sName(value:String):void
		{
			_sName = value;
		}

		public function get serverUrl():String
		{
			return _serverUrl;
		}

		public function set serverUrl(value:String):void
		{
			_serverUrl = value;
		}
		
		public function clone():ServeLinevo{
			return new ServeLinevo(_serverUrl,_sName,_serverAudio);
		}
	}
}