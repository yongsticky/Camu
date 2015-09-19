package camu.errors
{
	public class ZeroLittleError extends Error
	{
		public function ZeroLittleError(message:*="ERROR - Unexpected zero little value.", id:*=0)
		{
			super(message, id);
		}
	}
}