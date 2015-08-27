package camu.object
{
	public interface IObjectCreator
	{
		function createObject(data:*) : *;
		function setCreatedData(obj:*, data:*) : void;
		function destoryObject(obj:*): void;
	}
}