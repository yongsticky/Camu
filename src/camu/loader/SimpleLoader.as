package camu.loader
{
	public class SimpleLoader extends DefaultLoader
	{
		public function SimpleLoader(id:String, url:String, handler:ILoaderEventHandler = null)
		{
			super(null, handler);

			var task:LoaderTask = new LoaderTask();
			task.id = id;
			task.url = url;

			add(task);
		}
	}	
}