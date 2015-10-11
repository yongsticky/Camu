package camu.errors
{
	public class LowerBoundError extends Error
	{
		public function LowerBoundError(message:*="ERROR - lower bound.", id:*=0)
		{
			super(message, id);
		}
	}
}