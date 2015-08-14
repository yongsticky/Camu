package camu.loader
{
	import flash.events.Event;

	public interface ILoaderEventHandler
	{
		function onProgress(event:Event) : void;
		function onComplete(event:Event) : void;
		function onError(event:Event) : void;
	}
}