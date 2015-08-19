package camu.object
{
	public interface IObjectCreator
	{
		function createObject(...Args) : *;
		function destoryObject(obj:*): void;
	}
}