package camu.object
{
	public interface IObjectCreator
	{
		function createObject(...args) : *;
		function setCreatedData(obj:*, ...args) : void;
		function destoryObject(obj:*): void;
	}
}