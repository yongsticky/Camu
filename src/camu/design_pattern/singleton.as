package camu.design_pattern
{
	import flash.utils.getQualifiedClassName;

	public class Singleton
	{
		public static var _instance:Singleton = null;

		private var _inner:Inner = null;		
		public function Singleton(inner:Inner)
		{
			_inner = inner;
		}

		public static function init(singletons:Array) : void
		{
			if (!_instance)
			{
				_instance = new Singleton(new Inner(singletons));
			}
			else
			{
				throw new Error("singleton class call init more than once.");
			}
		}
		
		public static function add(obj:*) : void
		{
			if (!_instance)
			{
				if (obj)
				{
					_instance._inner.set(obj);
				}
			}
			else
			{
				throw new Error("singleton class call init more than once.");
			}
		}

		public static function instanceOf(cls:Class) : *
		{
			if (_instance)
			{
				var key:String = getQualifiedClassName(cls);
				var obj:* = _instance._inner.get(key);
				if (obj is cls)
				{
					return obj;
				}
				else
				{
					throw new Error("Wrong Class Type!");
				}

			}
			else
			{
				throw new Error("singleton class not init!");
			}		
		}
	}
}


import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

class Inner
{
	private var _dictSingleton:Dictionary = null;

	public function Inner(singletons:Array)
	{
		_dictSingleton = new Dictionary();

		for each(var item:* in singletons)
		{
			_dictSingleton[getQualifiedClassName(item)] = item;
		}
		
	}

	public function get(key:String) : *
	{
		if (key)
		{
			if (_dictSingleton.hasOwnProperty(key))
			{				
				return _dictSingleton[key];
			}
		}

		return null;
	}
	
	public function set(obj:*) : void
	{
		var key:String = getQualifiedClassName(obj);
		if (key)
		{
			_dictSingleton[key] = obj;
		}
	}
}