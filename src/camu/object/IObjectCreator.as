package camu.object
{
	public interface IObjectCreator
	{
		function createObject() : *;
		function destoryObject(obj:*): void;
	}
}