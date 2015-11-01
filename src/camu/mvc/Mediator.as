package camu.mvc
{
	import camu.errors.AbstractFunctionError;
	import camu.mvc.interfaces.IMediator;
	
	public class Mediator implements IMediator
	{		
		public function Mediator()
		{
			
		}
		
		public function onRegister() : void
		{
		}
		
		public function onUnregister() : void
		{
		}
		
		public function isInterestedNotification(name:String) : Boolean
		{
			return false;
		}
		
		public function onNotify(notification:Notification) : void
		{
			
		}
				
		public function sendNotification(notification:Notification) : void
		{
			getFacade().sendNotification(notification);
		}
		
		protected function getFacade() : Facade
		{			
			throw new AbstractFunctionError();
		}
	}
}