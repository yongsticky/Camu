package camu.object
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import camu.util.log.ILogger;
	import camu.util.log.LogLevel;
	import camu.util.log.Logger;
	
	public class BaseObjectFactory implements IObjectFactory
	{
		protected var _objCache:IObjectCache = null;
		protected var _dictClsCreator:Dictionary = null; 
		
		private var _logger:ILogger = null;
		
		public function BaseObjectFactory(objCache:IObjectCache = null)
		{
			_logger = Logger.createLogger(BaseObjectFactory, LogLevel.DEBUG);
			
			_dictClsCreator = new Dictionary();
			
			if (!objCache)
			{
				_logger.log("constructor, use DefaultObjectCache.", LogLevel.INFO);
				_objCache = new DefaultObjectCache();
			}
			else
			{
				_logger.log("constructor, use passed ObjectCache.", LogLevel.INFO);
				_objCache = objCache;
			}
			
			registerClass(ByteArray);									
		}
		
		public function registerClass(cls:Class, creator:IObjectCreator = null) : Boolean
		{
			var key:String = getQualifiedClassName(cls);
			
			if (_dictClsCreator.hasOwnProperty(key))
			{
				_logger.log("class [",getQualifiedClassName(cls), "] already registered.", LogLevel.WARNING);
				
				return false;	// 已经注册了
			}
			
			_logger.log("register class [",getQualifiedClassName(cls), "] succ.", LogLevel.DEBUG);
			
			_dictClsCreator[key] = creator;
			
			return true;
		}
		
		public function createInstance(cls:Class, ...args) : *
		{
			_logger.log("createInstance, Enter", LogLevel.DEBUG);
			
			_logger.log("createInstance, class = [",getQualifiedClassName(cls), "].", LogLevel.INFO);
			
			var key:String = getQualifiedClassName(cls);
			if (_dictClsCreator.hasOwnProperty(key))
			{
				var obj:* = null
				if (_objCache)	// 是否使用了cache
				{
					_logger.log("createInstance, use Object Cache.", LogLevel.DEBUG);
					obj = _objCache.popObject(cls);
				}
				
				if (!obj)
				{
					_logger.log("createInstance, alloc new instance.", LogLevel.DEBUG);
					
					// 是否设置了Creator
					var creator:IObjectCreator = _dictClsCreator[key];
					if (creator)
					{
						_logger.log("createInstance, class implements IObjectCreator, use Creator alloc.", LogLevel.DEBUG);
						if (args.length == 0)
						{
							obj = creator.createObject();
						}
						else
						{
							obj = creator.createObject(args);		// 使用Creator创建
						}
					}
					else
					{
						_logger.log("createInstance, new class directly.", LogLevel.DEBUG);
						if (args.length == 0)
						{
							obj = new cls();		// 使用new创建
						}
						else
						{
							obj = new cls(args);
						}
					}
				}
				
				// 如果对象实现了IObjectInit接口，需要调用onObjectCreate
				var objInit:IObjectInit = obj as IObjectInit;
				if (objInit)
				{
					_logger.log("createInstance, class implements IObjectInit.", LogLevel.DEBUG);
					objInit.onObjectCreate();
				}
				
				_logger.log("createInstance, object has been created.", LogLevel.INFO);
				return obj;
			}
			
			_logger.log("createInstance, class[",getQualifiedClassName(cls), "] not registered.", LogLevel.ERROR);			
			return null;
		}
		
		public function destroyInstance(obj:*) : void
		{
			_logger.log("destroyInstance, Enter", LogLevel.DEBUG);
				
			
			if (!obj)
			{
				return;
			}		
			
			_logger.log("destroyInstance, class = [",getQualifiedClassName(obj), "].", LogLevel.INFO);
			
			var key:String = ObjectUtil.getQualifiedSubclassName(obj);		// 处理子类对象
			if (_dictClsCreator.hasOwnProperty(key))
			{
				// 如果对象实现了IObjectInit接口，需要调用onObjectDestroy
				var objInit:IObjectInit = obj as IObjectInit;
				if (objInit)
				{
					_logger.log("destroyInstance, class implements IObjectInit.", LogLevel.DEBUG);
					objInit.onObjectDestroy();
				}
				
				if (_objCache)
				{
					if (_objCache.pushObject(obj))		// 回收成功
					{
						_logger.log("destroyInstance, Object has been recycled.", LogLevel.INFO);
						return;
					}
				}
				
				_logger.log("destroyInstance, dispose Object.", LogLevel.INFO);
				
				var creator:IObjectCreator = _dictClsCreator[key];
				if (creator)
				{
					creator.destoryObject(obj);			// 使用creator来销毁
				}				
			}
			
			_logger.log("destroyInstance, class [", getQualifiedClassName(obj), "] not reigistered.", LogLevel.WARNING);
		}
	}
}