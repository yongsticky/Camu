package camu.object
{
	public interface IObjectContainer
	{
		function pushObject(obj:*) : void;
		function popObject(cls:Class) : *;
		function peekObject(obj:*) : int;
	}
}