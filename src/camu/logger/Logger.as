package camu.logger
{
	public class Logger
	{		
		public static var _off:Boolean = true;
		public static function setOff(off:Boolean) : void
		{
			_off = off;
		}
		
		public static function createLogger(cls:Class, logLevel:int = LEVEL.ERROR, logFunction:Function = null) : ILogger
		{
			if (_off)
			{
				return new FakeLogger();
			}
			else
			{
				return new TrueLogger(logLevel, logFunction);
			}
		}		
	}
}