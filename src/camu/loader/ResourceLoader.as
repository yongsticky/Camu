package camu.loader
{		
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;

	public class ResourceLoader extends EventDispatcher
	{		
		private static const PRELOAD:String = "preload";
		private static const SERVER:String = "server";
		private static const RESLIST:String = "reslist";	
		

		private var _resHolder:IResourceHolder = null;	
		
		public function ResourceLoader(holder:IResourceHolder)
		{
			_resHolder = holder;
		}

		public function loadFromJson(text:String) : void
		{
			var rootObj:Object = JSON.parse(text);
			if (rootObj)
			{
				for (var sceneId:String in rootObj)
				{					
					var loader:BulkLoader = new BulkLoader(sceneId);
									
					loader.addEventListener(BulkLoader.COMPLETE, onLoaderComplete);
					loader.addEventListener(BulkLoader.PROGRESS, onLoaderProgress);
					loader.addEventListener(BulkLoader.ERROR, onLoaderError);
										
					var obj:Object = rootObj[sceneId];					
					if (obj)
					{				
						var resList:Array = obj[RESLIST];
						for each(var props:Object in resList)
						{
							props["id"] = sceneId + "." + props["id"];
							var item:LoadingItem = loader.add(obj[SERVER] + props["path"], props);
							if (item)
							{
								item.addEventListener(BulkProgressEvent.COMPLETE, onLoadItemComplete);
								item.addEventListener(BulkLoader.ERROR, onLoadItemError);
							}
						}
						
						if (obj[PRELOAD])
						{
							loader.start();
						}
					}					
				}
			}	
		}	
		
		protected function onLoadItemComplete(event:BulkProgressEvent) : void
		{
			var item:LoadingItem = event.target as LoadingItem;			
			if (item)
			{
				item.removeEventListener(BulkProgressEvent.COMPLETE, onLoadItemComplete);
								
				if (item.type == BulkLoader.TYPE_MOVIECLIP)
				{
					var clsArr:Vector.<String> = SwfUtil.getSWFClassName(Object(item).loader.contentLoaderInfo.bytes);
						
					for each(var className:String in clsArr)
					{
						var cls:Class = getObjectFromLoadingItem(item, className);
						if (cls)
						{							
							_resHolder.push(item.id+"."+className, new cls());
						}
					}
				}
				else
				{
					_resHolder.push(item.id, item);
				}
				
				var e:ResourceLoaderEvent = new ResourceLoaderEvent(ResourceLoaderEvent.ITEM_COMPLETE);
				e.setTheId(item.id);
				dispatchEvent(e);
			}			
		}

		

		
		protected function onLoadItemError(event:Event) : void
		{			
			
		}
		

		protected function getObjectFromLoadingItem(item:Object, className:String) : *
		{
			try
			{
				return item.loader.contentLoaderInfo.applicationDomain.getDefinition(className);
			}
			catch(error:Error)
			{				
			}
			
			return null;
		}

		
		
		protected function onLoaderComplete(event:BulkProgressEvent) : void
		{			
				
		}		
		
		protected function onLoaderProgress(event:BulkProgressEvent) : void
		{			
		
		}
		
		protected function onLoaderError(event:BulkProgressEvent) : void
		{			
		
		}		
		
		public function loadeResources(sceneId:String) : void
		{
			var loader:BulkLoader = BulkLoader.getLoader(sceneId);
			if (loader)
			{
				if (!loader.isRunning())				
				{
					loader.start();
				}					
			}
		}		
	}
}
