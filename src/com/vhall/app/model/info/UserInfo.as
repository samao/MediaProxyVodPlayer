package com.vhall.app.model.info
{

	/**
	 * 用户信息
	 * @author Sol
	 *
	 */
	public class UserInfo extends BaseInfo
	{
		//房主		
		public static const HOST:String = "host";
		//嘉宾
		public static const GUEST:String = "guest"; 
		//助手
		public static const ASSISTANT:String = "assistant";
		//普通用户
		public static const USER:String = "user";
		
		/**
		 * 助手用户 
		 */		
		public var is_assis:Boolean
		/**
		 *  普通用户
		 */		
		public var is_user:Boolean;
		/**是否正在演讲*/		
		public var is_pres:Boolean;
		
		/** 是否会议嘉宾*/		
		public var is_guest:Boolean;
		
		/**	是否是房间的主人*/
		public var is_host:Boolean;
		
		/**	用户ID*/
		public var uid:String;
		
		/** 参会者名字**/
		public var uname:String = "undefined";
		
		private var _role:String;
		
		public function UserInfo()
		{
			super();
		}

		/**	当前角色*/
		public function get role():String
		{
			return _role;
		}

		/**
		 * @private
		 */
		public function set role(value:String):void
		{
			_role = value;
			if(_role == HOST){
				is_host = true;
			}else if(_role == GUEST){
				is_guest = true;
			}else if(_role == ASSISTANT){
				is_assis = true;
			}else{
				is_user = true;
			}
		}

	}
}
