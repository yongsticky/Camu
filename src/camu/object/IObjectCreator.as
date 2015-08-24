package camu.object
{
	public interface IObjectCreator
	{
		function createObject(...args) : *;
		function destoryObject(obj:*): void;
	}
}