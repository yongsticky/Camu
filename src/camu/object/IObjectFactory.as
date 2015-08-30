package camu.object
{
	public interface IObjectFactory
	{
		function registerClass(cls:Class, props:Object) : void;
		function createInstance(cls:Class, data:*) : *;
		function destroyInstance(obj:*) : void;
	}
}