package camu.util.log
{
	public class Logger
	{		
		public static var _off:Boolean = true;
		public static function setOff(off:Boolean) : void
		{
			_off = off;
		}
		
		public static function createLogger(cls:Class, logLevel:int = LogLevel.ERROR, logFunction:Function = null) : ILogger
		{
			if (_off)
			{
				return new FakeLogger();
			}
			else
			{
				return new TrueLogger(cls, logLevel, logFunction);
			}
		}		
		
		
	}
}