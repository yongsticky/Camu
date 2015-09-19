package camu.errors
{
	public class NoExistPropertyError extends Error
	{
		public function NoExistPropertyError(message:*="ERROR - Property not exist.", id:*=0)
		{
			super(message, id);
		}
	}
}