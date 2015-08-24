package camu.object
{	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import camu.util.log.ILogger;
	import camu.util.log.LogLevel;
	import camu.util.log.Logger;

	public class DefaultObjectCache implements IObjectCache
	{
		
		private var _logger:ILogger = null;
		
		private const MAX_CACHE_SIZE_PER_CLASS:uint = 64;
		private var _dictCache:Dictionary = null;
		
		
		public function DefaultObjectCache()
		{
			_logger = Logger.createLogger(DefaultObjectCache, LogLevel.DEBUG);
			
			_dictCache = new Dictionary();						
		}
		
		public function pushObject(obj:*) : Boolean
		{
			_logger.log("pushObject, Enter.", LogLevel.DEBUG);
			
			var key:String = ObjectUtil.getQualifiedSubclassName(obj);			
			
			_logger.log("pushObject, get Object subclass name = [", key, "].", LogLevel.INFO);
			
			if (!_dictCache.hasOwnProperty(key))
			{
				_dictCache[key] = new Vector.<Object>();
				_dictCache[key].push(obj);
				
				_logger.log("pushObject, push object to cache, it's first object.", LogLevel.INFO);
				
				return true;
			}
			else
			{
				if (_dictCache[key].length < MAX_CACHE_SIZE_PER_CLASS)
				{
					_dictCache[key].push(obj);
					
					_logger.log("pushObject, push object to cache.", LogLevel.INFO);
					
					return true;
				}
				
				_logger.log("pushObject, cache object up to MAX_CACHE_SIZE_PER_CLASS.", LogLevel.WARNING);
				
				return false;
			}			
		}
		
		public function popObject(cls:Class) : *
		{
			_logger.log("popObject, Enter.", LogLevel.DEBUG);
			
			var key:String = getQualifiedClassName(cls);
			
			_logger.log("pushObject, get Object subclass name = [", key, "].", LogLevel.INFO);
			
			if (_dictCache.hasOwnProperty(key) && _dictCache[key].length > 0)
			{
				var obj:Object = _dictCache[key].pop();
				if (_dictCache[key].length == 0)
				{
					_logger.log("pushObject, cached object num = 0, delete object list.", LogLevel.DEBUG);
					
					delete _dictCache[key];
				}
				
				_logger.log("pushObject, object has been pop.", LogLevel.INFO);
				
				return obj;
			}
			else
			{
				_logger.log("pushObject, object's class isn't registered.", LogLevel.INFO);
				
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