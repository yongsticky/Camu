package camu.object
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class DefaultObjectCache implements IObjectCache
	{
		private const MAX_CACHE_SIZE_PER_CLASS:uint = 64;
		private var _dictCache:Dictionary = null;
		public function DefaultObjectCache()
		{
			_dictCache = new Dictionary();
		}
		
		public function pushObject(obj:*) : Boolean
		{
			var key:String = ObjectUtil::getQualifiedSubclassName(obj);			
			
			if (!_dictCache.hasOwnProperty(key))
			{
				_dictCache[key] = new Vector.<Object>();
				_dictCache[key].push(obj);
				
				return true;
			}
			else
			{
				if (_dictCache[key].length < MAX_CACHE_SIZE_PER_CLASS)
				{
					_dictCache[key].push(obj);
					
					return true;
				}
				
				return false;
			}			
		}
		
		public function popObject(cls:Class) : *
		{
			var key:String = getQualifiedClassName(cls);
			
			if (_dictCache.hasOwnProperty(key) && _dictCache[key].length > 0)
			{
				var obj:Object = _dictCache[key].pop();
				if (_dictCache[key].length == 0)
				{
					delete _dictCache[key];
				}
				
				return obj;
			}
			else
			{
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