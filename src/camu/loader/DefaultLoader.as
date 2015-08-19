package camu.loader
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	

	public class DefaultLoader extends BulkLoader
	{		
		protected var _loaderEventHandler:ILoaderEventHandler = null;
		
		
		public function DefaultLoader(name:String = null, handler:ILoaderEventHandler = null)
		{
			super(name);
			
			_loaderEventHandler = handler;
			
			if (!!_loaderEventHandler)
			{				
				this.addEventListener(BulkLoader.PROGRESS, _loaderEventHandler.onProgress);
				this.addEventListener(BulkLoader.COMPLETE, _loaderEventHandler.onComplete);
				this.addEventListener(BulkLoader.ERROR, _loaderEventHandler.onError);				
			}
		}		

		// 		
		protected function add(task:LoaderTask) : Boolean
		{
			if (!!task)
			{
				var item:LoadingItem =  super.add(task.url, task.props);
				if (!!item)
				{					
					if (!!task.progressHandler)
					{
						item.addEventListener(BulkLoader.PROGRESS, task.progressHandler);
					}

					if (!!task.completeHandler)
					{
						item.addEventListener(BulkLoader.COMPLETE, task.completeHandler);
					}

					if (!!task.errorHandler)
					{
						item.addEventListener(BulkLoader.ERROR, task.errorHandler);
					}
					
					return true;
				}
			}
			
			return false;
		}
		
		protected function destroy() : void
		{
			if (!!_loaderEventHandler)
			{
				this.removeEventListener(BulkLoader.PROGRESS, _loaderEventHandler.onProgress);
				this.removeEventListener(BulkLoader.COMPLETE, _loaderEventHandler.onComplete);
				this.removeEventListener(BulkLoader.ERROR, _loaderEventHandler.onError);
				
				_loaderEventHandler = null;
			}
			
			super.removeAll();
		}		
		
	}
}