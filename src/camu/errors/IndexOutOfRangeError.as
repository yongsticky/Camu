package camu.errors
{
	public class IndexOutOfRangeError extends Error
	{
		public function IndexOutOfRangeError(message:*="ERROR - index out of range.", id:*=0)
		{
			super(message, id);
		}
	}
}