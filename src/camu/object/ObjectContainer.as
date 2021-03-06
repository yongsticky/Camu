package camu.object
{	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import camu.logger.ILogger;
	import camu.logger.LEVEL;
	import camu.logger.Logger;
	import camu.object.interfaces.IObjectContainer;

	public class ObjectContainer implements IObjectContainer
	{		
		protected var _logger:ILogger = null;			
		
		protected var _objects:Dictionary = null;		
		
		public function ObjectContainer()
		{
			_logger = Logger.createLogger(ObjectContainer, LEVEL.ERROR);		
			
			_objects = new Dictionary();
		}
		
		public function pushObject(obj:*) : void
		{			
			var key:String = ObjectUtil.getQualifiedClassName(obj);
			_logger.log(this, "pushObject, obj's ClassName=", key, LEVEL.DEBUG);
			if (!_objects.hasOwnProperty(key))
			{
				_logger.log(this, "pushObject, first appear, create key[", key, "]", LEVEL.DEBUG);	
				_objects[key] = new Vector.<Object>();
			}
			
			_objects[key].push(obj);
			
			_logger.log(this, "recycle object [", key ,"] to container complete.", LEVEL.INFO);						
		}
		
		public function popObject(cls:Class) : *
		{			
			var key:String = getQualifiedClassName(cls);	
			
			_logger.log(this, "popObject, ClassName=[", key, "]", LEVEL.DEBUG);
			
			if (_objects.hasOwnProperty(key) && _objects[key].length > 0)
			{
				_logger.log(this, "popObject, pop one from cache", LEVEL.DEBUG);
				
				var obj:Object = _objects[key].pop();
				if (_objects[key].length == 0)
				{
					_logger.log(this, "popObject, after pop one, there's no object remain, delete kee.", LEVEL.DEBUG);
					delete _objects[key];
				}
				
				_logger.log(this, "pop object [", key, "] from container complete.", LEVEL.INFO);				
				
				return obj;
			}
			else
			{
				_logger.log(this, "popObject, there's no cache or cache is empty.", LEVEL.DEBUG);
				
				return null;
			}
				
		}		
		
		public function peekObject(obj:*) : int
		{
			var key:String = ObjectUtil.getQualifiedClassName(obj);	
			
			var num:int = 0;
			if (_objects.hasOwnProperty(key))
			{
				num = _objects[key].length;
			}
			
			_logger.log(this, "there is", num, "object [", key, "] in container.", LEVEL.INFO);
			return num;
		}
	}
}