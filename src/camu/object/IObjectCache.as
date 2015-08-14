package camu.object
{
	public interface IObjectCache
	{
		function pushObject(obj:*) : Boolean;
		function popObject(cls:Class) : *;
		function peekObject(cls:Class) : Boolean;
	}
}