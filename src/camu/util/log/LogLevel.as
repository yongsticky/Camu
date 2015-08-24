package camu.util.log
{
	public final class LogLevel
	{
		
		public static const DEBUG:int = 0;
		public static const INFO:int = 1;
		public static const WARNING:int = 2;
		public static const ERROR:int = 3;
		
		public static const OFF:int = 10;
		
		public static const LOG_LEVEL_DESC:Array = ["[DEBUG] - ", "[INFO] - ", "[WARNING] - ", "[ERROR] - "];
				
		public function LogLevel()
		{
			throw new Error("can't create instance.");
		}	
	}
}