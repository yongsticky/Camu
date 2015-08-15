package camu.loader
{
	public class MultiLoader extends DefaultLoader
	{
		public function MultiLoader(tasks:Vector.<LoaderTask>, handler:ILoaderEventHandler)
		{
			super(null, handler);

			for (var task:LoaderTask in tasks)
			{
				add(task);
			}
		}		
	}
}