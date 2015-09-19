package camu.errors
{
	public class NullObjectError extends Error
	{
		public function NullObjectError(message:*="ERROR - Unexpected null object.", id:*=0)
		{
			super(message, id);
		}
	}
}