package camu.net
{
	public interface IObjectHeap
	{
		function objectNew(cls:Class) : *;
		function objectDelete(obj:*) : void;
	}
}