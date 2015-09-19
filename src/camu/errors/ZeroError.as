package camu.errors
{
	public class ZeroError extends Error
	{
		public function ZeroError(message:*="ERROR - unexpected zero value.", id:*=0)
		{
			super(message, id);
		}
	}
}