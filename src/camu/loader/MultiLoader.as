package camu.loader
{
	public class MultiLoader extends DefaultLoader
	{
		public function MultiLoader(name:String, tasks:Vector.<LoaderTask>, handler:ILoaderEventHandler)
		{
			super(name, handler);
	
			for each(var task:LoaderTask in tasks)
			{
				add(task);
			}
			
		}		
	}
}