package camu.errors
{
	public class UnexpectedLengthError extends Error
	{
		public function UnexpectedLengthError(message:*="ERROR - Unexpected length.", id:*=0)
		{
			super(message, id);
		}
	}
}