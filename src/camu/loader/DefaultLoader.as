package camu.loader
{
	import flash.media.Sound;
	import flash.display.Bitmap;	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	

	public class DefaultLoader extends EventDispatcher implements ILoader
	{		
		protected var _bulkLoader:BulkLoader = null;
		protected var _loaderEventHandler:ILoaderEventHandler = null;
		
		
		public function DefaultLoader(name:String = null, handler:ILoaderEventHandler = null)
		{
			_bulkLoader = new BulkLoader(name);			
			
			_loaderEventHandler = handler;
			
			if (!!_loaderEventHandler)
			{				
				_bulkLoader.addEventListener(BulkLoader.PROGRESS, _loaderEventHandler.onProgress);
				_bulkLoader.addEventListener(BulkLoader.COMPLETE, _loaderEventHandler.onComplete);
				_bulkLoader.addEventListener(BulkLoader.ERROR, _loaderEventHandler.onError);
			}
		}

		
		public function start() : void
		{
			if (!!_bulkLoader)
			{
				if (!_bulkLoader.isRunning && ! _bulkLoader.isRunning)
				{
					_bulkLoader.start();
				}
				else
				{
					throw new Error("_bulkLoader already runing|finished.");
				}
			}
		}

		public function getContent(id:String, clearMemory:Boolean = false) : *
		{
			if (!!_bulkLoader)
			{
				return _bulkLoader.getContent(id, clearMemory);
			}
			else
			{
				return null;
			}
		}

		public function getBitmap(id:String, clearMemory:Boolean = false) : Bitmap
		{
			if (!!_bulkLoader)
			{
				return _bulkLoader.getBitmap(id, clearMemory);
			}
			else
			{
				return null;
			}
		}

		public function getSound(id:String, clearMemory:Boolean = false) : Sound
		{
			if (!!_bulkLoader)
			{
				return _bulkLoader.getSound(id, clearMemory);
			}
			else
			{
				return null;
			}
		}

		public function getText(id:String, clearMemory:Boolean = false) : String
		{
			if (!!_bulkLoader)
			{
				return _bulkLoader.getText(id, clearMemory);
			}
			else
			{
				return null;
			}
		}

		public function getMovieClip(id:String, clearMemory:Boolean = false) : MovieClip
		{
			if (!!_bulkLoader)
			{
				return _bulkLoader.getMovieClip(id, clearMemory);
			}
			else
			{
				return null;
			}
		}

		public function getXML(id:String, clearMemory:Boolean = false) : XML
		{
			if (!!_bulkLoader)
			{
				return _bulkLoader.getXML(id, clearMemory);
			}
			else
			{
				return null;
			}
		}

		// 		
		protected function add(task:LoaderTask) : Boolean
		{
			if (!!_bulkLoader && !!task)
			{
				var item:LoadingItem =  _bulkLoader.add(task.url, task.props);
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
				_bulkLoader.removeEventListener(BulkLoader.PROGRESS, _loaderEventHandler.onProgress);
				_bulkLoader.removeEventListener(BulkLoader.COMPLETE, _loaderEventHandler.onComplete);
				_bulkLoader.removeEventListener(BulkLoader.ERROR, _loaderEventHandler.onError);
				
				_loaderEventHandler = null;
			}
			
			_bulkLoader.removeAll();
			_bulkLoader = null;
		}		
		
	}
}