package camu.util.log
{
	public class TrueLogger implements ILogger
	{
		protected var _logLevel:int = LogLevel.OFF;
		
		protected var _logFunction:Function = null;
		
		protected var _ownerName:String = null;	

		
		
		public function TrueLogger(name:String, logLevel:int = LogLevel.ERROR, logFunction:Function = null)
		{
			if (name)
			{
				_ownerName = "[";			
				_ownerName += name;
				_ownerName += "] - ";
			}
		
			
			_logFunction = logFunction ? logFunction:trace;
			
			_logLevel = logLevel;					
		}
		
		public function log(...msg) : void
		{
			var msgLevel:int  = isNaN(msg[msg.length -1] ) ? LogLevel.ERROR : int(msg.pop());
			if (msgLevel >= _logLevel )
			{				
				_logFunction(getTime() + _ownerName + msg.join(" "));
			}	
		}
		
		private function getTime() : String
		{
			var nowDate:Date = new Date();
						
			var nowTime:String = "[";
			nowTime += (nowDate.getMonth()+1).toString();
			nowTime += "/";
			nowTime += nowDate.getDate().toString();
			nowTime += " ";
			nowTime += nowDate.getHours().toString();
			nowTime += ":";
			nowTime += nowDate.getMinutes().toString();
			nowTime += ":";
			nowTime += nowDate.getSeconds().toString();
			nowTime += ":";
			nowTime += nowDate.getMilliseconds().toString();
			nowTime += "]";
			
			return nowTime;
		}
	}
}