package camu.loader
{
	public final class LoaderTask
	{
		private var _url:String = null;

		private var _props:Object = null;

		private static const ID:String = "id";
		private static const _TYPE:String = "type";
		private static const WEIGHT : String = "weight";
		private static const PRIORITY:String = "priority";
		private static const MAX_TRIES:String = "maxTries";
		private static const HEADERS:String = "headers";
		private static const PREVENT_CACHING:String = "preventCache";
		private static const CONTEXT:String = "context";

		private var _handlers:Object = null;

		private static const PROGRESS_HANDLER:String = "progressHandler";
		private static const COMPLETE_HANDLER:String = "completeHandler";
		private static const ERROR_HANDLER:String = "errorHandler";

		public function LoaderTask()
		{			
			_props = {};
			_handlers = {};
		}

		

		public function get props() : Object
		{
			return _props;
		}

		public function get handlers() : Object
		{
			return _handlers;
		}

		//
		public function get url() : String
		{
			return _url;
		}

		public function set url(url:String) : void
		{
			_url = url;
		}

		// "id"
		public function set id(id:String) : void
		{
			_props[ID] = id;
		}

		public function get id() : String
		{
			if (_props.hasOwnProperty(ID))
			{
				return _props[ID];
			}
			else
			{
				return null;
			}
		}


		// "type"
		public function set _type(_type:String) : void
		{
			_props[_TYPE] = _type;
		}

		public function get _type() : String
		{
			if (_props.hasOwnProperty(_TYPE))
			{
				return _props[_TYPE];
			}
			else
			{
				return null;
			}
		}


		// "weight"
		public function set weight(weight:int) : void
		{
			_props[WEIGHT] = weight;
		}

		public function get weight() : int
		{
			if (_props.hasOwnProperty(WEIGHT))
			{
				return _props[WEIGHT];
			}
			else
			{
				return null;
			}	
		}


		// "priority"
		public function set priority(priority:int) : void
		{
			_props[PRIORITY] = priority;
		}

		public function get priority() : int
		{
			if (_props.hasOwnProperty(PRIORITY))
			{
				return _props[PRIORITY];
			}
			else
			{
				return null;
			}	
		}

		
		// "maxTries"
		public function set maxTries(maxTries:int) : void
		{
			_props[MAX_TRIES] = maxTries;
		}

		public function get maxTries() : int
		{
			if (_props.hasOwnProperty(MAX_TRIES))
			{
				return _props[MAX_TRIES];
			}
			else
			{
				return null;
			}	
		}


		// "headers"
		public function set headers(headers:Array) : void
		{
			_props[HEADERS] = headers;
		}

		public function get headers() : Array
		{
			if (_props.hasOwnProperty(HEADERS))
			{
				return _props[HEADERS];
			}
			else
			{
				return null;
			}	
		}


		// "headers"
		public function set preventCache(preventCache:Boolean) : void
		{
			_props[PREVENT_CACHING] = headers;
		}

		public function get preventCache() : Boolean
		{
			if (_props.hasOwnProperty(PREVENT_CACHING))
			{
				return _props[PREVENT_CACHING];
			}
			else
			{
				return null;
			}	
		}

		// "context"
		public function set context(context:*) : void
		{
			_props[CONTEXT] = context;
		}

		public function get context() : *
		{
			if (_props.hasOwnProperty(CONTEXT))
			{
				return _props[CONTEXT];
			}
			else
			{
				return null;
			}	
		}

		// "progressHandler"
		public function set progressHandler(progressHandler:Function) : void
		{
			_handlers[PROGRESS_HANDLER] = progressHandler;
		}

		public function get progressHandler() : Function
		{
			if (_handlers.hasOwnProperty(PROGRESS_HANDLER))
			{
				return _handlers[PROGRESS_HANDLER];
			}
			else
			{
				return null;
			}	
		}

		// "completeHandler"
		public function set completeHandler(completeHandler:Function) : void
		{
			_handlers[COMPLETE_HANDLER] = completeHandler;
		}

		public function get completeHandler() : Function
		{
			if (_handlers.hasOwnProperty(COMPLETE_HANDLER))
			{
				return _handlers[COMPLETE_HANDLER];
			}
			else
			{
				return null;
			}	
		}

		// "errorHandler"
		public function set errorHandler(errorHandler:Function) : void
		{
			_handlers[ERROR_HANDLER] = errorHandler;
		}

		public function get errorHandler() : Function
		{
			if (_handlers.hasOwnProperty(ERROR_HANDLER))
			{
				return _handlers[ERROR_HANDLER];
			}
			else
			{
				return null;
			}	
		}
		
	}
}