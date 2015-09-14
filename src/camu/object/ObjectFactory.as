package camu.object
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import camu.logger.ILogger;
	import camu.logger.LEVEL;
	import camu.logger.Logger;
	import camu.object.interfaces.IObjectContainer;	
	import camu.object.interfaces.IObjectRecycled;
	
	public class ObjectFactory
	{
		protected var _logger:ILogger;
		
		protected var _container:IObjectContainer = null;
		protected var _classes:Dictionary = null;
		
		public static const OBJECT_CREATE:String = "objectCreator";
		public static const MAX_CACHE_SIZE:String = "maxCacheSize";
		
		public static const DEFAULT_MAX_CACHE_SIZE:int = 64;
		
		
		public function ObjectFactory(container:IObjectContainer = null)
		{
			_logger = Logger.createLogger(ObjectFactory, LEVEL.WARNING);
			
			_classes = new Dictionary();
			
			if (!container)
			{
				_logger.log(this, "constructor, use DefaultObjectContainer.", LEVEL.INFO);
				_container = new ObjectContainer();
			}
			else
			{
				_logger.log(this, "constructor, use passed in ObjectContainer.", LEVEL.INFO);
				_container = container;
			}
			
			registerClass(ByteArray);
		}
		
		public function registerClass(cls:Class, props:Object = null) : void
		{
			var key:String = getQualifiedClassName(cls);
			
			if (_classes.hasOwnProperty(key))
			{
				_logger.log(this, "class [",getQualifiedClassName(cls), "] already registered.", LEVEL.WARNING);
				return;
			}
			
			_logger.log(this, "register class [",getQualifiedClassName(cls), "] complete.", LEVEL.INFO);
						
			_classes[key] = props ? props:{};			
			
		}
		
		public function createInstance(cls:Class) : *
		{				
			var key:String = getQualifiedClassName(cls);
			if (_classes.hasOwnProperty(key))
			{				
				var curCacheSize:int = _container.peekObject(cls);	
				
				
				var obj:* = null;				
				if (curCacheSize > 0)
				{
					obj = _container.popObject(cls);					
					
					_logger.log(this, "object [Class=", key, "] has been created from cache.", LEVEL.INFO);
				}
				else
				{
					obj = new cls();					
					
					_logger.log(this, "object [Class=", key, "] has been created from new.", LEVEL.INFO);
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
			
			var key:String = ObjectUtil.getQualifiedClassName(obj);		// 处理子类对象
			if (_classes.hasOwnProperty(key))
			{					
				var curCacheSize:int = _container.peekObject(obj);				
				var maxCacheSize:int = safeGetProperty(_classes[key], MAX_CACHE_SIZE);
				if (maxCacheSize <= 0)
				{
					maxCacheSize = DEFAULT_MAX_CACHE_SIZE;
				}
				
				// 先销毁内部对象
				var recycled:IObjectRecycled = obj as IObjectRecycled;
				if (recycled)
				{
					recycled.onObjectRecycled();
				}
				
				// 是否已经到缓存数量的上限了
				if (curCacheSize < maxCacheSize)
				{					
					_container.pushObject(obj);
					_logger.log(this, "object [Class=", key, "] has been recycled to cache.", LEVEL.INFO);
				}
				else
				{
					// 缓存满了，直接删除	
					_logger.log(this, "curCacheSize=",curCacheSize, "object [Class=", key, "] has been destroy directly.", LEVEL.WARNING);
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