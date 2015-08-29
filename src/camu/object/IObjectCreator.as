package camu.object
{
	public interface IObjectCreator
	{
		function createObject(data : *) : *;
		function destoryObject(obj : *): void;
	}
}