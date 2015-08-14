package camu.object
{
	public interface IObjectFactory
	{
		function createInstance(cls:Class) : *;
		function destroyInstance(obj:*) : void;
	}
}