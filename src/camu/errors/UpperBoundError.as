package camu.errors
{
	public class UpperBoundError extends Error
	{
		public function UpperBoundError(message:*="ERROR - upper bound.", id:*=0)
		{
			super(message, id);
		}
	}
}