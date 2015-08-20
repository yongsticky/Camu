package camu.object
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class DefaultObjectFactory implements IObjectFactory
	{
		protected var _objCache:IObjectCache = null;
		protected var _dictClsCreator:Dictionary = null; 
		
		public function DefaultObjectFactory(objCache:IObjectCache = null)
		{
			_dictClsCreator = new Dictionary();
			
			if (!objCache)
			{
				_objCache = new DefaultObjectCache();
			}
		}
		
		public function registerClass(cls:Class, creator:IObjectCreator) : Boolean
		{
			var key:String = getQualifiedClassName(cls);
			
			if (_dictClsCreator.hasOwnProperty(key))
			{
				return false;	// 已经注册了
			}
			
			_dictClsCreator[key] = creator;
			
			return true;
		}
		
		public function createInstance(cls:Class, ...args) : *
		{			
			var key:String = getQualifiedClassName(cls);
			if (_dictClsCreator.hasOwnProperty(key))
			{
				var obj:* = null
				if (_objCache)	// 是否使用了cache
				{
					obj = _objCache.popObject(cls);
				}
				
				if (!obj)
				{
					// 是否设置了Creator
					var creator:IObjectCreator = _dictClsCreator[key];
					if (creator)
					{
						obj = creator.createObject(args);		// 使用Creator创建
					}
					else
					{
						obj = new cls(args);		// 使用new创建
					}
				}
				
				// 如果对象实现了IObjectInit接口，需要调用onObjectCreate
				var objInit:IObjectInit = obj as IObjectInit;
				if (objInit)
				{
					objInit.onObjectCreate();
				}
				
				return obj;
			}			
		}
		
		public function destroyInstance(obj:*) : void
		{
			if (!obj)
			{
				return;
			}		
			
			var key:String = ObjectUtil::getQualifiedSubclassName(obj);		// 处理子类对象
			if (_dictClsCreator.hasOwnProperty(key))
			{
				// 如果对象实现了IObjectInit接口，需要调用onObjectDestroy
				var objInit:IObjectInit = obj as IObjectInit;
				if (objInit)
				{
					objInit.onObjectDestroy();
				}
				
				if (_objCache)
				{
					if (_objCache.pushObject(obj))		// 回收成功
					{						
						return;
					}
				}
				
				var creator:IObjectCreator = _dictClsCreator[key];
				if (creator)
				{
					creator.destoryObject(obj);			// 使用creator来销毁
				}				
			}
		}
	}
}