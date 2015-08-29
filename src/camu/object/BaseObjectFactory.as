package camu.object
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import camu.logger.ILogger;
	import camu.logger.LEVEL;
	import camu.logger.Logger;	
	
	public class BaseObjectFactory
	{
		protected var _objCache:IObjectCache = null;
		protected var _dictClsCreator:Dictionary = null; 
		
		private var _logger:ILogger = null;
		
		public function BaseObjectFactory(objCache:IObjectCache = null)
		{
			_logger = Logger.createLogger(BaseObjectFactory, LEVEL.ERROR);
			
			_dictClsCreator = new Dictionary();
			
			if (!objCache)
			{
				_logger.log("constructor, use DefaultObjectCache.", LEVEL.INFO);
				_objCache = new DefaultObjectCache();
			}
			else
			{
				_logger.log("constructor, use passed ObjectCache.", LEVEL.INFO);
				_objCache = objCache;
			}
			
			registerClass(ByteArray);			
		}
		
		public function registerClass(cls:Class, creator:IObjectCreator = null) : Boolean
		{
			var key:String = getQualifiedClassName(cls);
			
			if (_dictClsCreator.hasOwnProperty(key))
			{
				_logger.log("class [",getQualifiedClassName(cls), "] already registered.", LEVEL.WARNING);
				
				return false;	// 已经注册了
			}
			
			_logger.log("register class [",getQualifiedClassName(cls), "] succ.", LEVEL.DEBUG);
			
			_dictClsCreator[key] = creator;
			
			return true;
		}
		
		public function createInstance(cls:Class, data:* = null) : *
		{
			_logger.log("createInstance, Enter", LEVEL.DEBUG);
			
			_logger.log("createInstance, class = [",getQualifiedClassName(cls), "].", LEVEL.INFO);
			
			var key:String = getQualifiedClassName(cls);
			if (_dictClsCreator.hasOwnProperty(key))
			{
				var obj:* = null
				if (_objCache)	// 是否使用了cache
				{
					_logger.log("createInstance, use Object Cache.", LEVEL.DEBUG);
					obj = _objCache.popObject(cls);
				}
				
				if (!obj)
				{
					_logger.log("createInstance, alloc new instance.", LEVEL.DEBUG);
					
					// 是否设置了Creator
					var creator:IObjectCreator = _dictClsCreator[key];
					if (creator)
					{
						_logger.log("createInstance, class implements IObjectCreator, use Creator alloc.", LEVEL.DEBUG);

						obj = creator.createObject(data);		// 使用Creator创建
					}
					else
					{
						_logger.log("createInstance, new class directly.", LEVEL.DEBUG);
						obj = new cls();		// 使用new创建
					
					}
				}
				
				
				if (obj is IObjectInit)
				{
					(obj as IObjectInit).onObjectCreated(this);
				}
				
				_logger.log("createInstance, object has been created.", LEVEL.INFO);
				return obj;
			}
			
			_logger.log("createInstance, class[",getQualifiedClassName(cls), "] not registered.", LEVEL.ERROR);			
			return null;
		}
		
		public function destroyInstance(obj:*) : void
		{
			_logger.log("destroyInstance, Enter", LEVEL.DEBUG);
				
			
			if (!obj)
			{
				return;
			}
			
			if (obj is IObjectInit)
			{
				(obj as IObjectInit).onObjectDestroy();
			}
			
			_logger.log("destroyInstance, class = [",getQualifiedClassName(obj), "].", LEVEL.INFO);
			
			var key:String = ObjectUtil.getQualifiedSubclassName(obj);		// 处理子类对象
			if (_dictClsCreator.hasOwnProperty(key))
			{				
				if (_objCache)
				{
					if (_objCache.pushObject(obj))		// 回收成功
					{
						_logger.log("destroyInstance, Object has been recycled.", LEVEL.INFO);
						return;
					}
				}
				
				_logger.log("destroyInstance, dispose Object.", LEVEL.INFO);
				
				var creator:IObjectCreator = _dictClsCreator[key];
				if (creator)
				{
					creator.destoryObject(obj);			// 使用creator来销毁
				}				
			}
			
			_logger.log("destroyInstance, class [", getQualifiedClassName(obj), "] not reigistered.", LEVEL.WARNING);
		}
	}
}