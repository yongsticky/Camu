package camu.mvc.interfaces
{
	import camu.mvc.Notification;

	public interface IMediator
	{
		function onRegister() : void;
		function onUnregister() : void;
		function isInterestedNotification(name:String) : Boolean;
		function onNotify(notification:Notification) : void;
				
		function sendNotification(notification:Notification) : void;		
	}
}