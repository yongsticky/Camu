package camu.object
{	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import camu.logger.ILogger;
	import camu.logger.LEVEL;
	import camu.logger.Logger;

	public class DefaultObjectCache implements IObjectCache
	{
		
		private var _logger:ILogger = null;
		
		private const MAX_CACHE_SIZE_PER_CLASS:uint = 64;
		private var _dictCache:Dictionary = null;
		
		
		public function DefaultObjectCache()
		{
			_logger = Logger.createLogger(DefaultObjectCache, LEVEL.ERROR);
			
			_dictCache = new Dictionary();						
		}
		
		public function pushObject(obj:*) : Boolean
		{
			_logger.log("pushObject, Enter.", LEVEL.DEBUG);
			
			var key:String = ObjectUtil.getQualifiedSubclassName(obj);			
			
			_logger.log("pushObject, get Object subclass name = [", key, "].", LEVEL.INFO);
			
			if (!_dictCache.hasOwnProperty(key))
			{
				_dictCache[key] = new Vector.<Object>();
				_dictCache[key].push(obj);
				
				_logger.log("pushObject, push object to cache, it's first object.", LEVEL.INFO);
				
				return true;
			}
			else
			{
				if (_dictCache[key].length < MAX_CACHE_SIZE_PER_CLASS)
				{
					_dictCache[key].push(obj);
					
					_logger.log("pushObject, push object to cache.", LEVEL.INFO);
					
					return true;
				}
				
				_logger.log("pushObject, cache object up to MAX_CACHE_SIZE_PER_CLASS.", LEVEL.WARNING);
				
				return false;
			}			
		}
		
		public function popObject(cls:Class) : *
		{
			_logger.log("popObject, Enter.", LEVEL.DEBUG);
			
			var key:String = getQualifiedClassName(cls);
			
			_logger.log("popObject, get Object subclass name = [", key, "].", LEVEL.INFO);
			
			if (_dictCache.hasOwnProperty(key) && _dictCache[key].length > 0)
			{
				var obj:Object = _dictCache[key].pop();
				if (_dictCache[key].length == 0)
				{
					_logger.log("popObject, cached object num = 0, delete object list.", LEVEL.DEBUG);
					
					delete _dictCache[key];
				}
				
				_logger.log("popObject, object has been pop.", LEVEL.INFO);
				
				return obj;
			}
			else
			{
				_logger.log("popObject, find no object in cache.", LEVEL.INFO);
				
				return null;
			}
				
		}		
		
		public function peekObject(cls:Class) : Boolean
		{
			var key:String = getQualifiedClassName(cls);
			
			return (_dictCache.hasOwnProperty(key) && _dictCache[key].length > 0);
		}
	}
}