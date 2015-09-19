package camu.errors
{
	public class UnhandledBranchError extends Error
	{
		public function UnhandledBranchError(message:*="ERROR - Unhandled Branch.", id:*=0)
		{
			super(message, id);
		}
	}
}