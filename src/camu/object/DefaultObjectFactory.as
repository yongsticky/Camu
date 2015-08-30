package camu.object
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import camu.logger.ILogger;
	import camu.logger.LEVEL;
	import camu.logger.Logger;	
	
	public class DefaultObjectFactory
	{
		protected var _container:IObjectContainer = null;
		protected var _classes:Dictionary = null;
		
		public static const OBJECT_CREATE:String = "objectCreator";
		public static const MAX_CACHE_SIZE:String = "maxCacheSize";
		
		public static const DEFAULT_MAX_CACHE_SIZE:int = 64;
		
		private var _logger:ILogger = null;
		
		public function DefaultObjectFactory(container:IObjectContainer = null)
		{
			_logger = Logger.createLogger(DefaultObjectFactory, LEVEL.INFO);
			
			_classes = new Dictionary();
			
			if (!container)
			{
				_logger.log("constructor, use DefaultObjectContainer.", LEVEL.INFO);
				_container = new DefaultObjectContainer();
			}
			else
			{
				_logger.log("constructor, use passed in ObjectContainer.", LEVEL.INFO);
				_container = container;
			}
			
			registerClass(ByteArray);
		}
		
		public function registerClass(cls:Class, props:Object = null) : void
		{
			var key:String = getQualifiedClassName(cls);
			
			if (_classes.hasOwnProperty(key))
			{
				_logger.log("class [",getQualifiedClassName(cls), "] already registered.", LEVEL.WARNING);
				return;
			}
			
			_logger.log("register class [",getQualifiedClassName(cls), "] complete.", LEVEL.INFO);
						
			_classes[key] = props ? props:{};			
			
		}
		
		public function createInstance(cls:Class, data:* = null) : *
		{				
			var key:String = getQualifiedClassName(cls);
			if (_classes.hasOwnProperty(key))
			{				
				var curCacheSize:int = _container.peekObject(cls);				
				var creator:IObjectCreator = safeGetProperty(_classes[key], OBJECT_CREATE);
				
				var obj:* = null;
				if (curCacheSize > 0)
				{
					obj = _container.popObject(cls);
					
					_logger.log("object [Class=", key, "] has been created from cache.", LEVEL.INFO);
				}
				else
				{
					if (creator)
					{
						obj = creator.createObject(cls, data);
					}
					else
					{
						obj = new cls();
					}
					
					_logger.log("object [Class=", key, "] has been created from new.", LEVEL.INFO);
				}
				
				if (obj && creator)
				{
					creator.onCreated(obj, data);		// 对Cache pop出来的对象，给一次重新初始化的机会
				}								
				
				
				return obj;
			}
			else
			{				
				throw new Error("Class [" + key + "] not registered, create object FAILED!");	
			}			
		}
		
		public function destroyInstance(obj:*) : void
		{			
			if (!obj)
			{
				return;
			}		
			
			var key:String = ObjectUtil.getQualifiedSubclassName(obj);		// 处理子类对象
			if (_classes.hasOwnProperty(key))
			{					
				var creator:IObjectCreator = safeGetProperty(_classes[key], OBJECT_CREATE);				
				if (creator)
				{
					creator.onDestroy(obj);
				}
				
				var curCacheSize:int = _container.peekObject(obj);				
				var maxCacheSize:int = safeGetProperty(_classes[key], MAX_CACHE_SIZE);
				if (maxCacheSize <= 0)
				{
					maxCacheSize = DEFAULT_MAX_CACHE_SIZE;
				}				
				
				// 是否已经到缓存数量的上限了
				if (curCacheSize < maxCacheSize)
				{					
					_container.pushObject(obj);
					_logger.log("object [Class=", key, "] has been recycled to cache.", LEVEL.INFO);
				}
				else
				{
					// 缓存满了，直接删除
					if (creator)
					{
						creator.destoryObject(obj);
					}
					_logger.log("object [Class=", key, "] has been destroy directly.", LEVEL.WARNING);
				}
			}
			else
			{
				throw new Error("Class [" + key + "] not registered, destroy object FAILED!");
			}			
		}
		
		private function safeGetProperty(obj:Object, prop:String) : *
		{
			if (obj && obj.hasOwnProperty(prop))
			{
				return obj[prop];	
			}
			else
			{
				return null;
			}
		}
	}
}