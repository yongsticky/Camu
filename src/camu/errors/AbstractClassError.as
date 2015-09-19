package camu.errors
{
	public class AbstractClassError extends Error
	{
		public function AbstractClassError(message:*="ERROR - Try to instance an abstract class.", id:*=0)
		{
			super(message, id);
		}
	}
}