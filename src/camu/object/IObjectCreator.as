package camu.object
{
	public interface IObjectCreator
	{
		function createObject(cls:Class, data:*) : *;
		function onCreated(obj:*, data:*) : void;
		function destoryObject(obj:*): void;
		function onDestroy(obj:*) : void;
	}
}