package camu.design_pattern
{
	import flash.utils.getQualifiedClassName;

	public class singleton
	{
		public static var _instance:singleton = null;

		private var _inner:Inner = null;		
		public function singleton(inner:Inner)
		{
			_inner = inner;
		}

		public static function init(singletons:Array) : void
		{
			if (!_instance)
			{
				_instance = new singleton(new Inner(singletons));
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
				return _instance._inner.get(key);

			}
			else
			{
				throw new Error("singleton class not init.");
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
}