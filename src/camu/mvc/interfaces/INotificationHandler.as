package camu.mvc.interfaces
{
	import camu.mvc.Notification;

	public interface INotificationHandler
	{		
		function execute(notification:Notification) : void;
	}
}