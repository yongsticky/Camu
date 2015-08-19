package camu.object
{
	public interface IObjectFactory
	{
		function createInstance(cls:Class, ...Args) : *;
		function destroyInstance(obj:*) : void;
	}
}