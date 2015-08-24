package camu.object
{
	public interface IObjectFactory
	{
		function createInstance(cls:Class, ...args) : *;
		function destroyInstance(obj:*) : void;
	}
}