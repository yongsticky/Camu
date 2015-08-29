package camu.object
{
	public interface IObjectInit
	{
		function onObjectCreated(factory:BaseObjectFactory) : void;
		function onObjectDestroy() : void;
	}
}