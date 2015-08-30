package camu.object
{	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import camu.logger.ILogger;
	import camu.logger.LEVEL;
	import camu.logger.Logger;

	public class DefaultObjectContainer implements IObjectContainer
	{		
		private var _logger:ILogger = null;			
		
		protected var _objects:Dictionary = null;		
		
		public function DefaultObjectContainer()
		{
			_logger = Logger.createLogger(DefaultObjectContainer, LEVEL.ERROR);
			
			_logger.log("constructor", LEVEL.DEBUG);
			
			_objects = new Dictionary();
		}
		
		public function pushObject(obj:*) : void
		{
			_logger.log("pushObject Enter", LEVEL.DEBUG);
			
			var key:String = ObjectUtil.getQualifiedSubclassName(obj);
			_logger.log("pushObject, obj's ClassName=", key, LEVEL.DEBUG);
			if (!_objects.hasOwnProperty(key))
			{
				_logger.log("pushObject, first appear, create key[", key, "]", LEVEL.DEBUG);	
				_objects[key] = new Vector.<Object>();
			}
			
			_objects[key].push(obj);
			
			_logger.log("recycle object [", key ,"] to container complete.", LEVEL.INFO);						
		}
		
		public function popObject(cls:Class) : *
		{
			_logger.log("popObject Enter", LEVEL.DEBUG);
			
			
			var key:String = getQualifiedClassName(cls);	
			
			_logger.log("popObject, ClassName=[", key, "]", LEVEL.DEBUG);
			
			if (_objects.hasOwnProperty(key) && _objects[key].length > 0)
			{
				_logger.log("popObject, pop one from cache", LEVEL.DEBUG);
				
				var obj:Object = _objects[key].pop();
				if (_objects[key].length == 0)
				{
					_logger.log("popObject, after pop one, there's no object remain, delete kee.", LEVEL.DEBUG);
					delete _objects[key];
				}
				
				_logger.log("pop object [", key, "] from container complete.", LEVEL.INFO);				
				
				return obj;
			}
			else
			{
				_logger.log("popObject, there's no cache or cache is empty.", LEVEL.DEBUG);
				
				return null;
			}
				
		}		
		
		public function peekObject(obj:*) : int
		{
			var key:String = ObjectUtil.getQualifiedSubclassName(obj);	
			
			var num:int = 0;
			if (_objects.hasOwnProperty(key))
			{
				num = _objects[key].length;
			}
			
			_logger.log("there is", num, "object [", key, "] in container.", LEVEL.INFO);
			return num;
		}
	}
}