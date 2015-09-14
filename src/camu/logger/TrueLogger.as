package camu.logger
{
	import flash.utils.getQualifiedClassName;

	public class TrueLogger implements ILogger
	{
		protected var _LEVEL:int = LEVEL.OFF;
		
		protected var _logFunction:Function = null;
		
		protected var _className:String = null;	

		
		
		public function TrueLogger(LEVEL:int = LEVEL.ERROR, logFunction:Function = null)
		{		
			_logFunction = logFunction ? logFunction:trace;
			
			_LEVEL = LEVEL;					
		}
		
		
		public function log(obj:*, ...msg) : void
		{			
			var msgLevel:int  = isNaN(msg[msg.length -1] ) ? LEVEL.ERROR : int(msg.pop());
			if (msgLevel >= _LEVEL )
			{				;
				_logFunction(getTime() + "[" + getQualifiedClassName(obj) + "]" + LEVEL.LOG_LEVEL_DESC[msgLevel] + msg.join(" "));
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