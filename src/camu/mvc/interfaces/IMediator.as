package camu.mvc.interfaces
{
	import camu.mvc.Notification;

	public interface IMediator
	{
		function onRegister() : void;
		function onUnregister() : void;
				
		function sendNotification(notification:Notification) : void;		
	}
}