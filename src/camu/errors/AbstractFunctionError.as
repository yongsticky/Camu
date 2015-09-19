package camu.errors
{
	public class AbstractFunctionError extends Error
	{
		public function AbstractFunctionError(message:*="ERROR - Try to call an abstract function.", id:*=0)
		{
			super(message, id);
		}
	}
}