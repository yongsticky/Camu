package camu.net
{
	public interface IObjectHeap
	{
		function objectNew(cls:Class, ...args) : *;
		function objectDelete(obj:*) : void;
	}
}