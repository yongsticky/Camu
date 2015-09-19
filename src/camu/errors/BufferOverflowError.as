package camu.errors
{
	public class BufferOverflowError extends Error
	{
		public function BufferOverflowError(message:*="ERROR - Buffer overflow.", id:*=0)
		{
			super(message, id);
		}
	}
}