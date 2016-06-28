package com.vhall.app.model.info
{
	import com.vhall.app.model.info.vo.UsrDataVo;

	/**
	 *
	 *@author zhaoqinghao
	 *@data 2016-6-23 上午11:10:01
	 */
	public class DocActionInfo extends BaseInfo
	{
		public function DocActionInfo()
		{
			super();
		}

		/**
		 *文档操作数据
		 */
		private var _msg_url:String;

		/**
		 *文档打点数据
		 */
		public var cuepoint:Array;
		/**
		 *用户打点数据
		 */
		public var usrdata:Array;


		public function get msg_url():String
		{
			return _msg_url;
		}

		/**
		 *文档数据
		 * @param value
		 *
		 */
		public function set msg_url(value:String):void
		{
			_msg_url = value;
		}


		public function setupUsrData(data:Array):void
		{
			usrdata = [];
			var tmpvo:UsrDataVo;
			try
			{
				for(var i:int = 0; i < data.length; i++)
				{
					tmpvo = new UsrDataVo(data[i].msg, data[i].picurl, data[i].timePoint);
					usrdata[i] = tmpvo;
				}
			}
			catch(e:Error)
			{
			}
			;
		}

	}
}

