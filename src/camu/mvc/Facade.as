package camu.mvc
{	
	import flash.utils.Dictionary;
	
	import camu.errors.NullObjectError;
	import camu.mvc.interfaces.IMediator;
	import camu.mvc.interfaces.INotificationHandler;

	public class Facade
	{
		protected var _handlers:Dictionary;
		protected var _mediators:Dictionary;
		
		
		public function Facade()
		{
			_handlers = new Dictionary();
			_mediators = new Dictionary();						
		}		
		
		public function registerHandler(name:String, handler:INotificationHandler) : void
		{
			if (!name || !handler)
			{				
				throw new NullObjectError();
			}
			
			_handlers[name] = handler;			
		}
		
		public function unregisterHandler(name:String) : void
		{
			if (!name)
			{
				throw new NullObjectError();
			}
			
			if (_handlers.hasOwnProperty(name))
			{				
				_handlers[name] = null;
				delete _handlers[name];
			}
		}		
		
		internal function retrieveHandler(name:String) : INotificationHandler
		{
			if (!name)
			{
				throw new NullObjectError();
			}
			
			if (_handlers.hasOwnProperty(name))
			{
				return _handlers[name] as INotificationHandler;
			}
			
			return null;
		}
		
		public function registerMediator(name:String, mediator:IMediator) : void
		{
			if (!name || !mediator)
			{				
				throw new NullObjectError();
			}
			
			_mediators[name] = mediator;
			mediator.onRegister();
		}
		
		public function unregisterMediator(name:String) : void
		{
			if (!name)
			{
				throw new NullObjectError();
			}
						
			if (_mediators.hasOwnProperty(name))
			{
				(_mediators[name] as IMediator).onUnregister();
				
				_mediators[name] = null;
				delete _mediators[name];
			}
		}
		
		internal function retrieveMediator(name:String) : IMediator
		{
			if (!name)
			{
				throw new NullObjectError();
			}
			
			if (_mediators.hasOwnProperty(name))
			{
				return _mediators[name] as IMediator;
			}
			
			return null;
		}
		
		internal function sendNotification(notification:Notification) : void
		{
			if (notification)
			{
				var name:String = notification.getName();
				
				var handler:INotificationHandler = retrieveHandler(name);
				if (handler)
				{
					handler.execute(notification);	
				}				
			}
		}		
	}
}

class PrivateInner
{
	
}